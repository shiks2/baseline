"""
Asset analyst service for processing and analyzing indexed assets.
Provides automated analysis of assets including metadata extraction and content processing.
"""

import sys
import os
import time
import json
from typing import List, Dict, Optional
from datetime import datetime
from pathlib import Path

# Add the parent directory to the path so we can import shared modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.database import db_manager
from shared.config import config


class AssetAnalyst:
    """Service class for analyzing and processing indexed assets."""
    
    def __init__(self, analysis_interval: int = 60):
        """
        Initialize the asset analyst.
        
        Args:
            analysis_interval: Seconds between analysis runs (default: 60)
        """
        self.db = db_manager
        self.config = config
        self.analysis_interval = analysis_interval
        self.is_running = False
        self.supported_analysis_types = {
            'image': self._analyze_image,
            'document': self._analyze_document,
            'video': self._analyze_video,
            'audio': self._analyze_audio,
            'code': self._analyze_code
        }
    
    def start_analysis(self, continuous: bool = True) -> bool:
        """
        Start the analysis process.
        
        Args:
            continuous: Whether to run continuously or process once
            
        Returns:
            True if analysis started successfully
        """
        try:
            self.is_running = True
            
            if continuous:
                print(f"Asset analyst started. Running every {self.analysis_interval} seconds.")
                self._run_continuous_analysis()
            else:
                print("Running one-time asset analysis...")
                self._run_single_analysis()
            
            return True
            
        except Exception as e:
            print(f"Error starting asset analyst: {e}")
            self.is_running = False
            return False
    
    def stop_analysis(self):
        """Stop the analysis process."""
        self.is_running = False
        print("Asset analyst stopped.")
    
    def _run_continuous_analysis(self):
        """Run continuous analysis loop."""
        try:
            while self.is_running:
                self._run_single_analysis()
                
                if self.is_running:
                    time.sleep(self.analysis_interval)
                    
        except KeyboardInterrupt:
            print("\nAnalysis interrupted by user.")
        except Exception as e:
            print(f"Error in continuous analysis: {e}")
    
    def _run_single_analysis(self):
        """Run a single analysis cycle."""
        try:
            # Get pending assets
            pending_assets = self.db.get_pending_assets(limit=10)
            
            if not pending_assets:
                return
            
            print(f"Analyzing {len(pending_assets)} pending assets...")
            
            for asset in pending_assets:
                try:
                    self._analyze_asset(asset)
                except Exception as e:
                    print(f"Error analyzing asset {asset['id']}: {e}")
                    # Mark asset as error to avoid reprocessing
                    self.db.update_asset_status(asset['id'], 'error')
            
            print(f"Analysis cycle completed.")
            
        except Exception as e:
            print(f"Error in single analysis cycle: {e}")
    
    def _analyze_asset(self, asset: Dict):
        """Analyze a single asset."""
        asset_id = asset['id']
        file_path = asset['path']
        category = asset.get('category', 'Uncategorized')
        
        print(f"Analyzing: {asset['name']} (ID: {asset_id})")
        
        # Validate file exists
        if not Path(file_path).exists():
            print(f"File not found: {file_path}")
            self.db.update_asset_status(asset_id, 'error')
            return
        
        # Get appropriate analysis function based on category
        analysis_func = self.supported_analysis_types.get(category.lower())
        
        if analysis_func:
            try:
                metadata = analysis_func(file_path)
                if metadata:
                    # Store metadata
                    for key, value in metadata.items():
                        self.db.add_asset_metadata(asset_id, key, str(value))
                
                # Mark as analyzed
                self.db.update_asset_status(asset_id, 'analyzed')
                print(f"Analysis complete for: {asset['name']}")
                
            except Exception as e:
                print(f"Analysis failed for {asset['name']}: {e}")
                self.db.update_asset_status(asset_id, 'error')
        else:
            # No specific analysis available, mark as analyzed
            self.db.update_asset_status(asset_id, 'analyzed')
            print(f"No analysis available for category: {category}")
    
    def _analyze_image(self, file_path: str) -> Optional[Dict]:
        """Analyze image files."""
        try:
            metadata = {}
            
            # Try to extract EXIF data if available
            try:
                from PIL import Image
                from PIL.ExifTags import TAGS
                
                with Image.open(file_path) as img:
                    metadata['width'] = img.width
                    metadata['height'] = img.height
                    metadata['format'] = img.format
                    metadata['mode'] = img.mode
                    
                    # Extract EXIF data
                    if hasattr(img, '_getexif') and img._getexif():
                        exif = {}
                        for tag_id, value in img._getexif().items():
                            tag = TAGS.get(tag_id, tag_id)
                            exif[tag] = value
                        metadata['exif'] = json.dumps(exif)
                        
                        # Extract common EXIF fields
                        if 'DateTime' in exif:
                            metadata['date_taken'] = exif['DateTime']
                        if 'Make' in exif and 'Model' in exif:
                            metadata['camera'] = f"{exif['Make']} {exif['Model']}"
                        
            except ImportError:
                metadata['analysis_note'] = 'PIL not available for detailed image analysis'
            except Exception as e:
                metadata['analysis_error'] = f'EXIF extraction failed: {e}'
            
            return metadata
            
        except Exception as e:
            print(f"Error analyzing image {file_path}: {e}")
            return None
    
    def _analyze_document(self, file_path: str) -> Optional[Dict]:
        """Analyze document files."""
        try:
            metadata = {}
            
            # Basic document analysis
            path = Path(file_path)
            metadata['extension'] = path.suffix.lower()
            
            # Try to extract text content for text-based documents
            if path.suffix.lower() == '.txt':
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        metadata['line_count'] = len(content.splitlines())
                        metadata['char_count'] = len(content)
                        metadata['word_count'] = len(content.split())
                except Exception as e:
                    metadata['text_analysis_error'] = str(e)
            
            elif path.suffix.lower() == '.pdf':
                try:
                    import PyPDF2
                    with open(file_path, 'rb') as f:
                        pdf_reader = PyPDF2.PdfReader(f)
                        metadata['page_count'] = len(pdf_reader.pages)
                        
                        # Try to extract basic metadata
                        if pdf_reader.metadata:
                            meta = pdf_reader.metadata
                            if meta.title:
                                metadata['title'] = meta.title
                            if meta.author:
                                metadata['author'] = meta.author
                            if meta.subject:
                                metadata['subject'] = meta.subject
                            
                except ImportError:
                    metadata['analysis_note'] = 'PyPDF2 not available for PDF analysis'
                except Exception as e:
                    metadata['pdf_analysis_error'] = str(e)
            
            return metadata
            
        except Exception as e:
            print(f"Error analyzing document {file_path}: {e}")
            return None
    
    def _analyze_video(self, file_path: str) -> Optional[Dict]:
        """Analyze video files."""
        try:
            metadata = {}
            
            # Basic video analysis
            try:
                import cv2
                
                cap = cv2.VideoCapture(file_path)
                if cap.isOpened():
                    metadata['width'] = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
                    metadata['height'] = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
                    metadata['fps'] = cap.get(cv2.CAP_PROP_FPS)
                    metadata['frame_count'] = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
                    metadata['duration_seconds'] = metadata['frame_count'] / metadata['fps'] if metadata['fps'] > 0 else 0
                    
                    cap.release()
                    
            except ImportError:
                metadata['analysis_note'] = 'OpenCV not available for video analysis'
            except Exception as e:
                metadata['video_analysis_error'] = str(e)
            
            return metadata
            
        except Exception as e:
            print(f"Error analyzing video {file_path}: {e}")
            return None
    
    def _analyze_audio(self, file_path: str) -> Optional[Dict]:
        """Analyze audio files."""
        try:
            metadata = {}
            
            # Basic audio analysis
            try:
                import mutagen
                
                audio = mutagen.File(file_path)
                if audio:
                    metadata['duration_seconds'] = getattr(audio.info, 'length', None)
                    metadata['bitrate'] = getattr(audio.info, 'bitrate', None)
                    metadata['sample_rate'] = getattr(audio.info, 'sample_rate', None)
                    
                    # Extract tags if available
                    if audio.tags:
                        tags = {}
                        for key, value in audio.tags.items():
                            if hasattr(value, 'text'):
                                tags[key] = value.text[0] if value.text else None
                            else:
                                tags[key] = str(value)
                        metadata['tags'] = json.dumps(tags)
                        
                        # Extract common fields
                        if 'title' in tags:
                            metadata['title'] = tags['title']
                        if 'artist' in tags:
                            metadata['artist'] = tags['artist']
                        if 'album' in tags:
                            metadata['album'] = tags['album']
                        
            except ImportError:
                metadata['analysis_note'] = 'Mutagen not available for audio analysis'
            except Exception as e:
                metadata['audio_analysis_error'] = str(e)
            
            return metadata
            
        except Exception as e:
            print(f"Error analyzing audio {file_path}: {e}")
            return None
    
    def _analyze_code(self, file_path: str) -> Optional[Dict]:
        """Analyze code files."""
        try:
            metadata = {}
            
            path = Path(file_path)
            metadata['language'] = self._get_programming_language(path.suffix.lower())
            
            # Basic code metrics
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    
                    metadata['line_count'] = len(lines)
                    metadata['char_count'] = sum(len(line) for line in lines)
                    metadata['empty_line_count'] = sum(1 for line in lines if line.strip() == '')
                    metadata['comment_line_count'] = sum(1 for line in lines if line.strip().startswith(('#', '//', '/*', '*', '--')))
                    
            except Exception as e:
                metadata['code_analysis_error'] = str(e)
            
            return metadata
            
        except Exception as e:
            print(f"Error analyzing code {file_path}: {e}")
            return None
    
    def _get_programming_language(self, extension: str) -> str:
        """Get programming language from file extension."""
        language_map = {
            '.py': 'Python',
            '.js': 'JavaScript',
            '.html': 'HTML',
            '.css': 'CSS',
            '.json': 'JSON',
            '.xml': 'XML',
            '.yaml': 'YAML',
            '.yml': 'YAML',
            '.java': 'Java',
            '.cpp': 'C++',
            '.c': 'C',
            '.cs': 'C#',
            '.php': 'PHP',
            '.rb': 'Ruby',
            '.go': 'Go',
            '.rs': 'Rust',
            '.ts': 'TypeScript'
        }
        return language_map.get(extension, 'Unknown')
    
    def get_analysis_stats(self) -> Dict:
        """Get analysis statistics."""
        try:
            stats = self.db.get_stats()
            
            # Add analysis-specific stats
            with self.db.get_connection() as conn:
                cursor = conn.cursor()
                
                # Count by status
                cursor.execute('''
                    SELECT status, COUNT(*) as count 
                    FROM assets 
                    GROUP BY status
                ''')
                status_counts = {row['status']: row['count'] for row in cursor.fetchall()}
                
                # Count assets with metadata
                cursor.execute('''
                    SELECT COUNT(DISTINCT asset_id) as count 
                    FROM asset_metadata
                ''')
                analyzed_count = cursor.fetchone()['count']
                
                stats['analysis'] = {
                    'status_breakdown': status_counts,
                    'analyzed_assets': analyzed_count,
                    'analysis_interval': self.analysis_interval
                }
            
            return stats
            
        except Exception as e:
            print(f"Error getting analysis stats: {e}")
            return {}


def main():
    """Main function for command-line usage."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Asset Analyst - Analyze and process indexed assets')
    parser.add_argument('--once', action='store_true', help='Run analysis once and exit')
    parser.add_argument('--continuous', action='store_true', help='Run continuous analysis')
    parser.add_argument('--interval', type=int, default=60, help='Analysis interval in seconds (default: 60)')
    parser.add_argument('--stats', action='store_true', help='Show analysis statistics')
    
    args = parser.parse_args()
    
    try:
        analyst = AssetAnalyst(analysis_interval=args.interval)
        
        if args.stats:
            stats = analyst.get_analysis_stats()
            print(json.dumps(stats, indent=2))
            
        elif args.once:
            analyst.start_analysis(continuous=False)
            
        elif args.continuous:
            analyst.start_analysis(continuous=True)
            
        else:
            print("Please specify --once, --continuous, or --stats")
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    import json
    main()