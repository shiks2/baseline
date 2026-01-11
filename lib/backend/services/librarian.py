"""
Librarian service for searching and managing assets.
Provides high-level asset search and retrieval functionality.
"""

import sys
import os
from typing import List, Dict, Optional

# Add the parent directory to the path so we can import shared modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.database import db_manager
from shared.config import config


class LibrarianService:
    """Service class for asset search and management operations."""
    
    def __init__(self):
        """Initialize the librarian service."""
        self.db = db_manager
    
    def search_assets(self, query: str, limit: int = 100) -> List[Dict]:
        """
        Search for assets using the provided query.
        
        Args:
            query: Search query string
            limit: Maximum number of results to return
            
        Returns:
            List of asset dictionaries matching the search criteria
        """
        try:
            if not query or not query.strip():
                return []
            
            # Use the database manager's search functionality
            results = self.db.search_assets(query.strip(), limit)
            
            # Format results for output
            formatted_results = []
            for asset in results:
                formatted_asset = {
                    'id': asset['id'],
                    'name': asset['name'],
                    'path': asset['path'],
                    'category': asset['category'],
                    'tags': asset.get('tags', []),
                    'file_size': asset.get('file_size'),
                    'created_at': asset.get('created_at')
                }
                formatted_results.append(formatted_asset)
            
            return formatted_results
            
        except Exception as e:
            print(f"Error in LibrarianService.search_assets: {e}")
            return []
    
    def get_asset_by_id(self, asset_id: int) -> Optional[Dict]:
        """
        Get a specific asset by its ID.
        
        Args:
            asset_id: The ID of the asset to retrieve
            
        Returns:
            Asset dictionary or None if not found
        """
        try:
            # This would require adding a method to DatabaseManager
            # For now, we'll use search with the ID as query
            results = self.search_assets(str(asset_id), limit=1)
            return results[0] if results else None
            
        except Exception as e:
            print(f"Error in LibrarianService.get_asset_by_id: {e}")
            return None
    
    def get_assets_by_category(self, category: str, limit: int = 50) -> List[Dict]:
        """
        Get assets by category.
        
        Args:
            category: The category to filter by
            limit: Maximum number of results
            
        Returns:
            List of asset dictionaries in the specified category
        """
        try:
            # Use search functionality with category-specific logic
            # This is a simplified implementation - could be enhanced in DatabaseManager
            all_assets = self.search_assets("", limit=1000)  # Get more assets for filtering
            category_assets = [
                asset for asset in all_assets 
                if asset.get('category', '').lower() == category.lower()
            ]
            return category_assets[:limit]
            
        except Exception as e:
            print(f"Error in LibrarianService.get_assets_by_category: {e}")
            return []
    
    def get_asset_metadata(self, asset_id: int) -> Dict[str, str]:
        """
        Get metadata for a specific asset.
        
        Args:
            asset_id: The ID of the asset
            
        Returns:
            Dictionary of metadata key-value pairs
        """
        try:
            return self.db.get_asset_metadata(asset_id)
            
        except Exception as e:
            print(f"Error in LibrarianService.get_asset_metadata: {e}")
            return {}
    
    def get_database_stats(self) -> Dict:
        """
        Get database statistics.
        
        Returns:
            Dictionary containing database statistics
        """
        try:
            return self.db.get_stats()
            
        except Exception as e:
            print(f"Error in LibrarianService.get_database_stats: {e}")
            return {}
    
    def validate_asset_path(self, file_path: str) -> bool:
        """
        Validate if a file path is accessible and valid.
        
        Args:
            file_path: The file path to validate
            
        Returns:
            True if the path is valid and accessible
        """
        try:
            return config.is_valid_path(file_path)
            
        except Exception as e:
            print(f"Error validating asset path: {e}")
            return False


def main():
    """Main function for command-line usage."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Librarian Service - Search and manage assets')
    parser.add_argument('query', help='Search query')
    parser.add_argument('--limit', type=int, default=100, help='Maximum number of results')
    parser.add_argument('--stats', action='store_true', help='Show database statistics')
    
    args = parser.parse_args()
    
    try:
        librarian = LibrarianService()
        
        if args.stats:
            stats = librarian.get_database_stats()
            print(json.dumps(stats, indent=2))
        else:
            results = librarian.search_assets(args.query, args.limit)
            print(json.dumps(results, indent=2))
            
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    import json
    main()