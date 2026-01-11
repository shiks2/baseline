import sqlite3
import json
import sys
import os

# --- CONFIGURATION ---
# UPDATED: Pointing to your new database version
DB_NAME = "imperium1.db"

def search_assets(query):
    """
    Searches the database for the query string using the optimized 'search_term' column.
    """
    try:
        # 1. Connect to the Database
        if not os.path.exists(DB_NAME):
            # If DB doesn't exist, return empty list (don't crash)
            print(json.dumps({"error": f"Database {DB_NAME} not found."}))
            return

        conn = sqlite3.connect(DB_NAME)
        conn.row_factory = sqlite3.Row # This lets us access columns by name
        cursor = conn.cursor()

        # 2. The Search Logic
        # We search ONLY the 'search_term' column because it contains 
        # the Name + Category + Tags all combined in lowercase.
        sql = "SELECT * FROM assets WHERE search_term LIKE ? LIMIT 50"
        
        # Add wildcards % around the query for partial matching
        # e.g. "chair" becomes "%chair%"
        wildcard_query = f"%{query.lower()}%"
        
        cursor.execute(sql, (wildcard_query,))
        rows = cursor.fetchall()
        
        # 3. Format the Results
        results = []
        for row in rows:
            results.append({
                "id": row["id"],
                "name": row["filename"],
                "category": row["category"],
                # Parse the tags string back into a real list (handle potential errors)
                "tags": json.loads(row["tags"]) if row["tags"] else [], 
                "path": row["file_path"]
            })

        # 4. Output JSON to Standard Output (Flutter reads this)
        print(json.dumps(results))
        
        conn.close()

    except Exception as e:
        # Return empty list on error so the App doesn't crash
        # You can print the error to a log file if needed, but Flutter expects JSON list
        error_response = [{"error": str(e)}]
        print(json.dumps(error_response)) 

if __name__ == "__main__":
    # Get the search query from the command line argument
    # Usage: python3 librarian.py "chair"
    if len(sys.argv) > 1:
        user_query = sys.argv[1]
        search_assets(user_query)
    else:
        # If no query provided, return empty list
        print(json.dumps([]))