import sys
import time
import sqlite3
import os
import json
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- CONFIGURATION ---
DB_NAME = "imperium1.db"

# --- DATABASE SETUP ---
def init_db():
    """Creates the database and table if they don't exist."""
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    # UPDATED: Added 'search_term' column
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS assets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT NOT NULL,
            file_path TEXT UNIQUE NOT NULL,
            category TEXT,
            tags TEXT,
            search_term TEXT,
            date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

# --- HYBRID LOGIC: FOLDER -> TAGS ---
def process_file_metadata(filepath, root_folder):
    """
    Reads the folder structure to create tags automatically.
    Example: 
      File: /mnt/c/Library/Furniture/Chairs/Office/Aeron.dwg
      Result: Category="Furniture", Tags=["Chairs", "Office"]
    """
    filename = os.path.basename(filepath)
    name_only = os.path.splitext(filename)[0]
    
    try:
        # Get path relative to the watched root
        rel_path = os.path.relpath(filepath, root_folder)
    except ValueError:
        return name_only, "Uncategorized", "[]"

    # Split the path into folders
    # os.sep handles both Windows (\) and Linux (/) separators
    folders = os.path.dirname(rel_path).split(os.sep)
    
    # Filter out empty strings or current directory markers
    folders = [f for f in folders if f and f != "."]

    if not folders:
        return name_only, "Uncategorized", "[]"

    # 1. First folder is the Category
    category = folders[0]
    
    # 2. The rest are Tags
    tags_list = folders[1:] if len(folders) > 1 else []
    
    return name_only, category, json.dumps(tags_list)

# --- DATABASE OPERATIONS ---
def add_asset(filepath, root_folder):
    # Only index .dwg files (add other extensions if needed like .pdf, .rvt)
    if not filepath.lower().endswith('.dwg'): 
        return
    
    name, category, tags = process_file_metadata(filepath, root_folder)
    
    # --- NEW LOGIC: Create the Master Search Term ---
    # Combine name + category + tags into one lowercase string for easy searching
    master_search_string = f"{name} {category} {tags}".lower()
    
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        
        # UPDATED: Insert the search_term
        cursor.execute('''
            INSERT OR REPLACE INTO assets (filename, file_path, category, tags, search_term)
            VALUES (?, ?, ?, ?, ?)
        ''', (name, filepath, category, tags, master_search_string))
        conn.commit()
        conn.close()
        
        # SEND JSON TO FLUTTER (via Standard Output)
        output = {
            "event": "added",
            "name": name,
            "category": category,
            "tags": json.loads(tags),
            "path": filepath
        }
        print(json.dumps(output), flush=True)
        
    except Exception as e:
        error = {"event": "error", "message": str(e)}
        print(json.dumps(error), flush=True)

def remove_asset(filepath):
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM assets WHERE file_path = ?", (filepath,))
        conn.commit()
        conn.close()
        
        print(json.dumps({"event": "removed", "path": filepath}), flush=True)
    except Exception as e:
        pass

# --- WATCHDOG HANDLER ---
class AssetHandler(FileSystemEventHandler):
    def __init__(self, root_folder):
        self.root_folder = root_folder

    def on_created(self, event):
        if not event.is_directory:
            add_asset(event.src_path, self.root_folder)

    def on_deleted(self, event):
        if not event.is_directory:
            remove_asset(event.src_path)

    def on_moved(self, event):
        if not event.is_directory:
            remove_asset(event.src_path)
            add_asset(event.dest_path, self.root_folder)

# --- MAIN ENTRY POINT ---
def scan_existing_files(folder_path):
    """Scans files that are ALREADY in the folder before we started watching."""
    # Send a "status" event so UI knows we are working
    print(json.dumps({"event": "status", "message": "Scanning existing files..."}), flush=True)
    
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            full_path = os.path.join(root, file)
            add_asset(full_path, folder_path)
            
    print(json.dumps({"event": "status", "message": "Scan complete. Watching for changes."}), flush=True)

if __name__ == "__main__":
    # Initialize DB logic
    init_db()
    
    # Get the folder path from command line arguments
    if len(sys.argv) > 1:
        target_folder = sys.argv[1]
        
        if os.path.exists(target_folder):
            # 1. Index what is already there
            scan_existing_files(target_folder)
            
            # 2. Start watching for new stuff
            event_handler = AssetHandler(target_folder)
            observer = Observer()
            observer.schedule(event_handler, target_folder, recursive=True)
            observer.start()
            
            try:
                while True:
                    time.sleep(1)
            except KeyboardInterrupt:
                observer.stop()
            observer.join()
        else:
            print(json.dumps({"event": "error", "message": "Folder not found"}))
    else:
        print(json.dumps({"event": "error", "message": "No folder path provided"}))