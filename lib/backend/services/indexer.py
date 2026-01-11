"""
Asset watcher service for monitoring file system changes and indexing assets.
Provides real-time file system monitoring and asset indexing functionality.
"""

import sys
import os
import time
import hashlib
from pathlib import Path
from typing import List, Dict, Optional, Set
from datetime import datetime

# Add the parent directory to the path so we can import shared modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler, FileCreatedEvent, FileModifiedEvent, FileMovedEvent
    WATCHDOG_AVAILABLE = True
except ImportError:
    WATCHDOG_AVAILABLE = False
    # Create dummy classes for compatibility
    class FileSystemEventHandler:
        pass
    class FileCreatedEvent:
        pass
    class FileModifiedEvent:
        pass
    class FileMovedEvent:
        pass

from shared.database import db_manager
from shared.config import config


class AssetWatcher(FileSystemEventHandler):
    """File system event handler for monitoring and indexing assets."""
    
    # Supported file extensions for indexing
    SUPPORTED_EXTENSIONS = {
        # Images
        '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.svg', '.webp',
        # Documents
        '.pdf', '.doc', '.docx', '.txt', '.rtf', '.odt',
        # Videos
        '.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', '.webm',
        # Audio
        '.mp3', '.wav', '.flac', '.aac', '.ogg', '.wma',
        # Archives
        '.zip', '.rar', '.7z', '.tar', '.gz',
        # Code
        '.py', '.js', '.html', '.css', '.json', '.xml', '.yaml', '.yml'
    }
    
    def __init__(self):
        """Initialize the asset watcher."""
        super().__init__()
        self.db = db_manager
        self.config = config
        self.observer = None
        self.watched_paths: Set[str] = set()
        self.is_running = False
        
    def start_watching(self, libraries: Optional[List[str]] = None) -> bool:
        """
        Start watching configured libraries for file changes.
        
        Args:
            libraries: Optional list of library paths to watch. If None, uses configured libraries.
            
        Returns:
            True if watching started successfully
        """
        try:
            if not WATCHDOG_AVAILABLE:
                print("Watchdog library not available. File monitoring disabled.")
                return False
            
            # Get libraries to watch
            if libraries is None:
                library_configs = self.db.get_libraries(active_only=True)
                libraries = [lib['path'] for lib in library_configs]
            
            if not libraries:
                # Use default libraries if none configured
                libraries = self.config.default_libraries
                # Add them to database
                for lib_path in libraries:
                    if self.config.is_valid_path(lib_path):
                        self.db.add_library(lib_path, Path(lib_path).name)
            
            # Start observer
            self.observer = Observer()
            
            # Schedule watchers for each library
            for library_path in libraries:
                if self.config.is_valid_path(library_path):
                    self.observer.schedule(self, library_path, recursive=True)
                    self.watched_paths.add(library_path)
                    print(f"Started watching: {library_path}")
            
            if self.watched_paths:
                self.observer.start()
                self.is_running = True
                print(f"Asset watcher started. Watching {len(self.watched_paths)} paths.")
                return True
            else:
                print("No valid paths to watch.")
                return False
                
        except Exception as e:
            print(f"Error starting asset watcher: {e}")
            return False
    
    def stop_watching(self):
        """Stop watching file system changes."""
        try:
            if self.observer and self.is_running:
                self.observer.stop()
                self.observer.join()
                self.is_running = False
                self.watched_paths.clear()
                print("Asset watcher stopped.")
                
        except Exception as e:
            print(f"Error stopping asset watcher: {e}")
    
    def on_created(self, event):
        """Handle file creation events."""
        if not event.is_directory:
            self._process_file_event(event, "created")
    
    def on_modified(self, event):
        """Handle file modification events."""
        if not event.is_directory:
            self._process_file_event(event, "modified")
    
    def on_moved(self, event):
        """Handle file move events."""
        if not event.is_directory:
            self._process_file_event(event, "moved")
    
    def _process_file_event(self, event, event_type: str):
        """Process a file system event."""
        try:
            file_path = event.src_path if hasattr(event, 'src_path') else event.dest_path
            
            # Check if file has supported extension
            if not self._is_supported_file(file_path):
                return
            
            # Get file info
            file_info = self._get_file_info(file_path)
            if not file_info:
                return
            
            # Add or update asset in database
            existing_asset = self.db.get_asset_by_path(file_path)
            
            if event_type == "created" or (event_type == "moved" and not existing_asset):
                # Add new asset
                asset_id = self.db.add_asset(
                    file_path=file_path,
                    name=file_info['name'],
                    category=self._categorize_file(file_path),
                    file_size=file_info['size']
                )
                if asset_id:
                    print(f"Added new asset: {file_info['name']} (ID: {asset_id})")
            
            elif event_type == "modified" and existing_asset:
                # Update existing asset
                success = self.db.update_asset_status(existing_asset['id'], 'pending')
                if success:
                    print(f"Updated asset: {file_info['name']}")
            
            elif event_type == "moved" and existing_asset:
                # Handle moved files - update path
                # This would require additional logic in DatabaseManager
                print(f"File moved: {file_info['name']}")
                
        except Exception as e:
            print(f"Error processing file event: {e}")
    
    def _is_supported_file(self, file_path: str) -> bool:
        """Check if file has supported extension."""
        try:
            return Path(file_path).suffix.lower() in self.SUPPORTED_EXTENSIONS
        except Exception:
            return False
    
    def _get_file_info(self, file_path: str) -> Optional[Dict]:
        """Get file information."""
        try:
            path = Path(file_path)
            if not path.exists():
                return None
            
            stat = path.stat()
            return {
                'name': path.name,
                'size': stat.st_size,
                'modified': datetime.fromtimestamp(stat.st_mtime),
                'extension': path.suffix.lower()
            }
            
        except Exception as e:
            print(f"Error getting file info for {file_path}: {e}")
            return None
    
    def _categorize_file(self, file_path: str) -> str:
        """Categorize file based on extension."""
        try:
            extension = Path(file_path).suffix.lower()
            
            if extension in {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.svg', '.webp'}:
                return 'Image'
            elif extension in {'.pdf', '.doc', '.docx', '.txt', '.rtf', '.odt'}:
                return 'Document'
            elif extension in {'.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', '.webm'}:
                return 'Video'
            elif extension in {'.mp3', '.wav', '.flac', '.aac', '.ogg', '.wma'}:
                return 'Audio'
            elif extension in {'.zip', '.rar', '.7z', '.tar', '.gz'}:
                return 'Archive'
            elif extension in {'.py', '.js', '.html', '.css', '.json', '.xml', '.yaml', '.yml'}:
                return 'Code'
            else:
                return 'Other'
                
        except Exception:
            return 'Uncategorized'
    
    def scan_library(self, library_path: str) -> int:
        """
        Perform a full scan of a library directory.
        
        Args:
            library_path: Path to the library directory
            
        Returns:
            Number of assets added
        """
        try:
            if not self.config.is_valid_path(library_path):
                print(f"Invalid library path: {library_path}")
                return 0
            
            path = Path(library_path)
            added_count = 0
            
            print(f"Scanning library: {library_path}")
            
            # Walk through directory recursively
            for file_path in path.rglob('*'):
                if file_path.is_file() and self._is_supported_file(str(file_path)):
                    # Check if asset already exists
                    existing_asset = self.db.get_asset_by_path(str(file_path))
                    
                    if not existing_asset:
                        # Add new asset
                        file_info = self._get_file_info(str(file_path))
                        if file_info:
                            asset_id = self.db.add_asset(
                                file_path=str(file_path),
                                name=file_info['name'],
                                category=self._categorize_file(str(file_path)),
                                file_size=file_info['size']
                            )
                            if asset_id:
                                added_count += 1
            
            print(f"Library scan completed. Added {added_count} new assets.")
            return added_count
            
        except Exception as e:
            print(f"Error scanning library {library_path}: {e}")
            return 0
    
    def get_watched_paths(self) -> List[str]:
        """Get list of currently watched paths."""
        return list(self.watched_paths)


def main():
    """Main function for command-line usage."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Asset Watcher - Monitor and index files')
    parser.add_argument('--scan', help='Scan a specific library path')
    parser.add_argument('--watch', action='store_true', help='Start watching for changes')
    parser.add_argument('--stop-after', type=int, help='Stop after specified seconds (for testing)')
    
    args = parser.parse_args()
    
    try:
        watcher = AssetWatcher()
        
        if args.scan:
            # Scan specific library
            count = watcher.scan_library(args.scan)
            print(f"Scan complete. Added {count} assets.")
            
        elif args.watch:
            # Start watching
            if watcher.start_watching():
                print("Asset watcher started. Press Ctrl+C to stop.")
                
                if args.stop_after:
                    time.sleep(args.stop_after)
                    watcher.stop_watching()
                else:
                    try:
                        while True:
                            time.sleep(1)
                    except KeyboardInterrupt:
                        print("\nStopping asset watcher...")
                        watcher.stop_watching()
            else:
                print("Failed to start asset watcher.")
                sys.exit(1)
        else:
            print("Please specify --scan or --watch")
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()