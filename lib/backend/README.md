# Asset Management System - Enterprise Backend

This directory contains the refactored, production-ready Python backend for the Candance asset management system. The architecture has been transformed from simple procedural scripts to a comprehensive Object-Oriented design with proper separation of concerns, error handling, and scalability.

## 🏗️ Architecture Overview

The system follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Frontend                         │
├─────────────────────────────────────────────────────────────┤
│                  PythonService (Dart)                       │
├─────────────────────────────────────────────────────────────┤
│                  Orchestrator Layer                         │
│  (Coordinates between services, provides unified API)      │
├─────────────────────────────────────────────────────────────┤
│              Service Layer (Business Logic)                 │
│  ┌─────────────┬──────────────┬──────────────────────────┐  │
│  │Librarian    │AssetWatcher  │AssetAnalyst              │  │
│  │Service      │(Indexer)     │Service                   │  │
│  └─────────────┴──────────────┴──────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                  Shared Layer (Core)                        │
│  ┌─────────────────────┬──────────────────────────────────┐  │
│  │DatabaseManager      │Config (Singleton)                │  │
│  │(Singleton Pattern)  │(Cross-platform paths)            │  │
│  └─────────────────────┴──────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Directory Structure

```
lib/backend/
├── shared/                    # Core shared modules
│   ├── __init__.py
│   ├── config.py             # Configuration management
│   ├── database.py           # DatabaseManager (Singleton)
│   └── README.md
├── services/                  # Business logic services
│   ├── __init__.py
│   ├── librarian.py          # LibrarianService (Search & Manage)
│   ├── indexer.py            # AssetWatcher (File Monitoring)
│   └── analyst.py            # AssetAnalyst (Content Analysis)
├── orchestrator.py           # Main orchestrator
└── README.md                 # This file
```

## 🔧 Core Components

### 1. DatabaseManager (`shared/database.py`)
- **Pattern**: Singleton
- **Purpose**: Centralized database operations
- **Features**:
  - Automatic connection management with context managers
  - Comprehensive error handling
  - Search term generation (combines name + category + tags)
  - CRUD operations for assets, libraries, and metadata
  - Database statistics and health monitoring

### 2. Config (`shared/config.py`)
- **Pattern**: Singleton
- **Purpose**: Centralized configuration management
- **Features**:
  - Cross-platform path management (Windows, macOS, Linux)
  - Application data directory setup
  - Default library configuration
  - Path validation utilities

### 3. Service Layer

#### LibrarianService (`services/librarian.py`)
- **Purpose**: Asset search and retrieval
- **Features**:
  - Advanced search with ranking
  - Category-based filtering
  - Asset metadata retrieval
  - Database statistics

#### AssetWatcher (`services/indexer.py`)
- **Purpose**: File system monitoring and indexing
- **Features**:
  - Real-time file system monitoring (with watchdog)
  - Automatic asset categorization
  - Supported file type filtering
  - Library scanning capabilities

#### AssetAnalyst (`services/analyst.py`)
- **Purpose**: Content analysis and metadata extraction
- **Features**:
  - Multi-format content analysis
  - Image EXIF extraction
  - Document text analysis
  - Video/audio metadata extraction
  - Code file analysis

### 4. Orchestrator (`orchestrator.py`)
- **Purpose**: System coordination and unified API
- **Features**:
  - Service lifecycle management
  - Unified command-line interface
  - System status monitoring
  - Service coordination

## 🚀 Key Benefits

### 1. **Single Source of Truth**
- DatabaseManager ensures all database operations go through one centralized point
- Config manages all paths and settings consistently
- No more "Ghost Database" issues

### 2. **Enterprise-Grade Error Handling**
- Comprehensive try/catch blocks in all components
- Graceful degradation when optional libraries are missing
- Detailed logging and error reporting

### 3. **Type Safety**
- Full type hinting throughout the codebase
- Self-documenting code
- IDE-friendly development experience

### 4. **Scalability**
- Service-oriented architecture allows easy feature addition
- Plugin-style analysis system
- Modular design supports future enhancements

### 5. **Cross-Platform Support**
- Automatic platform detection and path management
- Consistent behavior across Windows, macOS, and Linux
- Platform-specific optimizations

## 🛠️ Usage Examples

### Command Line Interface

```bash
# Initialize the system
python orchestrator.py init

# Search for assets
python orchestrator.py search "vacation photos"

# Start indexing service
python orchestrator.py index start

# Start analysis service
python orchestrator.py analyze start

# Get system status
python orchestrator.py status

# Scan specific library
python orchestrator.py index scan /path/to/library
```

### Direct Service Usage

```python
from services.librarian import LibrarianService
from services.indexer import AssetWatcher
from services.analyst import AssetAnalyst

# Search for assets
librarian = LibrarianService()
results = librarian.search_assets("summer vacation", limit=50)

# Monitor file system
watcher = AssetWatcher()
watcher.start_watching()

# Analyze assets
analyst = AssetAnalyst()
analyst.start_analysis(continuous=True)
```

### Database Operations

```python
from shared.database import db_manager

# Add an asset
asset_id = db_manager.add_asset(
    file_path="/path/to/file.jpg",
    name="Vacation Photo",
    category="Image",
    tags=["vacation", "summer", "beach"]
)

# Search assets
results = db_manager.search_assets("vacation")

# Get database statistics
stats = db_manager.get_stats()
```

## 🔍 Migration from Procedural Scripts

The new architecture replaces the old procedural scripts:

| Old Script | New Component | Migration Path |
|------------|---------------|----------------|
| `librarian.py` | `LibrarianService` | Use `orchestrator.py search` or direct service calls |
| `indexer2.py` | `AssetWatcher` | Use `orchestrator.py index` commands |
| `analyst.py` | `AssetAnalyst` | Use `orchestrator.py analyze` commands |

## 🔧 Configuration

The system automatically handles configuration:

- **Database Location**: Platform-specific application data directory
- **Default Libraries**: Documents, Pictures, Downloads folders
- **Supported File Types**: Images, documents, videos, audio, archives, code files
- **Analysis Intervals**: Configurable per service

## 🧪 Testing

Run the test suite to verify the system:

```bash
# Test individual services
python -m pytest tests/test_librarian.py
python -m pytest tests/test_indexer.py
python -m pytest tests/test_analyst.py

# Test the orchestrator
python -m pytest tests/test_orchestrator.py

# Integration tests
python -m pytest tests/test_integration.py
```

## 📊 Performance Considerations

- **Database**: SQLite with proper indexing for fast searches
- **File Monitoring**: Optional watchdog library for real-time updates
- **Memory Usage**: Streaming processing for large file sets
- **Concurrent Operations**: Services can run independently

## 🔮 Future Enhancements

The architecture supports easy addition of:
- Cloud storage integration
- Machine learning-based categorization
- Advanced metadata extraction
- Plugin system for custom analyzers
- Distributed processing
- Real-time collaboration features

## 🆘 Troubleshooting

### Common Issues

1. **"Python not available"**: Ensure Python is installed and in PATH
2. **"Database locked"**: Check for concurrent database access
3. **"File not found"**: Verify file paths and permissions
4. **"Watchdog not available"**: Install watchdog library for file monitoring

### Debug Mode

Enable debug logging by setting environment variables:
```bash
export PYTHONPATH=lib/backend
export DEBUG=1
python orchestrator.py status
```

## 📞 Support

For issues and questions:
1. Check the logs in the application data directory
2. Run `python orchestrator.py status` for system diagnostics
3. Verify Python dependencies are installed
4. Check file permissions and paths

---

**Note**: This refactored backend provides a solid foundation for enterprise-scale asset management while maintaining simplicity for development and deployment.