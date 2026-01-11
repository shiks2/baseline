"""
Configuration management for the asset management system.
Provides centralized configuration for database paths, root folders, and other settings.
"""

import os
import platform
from pathlib import Path
from typing import Optional


class Config:
    """Centralized configuration management for the asset management system."""
    
    def __init__(self):
        self._platform = platform.system()
        self._setup_paths()
    
    def _setup_paths(self):
        """Setup platform-specific paths."""
        # Base directory for the project
        if self._platform == "Windows":
            self._base_dir = Path(os.environ.get('APPDATA', '~')).expanduser() / "Candance"
        elif self._platform == "Darwin":  # macOS
            self._base_dir = Path.home() / "Library" / "Application Support" / "Candance"
        else:  # Linux and others
            self._base_dir = Path.home() / ".local" / "share" / "Candance"
        
        # Ensure base directory exists
        self._base_dir.mkdir(parents=True, exist_ok=True)
        
        # Database path
        self._db_path = self._base_dir / "imperium1.db"
        
        # Default library paths
        self._default_libraries = [
            Path.home() / "Documents",
            Path.home() / "Pictures",
            Path.home() / "Downloads"
        ]
    
    @property
    def database_path(self) -> str:
        """Get the database file path."""
        return str(self._db_path)
    
    @property
    def default_libraries(self) -> list[str]:
        """Get list of default library paths."""
        return [str(path) for path in self._default_libraries]
    
    @property
    def platform(self) -> str:
        """Get the current platform."""
        return self._platform
    
    @property
    def base_directory(self) -> str:
        """Get the base application directory."""
        return str(self._base_dir)
    
    def get_library_path(self, library_name: str) -> str:
        """Get a specific library path by name."""
        return str(self._base_dir / "libraries" / library_name)
    
    def ensure_directory_exists(self, path: str) -> bool:
        """Ensure a directory exists, create if necessary."""
        try:
            Path(path).mkdir(parents=True, exist_ok=True)
            return True
        except Exception:
            return False
    
    def is_valid_path(self, path: str) -> bool:
        """Check if a path is valid and accessible."""
        try:
            return Path(path).exists() and Path(path).is_dir()
        except Exception:
            return False


# Global configuration instance
config = Config()