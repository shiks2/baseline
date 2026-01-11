import sys
import os
import json

class AssetInjector:
    def inject(self, file_path: str):
        response = {"status": "error", "message": "Unknown error"}
        
        try:
            # Lazy import so non-Windows devs don't crash immediately
            from pyautocad import Autocad
            
            # 1. Connect to AutoCAD
            acad = Autocad(create_if_not_exists=False)
            
            if not acad.app:
                response["message"] = "AutoCAD is not running."
                print(json.dumps(response))
                return

            # 2. Validate Path
            if not os.path.exists(file_path):
                response["message"] = f"File not found: {file_path}"
                print(json.dumps(response))
                return

            # 3. Send Command
            # Replace backslashes for AutoCAD LISP compatibility
            clean_path = file_path.replace('\\', '/')
            
            # Command: -INSERT "Path" pause 1 1 0
            # 'pause' lets the user click on screen
            command = f'(command "-INSERT" "{clean_path}" pause "1" "1" "0") '
            
            # Send to Active Document
            acad.doc.SendCommand(command)
            
            response = {"status": "success", "message": "Insertion started in AutoCAD."}

        except ImportError:
             response["message"] = "pyautocad library not installed. Run 'pip install pyautocad'."
        except Exception as e:
            response["message"] = str(e)

        print(json.dumps(response))