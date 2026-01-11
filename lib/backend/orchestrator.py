"""
Main orchestrator for the asset management system.
Coordinates between indexer, librarian, and analyst services.
"""

import sys
import os
import json
import argparse
from typing import Dict, Any

# Add the parent directory to the path so we can import shared modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from shared.database import db_manager
from shared.config import config
from services.librarian import LibrarianService
from services.indexer import AssetWatcher
from services.analyst import AssetAnalyst
from services.injector import AssetInjector


class AssetOrchestrator:
    """Main orchestrator that coordinates all asset management services."""
    
    def __init__(self):
        """Initialize the orchestrator with all services."""
        self.db = db_manager
        self.config = config
        self.librarian = LibrarianService()
        self.indexer = AssetWatcher()
        self.analyst = AssetAnalyst()
        self.injector = AssetInjector()
        
        # Service status tracking
        self.service_status = {
            'librarian': False,
            'indexer': False,
            'analyst': False
        }
    
    def initialize_system(self) -> bool:
        """
        Initialize the entire asset management system.
        
        Returns:
            True if initialization successful
        """
        try:
            print("Initializing asset management system...")
            
            # Ensure database is ready
            self.db.init_db()
            print(f"Database initialized: {self.config.database_path}")
            
            # Initialize default libraries if none exist
            self._initialize_default_libraries()
            
            print("System initialization complete.")
            return True
            
        except Exception as e:
            print(f"System initialization failed: {e}")
            return False
    
    def _initialize_default_libraries(self):
        """Initialize default libraries if none exist."""
        try:
            existing_libraries = self.db.get_libraries()
            
            if not existing_libraries:
                print("No libraries found. Adding default libraries...")
                
                for lib_path in self.config.default_libraries:
                    if self.config.is_valid_path(lib_path):
                        lib_name = Path(lib_path).name
                        self.db.add_library(lib_path, lib_name)
                        print(f"Added default library: {lib_name}")
            else:
                print(f"Found {len(existing_libraries)} existing libraries.")
                
        except Exception as e:
            print(f"Error initializing default libraries: {e}")
    
    def search_assets(self, query: str, limit: int = 100) -> Dict[str, Any]:
        """
        Search for assets using the librarian service.
        
        Args:
            query: Search query
            limit: Maximum results
            
        Returns:
            Search results with metadata
        """
        try:
            results = self.librarian.search_assets(query, limit)
            
            return {
                'success': True,
                'query': query,
                'results': results,
                'count': len(results),
                'service': 'librarian'
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'query': query,
                'results': [],
                'count': 0,
                'service': 'librarian'
            }
    
    def start_indexing(self, library_paths: list = None) -> Dict[str, Any]:
        """
        Start the indexing service.
        
        Args:
            library_paths: Optional specific library paths to index
            
        Returns:
            Status of indexing operation
        """
        try:
            success = self.indexer.start_watching(library_paths)
            self.service_status['indexer'] = success
            
            return {
                'success': success,
                'message': 'Indexing started successfully' if success else 'Failed to start indexing',
                'watched_paths': self.indexer.get_watched_paths(),
                'service': 'indexer'
            }
            
        except Exception as e:
            self.service_status['indexer'] = False
            return {
                'success': False,
                'error': str(e),
                'service': 'indexer'
            }
    
    def stop_indexing(self) -> Dict[str, Any]:
        """Stop the indexing service."""
        try:
            self.indexer.stop_watching()
            self.service_status['indexer'] = False
            
            return {
                'success': True,
                'message': 'Indexing stopped successfully',
                'service': 'indexer'
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'service': 'indexer'
            }
    
    def start_analysis(self, continuous: bool = True) -> Dict[str, Any]:
        """
        Start the analysis service.
        
        Args:
            continuous: Whether to run continuously
            
        Returns:
            Status of analysis operation
        """
        try:
            success = self.analyst.start_analysis(continuous=continuous)
            self.service_status['analyst'] = success
            
            return {
                'success': success,
                'message': 'Analysis started successfully' if success else 'Failed to start analysis',
                'mode': 'continuous' if continuous else 'single',
                'service': 'analyst'
            }
            
        except Exception as e:
            self.service_status['analyst'] = False
            return {
                'success': False,
                'error': str(e),
                'service': 'analyst'
            }
    
    def stop_analysis(self) -> Dict[str, Any]:
        """Stop the analysis service."""
        try:
            self.analyst.stop_analysis()
            self.service_status['analyst'] = False
            
            return {
                'success': True,
                'message': 'Analysis stopped successfully',
                'service': 'analyst'
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'service': 'analyst'
            }
    
    def scan_library(self, library_path: str) -> Dict[str, Any]:
        """
        Manually scan a library for new assets.
        
        Args:
            library_path: Path to the library to scan
            
        Returns:
            Scan results
        """
        try:
            count = self.indexer.scan_library(library_path)
            
            return {
                'success': True,
                'message': f'Scanned library successfully',
                'assets_added': count,
                'library_path': library_path,
                'service': 'indexer'
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'library_path': library_path,
                'service': 'indexer'
            }
    
    def get_system_status(self) -> Dict[str, Any]:
        """Get comprehensive system status."""
        try:
            db_stats = self.db.get_stats()
            
            return {
                'success': True,
                'database': db_stats,
                'services': {
                    'librarian': True,  # Always available
                    'indexer': self.service_status['indexer'],
                    'analyst': self.service_status['analyst']
                },
                'config': {
                    'database_path': self.config.database_path,
                    'platform': self.config.platform,
                    'base_directory': self.config.base_directory
                }
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e)
            }
    
    def get_service_logs(self, service: str, limit: int = 100) -> Dict[str, Any]:
        """
        Get logs for a specific service.
        
        Args:
            service: Service name ('indexer', 'analyst', 'librarian')
            limit: Maximum number of log entries
            
        Returns:
            Service logs
        """
        try:
            # This would integrate with a logging system
            # For now, return a placeholder
            return {
                'success': True,
                'service': service,
                'logs': [f"Log functionality for {service} not yet implemented"],
                'count': 1
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'service': service
            }


def main():
    """Main function for command-line usage."""
    parser = argparse.ArgumentParser(description='Asset Management System Orchestrator')
    
    # Subcommands
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Search command
    search_parser = subparsers.add_parser('search', help='Search for assets')
    search_parser.add_argument('query', help='Search query')
    search_parser.add_argument('--limit', type=int, default=100, help='Maximum results')
    
    # Index commands
    index_parser = subparsers.add_parser('index', help='Indexing operations')
    index_subparsers = index_parser.add_subparsers(dest='index_command')
    
    index_start_parser = index_subparsers.add_parser('start', help='Start indexing')
    index_start_parser.add_argument('--paths', nargs='+', help='Specific library paths to index')
    
    index_stop_parser = index_subparsers.add_parser('stop', help='Stop indexing')
    index_scan_parser = index_subparsers.add_parser('scan', help='Scan specific library')
    index_scan_parser.add_argument('path', help='Library path to scan')
    
    index_watch_parser = index_subparsers.add_parser('watch', help='Watch specific library')
    index_watch_parser.add_argument('path', help='Library path to watch')
    
    # Analysis commands
    analysis_parser = subparsers.add_parser('analyze', help='Analysis operations')
    analysis_subparsers = analysis_parser.add_subparsers(dest='analysis_command')
    
    analysis_start_parser = analysis_subparsers.add_parser('start', help='Start analysis')
    analysis_start_parser.add_argument('--once', action='store_true', help='Run once and exit')
    
    analysis_stop_parser = analysis_subparsers.add_parser('stop', help='Stop analysis')
    analysis_stats_parser = analysis_subparsers.add_parser('stats', help='Get analysis statistics')
    
    # Inject command
    inject_parser = subparsers.add_parser('inject', help='Inject asset into AutoCAD')
    inject_parser.add_argument('path', help='File path to inject')
    
    # System commands
    status_parser = subparsers.add_parser('status', help='Get system status')
    init_parser = subparsers.add_parser('init', help='Initialize system')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    try:
        orchestrator = AssetOrchestrator()
        
        if args.command == 'init':
            success = orchestrator.initialize_system()
            sys.exit(0 if success else 1)
            
        elif args.command == 'status':
            status = orchestrator.get_system_status()
            print(json.dumps(status, indent=2))
            
        elif args.command == 'search':
            results = orchestrator.search_assets(args.query, args.limit)
            print(json.dumps(results, indent=2))
            
        elif args.command == 'index':
            if args.index_command == 'start':
                result = orchestrator.start_indexing(args.paths)
                print(json.dumps(result, indent=2))
            elif args.index_command == 'stop':
                result = orchestrator.stop_indexing()
                print(json.dumps(result, indent=2))
            elif args.index_command == 'scan':
                result = orchestrator.scan_library(args.path)
                print(json.dumps(result, indent=2))
            elif args.index_command == 'watch':
                result = orchestrator.start_indexing([args.path])
                print(json.dumps(result, indent=2))
            else:
                index_parser.print_help()
                
        elif args.command == 'analyze':
            if args.analysis_command == 'start':
                continuous = not args.once
                result = orchestrator.start_analysis(continuous=continuous)
                print(json.dumps(result, indent=2))
            elif args.analysis_command == 'stop':
                result = orchestrator.stop_analysis()
                print(json.dumps(result, indent=2))
            elif args.analysis_command == 'stats':
                stats = orchestrator.analyst.get_analysis_stats()
                print(json.dumps(stats, indent=2))
            else:
                analysis_parser.print_help()
                
        elif args.command == 'inject':
            result = orchestrator.injector.inject(args.path)
            print(json.dumps(result, indent=2))
        else:
            parser.print_help()
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()