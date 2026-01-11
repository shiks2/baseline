"""
Database management for the asset management system.
Provides centralized database operations with singleton pattern and comprehensive error handling.
"""

import sqlite3
import json
import hashlib
import os
from datetime import datetime
from typing import List, Dict, Optional, Any, Tuple
from contextlib import contextmanager
from pathlib import Path

from .config import config


class DatabaseManager:
    """Singleton database manager for centralized database operations."""
    
    _instance = None
    _initialized = False
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseManager, cls).__new__(cls)
        return cls._instance
    
    def __init__(self):
        if not self._initialized:
            self._db_path = config.database_path
            self._ensure_database_exists()
            self._initialized = True
    
    def _ensure_database_exists(self):
        """Ensure database file and schema exist."""
        try:
            # Create directory if it doesn't exist
            db_dir = Path(self._db_path).parent
            db_dir.mkdir(parents=True, exist_ok=True)
            
            # Initialize database schema
            self.init_db()
        except Exception as e:
            print(f"Error ensuring database exists: {e}")
            raise
    
    @contextmanager
    def get_connection(self):
        """Context manager for database connections with error handling."""
        conn = None
        try:
            conn = sqlite3.connect(self._db_path)
            conn.row_factory = sqlite3.Row  # Enable column access by name
            yield conn
        except sqlite3.Error as e:
            print(f"Database connection error: {e}")
            if conn:
                conn.rollback()
            raise
        finally:
            if conn:
                conn.close()
    
    def init_db(self):
        """Initialize database schema."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                # Assets table
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS assets (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        path TEXT NOT NULL UNIQUE,
                        category TEXT DEFAULT 'Uncategorized',
                        tags TEXT DEFAULT '[]',
                        search_term TEXT GENERATED ALWAYS AS (
                            lower(name) || ' ' || lower(coalesce(category, '')) || ' ' || lower(coalesce(tags, '[]'))
                        ) STORED,
                        file_hash TEXT,
                        file_size INTEGER,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        status TEXT DEFAULT 'pending'
                    )
                ''')
                
                # Libraries table for watched folders
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS libraries (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        path TEXT NOT NULL UNIQUE,
                        name TEXT NOT NULL,
                        is_active BOOLEAN DEFAULT 1,
                        last_scan TIMESTAMP,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                ''')
                
                # Asset metadata table
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS asset_metadata (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        asset_id INTEGER NOT NULL,
                        key TEXT NOT NULL,
                        value TEXT,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE
                    )
                ''')
                
                # Create indexes for better performance
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_assets_path ON assets(path)')
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category)')
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_assets_search ON assets(search_term)')
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_assets_status ON assets(status)')
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_libraries_path ON libraries(path)')
                cursor.execute('CREATE INDEX IF NOT EXISTS idx_asset_metadata_asset_id ON asset_metadata(asset_id)')
                
                conn.commit()
                print(f"Database initialized successfully at: {self._db_path}")
                
        except sqlite3.Error as e:
            print(f"Error initializing database: {e}")
            raise
    
    def add_asset(self, file_path: str, name: str, category: str = "Uncategorized", 
                  tags: List[str] = None, file_size: int = None) -> Optional[int]:
        """Add a new asset to the database."""
        if tags is None:
            tags = []
        
        try:
            # Calculate file hash
            file_hash = self._calculate_file_hash(file_path)
            
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                cursor.execute('''
                    INSERT INTO assets (name, path, category, tags, file_hash, file_size, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ''', (name, file_path, category, json.dumps(tags), file_hash, file_size, 'pending'))
                
                asset_id = cursor.lastrowid
                conn.commit()
                
                print(f"Asset added: {name} (ID: {asset_id})")
                return asset_id
                
        except sqlite3.IntegrityError as e:
            if "UNIQUE constraint failed" in str(e):
                print(f"Asset already exists: {file_path}")
                return self.get_asset_by_path(file_path).get('id')
            else:
                print(f"Integrity error adding asset: {e}")
                return None
        except Exception as e:
            print(f"Error adding asset: {e}")
            return None
    
    def get_asset_by_path(self, file_path: str) -> Optional[Dict]:
        """Get asset by file path."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute('SELECT * FROM assets WHERE path = ?', (file_path,))
                row = cursor.fetchone()
                
                if row:
                    return dict(row)
                return None
                
        except Exception as e:
            print(f"Error getting asset by path: {e}")
            return None
    
    def search_assets(self, query: str, limit: int = 100) -> List[Dict]:
        """Search assets by query string."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                # Use FTS-like search on the generated search_term column
                search_query = f"%{query.lower()}%"
                
                cursor.execute('''
                    SELECT id, name, path, category, tags, file_size, created_at
                    FROM assets 
                    WHERE search_term LIKE ?
                    ORDER BY 
                        CASE 
                            WHEN name LIKE ? THEN 1
                            WHEN category LIKE ? THEN 2
                            ELSE 3
                        END,
                        name
                    LIMIT ?
                ''', (search_query, search_query, search_query, limit))
                
                results = []
                for row in cursor.fetchall():
                    asset = dict(row)
                    # Parse JSON tags
                    try:
                        asset['tags'] = json.loads(asset['tags'])
                    except (json.JSONDecodeError, KeyError):
                        asset['tags'] = []
                    
                    results.append(asset)
                
                return results
                
        except Exception as e:
            print(f"Error searching assets: {e}")
            return []
    
    def update_asset_status(self, asset_id: int, status: str) -> bool:
        """Update asset status (pending, indexed, error)."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute('''
                    UPDATE assets 
                    SET status = ?, updated_at = CURRENT_TIMESTAMP 
                    WHERE id = ?
                ''', (status, asset_id))
                conn.commit()
                return cursor.rowcount > 0
                
        except Exception as e:
            print(f"Error updating asset status: {e}")
            return False
    
    def add_library(self, path: str, name: str) -> Optional[int]:
        """Add a library (watched folder)."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                cursor.execute('''
                    INSERT INTO libraries (path, name, last_scan)
                    VALUES (?, ?, CURRENT_TIMESTAMP)
                ''', (path, name))
                
                library_id = cursor.lastrowid
                conn.commit()
                
                print(f"Library added: {name} (ID: {library_id})")
                return library_id
                
        except sqlite3.IntegrityError:
            print(f"Library already exists: {path}")
            return None
        except Exception as e:
            print(f"Error adding library: {e}")
            return None
    
    def get_libraries(self, active_only: bool = True) -> List[Dict]:
        """Get all libraries."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                query = "SELECT * FROM libraries"
                if active_only:
                    query += " WHERE is_active = 1"
                query += " ORDER BY name"
                
                cursor.execute(query)
                return [dict(row) for row in cursor.fetchall()]
                
        except Exception as e:
            print(f"Error getting libraries: {e}")
            return []
    
    def get_pending_assets(self, limit: int = 50) -> List[Dict]:
        """Get assets with pending status for processing."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                cursor.execute('''
                    SELECT id, name, path, category, tags
                    FROM assets 
                    WHERE status = 'pending'
                    ORDER BY created_at
                    LIMIT ?
                ''', (limit,))
                
                results = []
                for row in cursor.fetchall():
                    asset = dict(row)
                    # Parse JSON tags
                    try:
                        asset['tags'] = json.loads(asset['tags'])
                    except (json.JSONDecodeError, KeyError):
                        asset['tags'] = []
                    
                    results.append(asset)
                
                return results
                
        except Exception as e:
            print(f"Error getting pending assets: {e}")
            return []
    
    def add_asset_metadata(self, asset_id: int, key: str, value: str) -> bool:
        """Add metadata to an asset."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                cursor.execute('''
                    INSERT INTO asset_metadata (asset_id, key, value)
                    VALUES (?, ?, ?)
                ''', (asset_id, key, value))
                
                conn.commit()
                return True
                
        except Exception as e:
            print(f"Error adding asset metadata: {e}")
            return False
    
    def get_asset_metadata(self, asset_id: int) -> Dict[str, str]:
        """Get all metadata for an asset."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                cursor.execute('''
                    SELECT key, value 
                    FROM asset_metadata 
                    WHERE asset_id = ?
                ''', (asset_id,))
                
                return {row['key']: row['value'] for row in cursor.fetchall()}
                
        except Exception as e:
            print(f"Error getting asset metadata: {e}")
            return {}
    
    def _calculate_file_hash(self, file_path: str) -> Optional[str]:
        """Calculate SHA256 hash of a file."""
        try:
            import hashlib
            
            hash_sha256 = hashlib.sha256()
            with open(file_path, "rb") as f:
                for chunk in iter(lambda: f.read(4096), b""):
                    hash_sha256.update(chunk)
            
            return hash_sha256.hexdigest()
            
        except Exception as e:
            print(f"Error calculating file hash: {e}")
            return None
    
    def get_stats(self) -> Dict[str, Any]:
        """Get database statistics."""
        try:
            with self.get_connection() as conn:
                cursor = conn.cursor()
                
                # Total assets
                cursor.execute('SELECT COUNT(*) as total FROM assets')
                total_assets = cursor.fetchone()['total']
                
                # Assets by status
                cursor.execute('''
                    SELECT status, COUNT(*) as count 
                    FROM assets 
                    GROUP BY status
                ''')
                status_counts = {row['status']: row['count'] for row in cursor.fetchall()}
                
                # Total libraries
                cursor.execute('SELECT COUNT(*) as total FROM libraries WHERE is_active = 1')
                total_libraries = cursor.fetchone()['total']
                
                return {
                    'total_assets': total_assets,
                    'status_counts': status_counts,
                    'total_libraries': total_libraries,
                    'database_path': self._db_path
                }
                
        except Exception as e:
            print(f"Error getting database stats: {e}")
            return {}


# Global database manager instance
db_manager = DatabaseManager()