from flask import Flask, request
import os
import subprocess



app = Flask(__name__)
@app.route('/list_files', methods=['GET'])
def list_files():
    try:
        # Get the current directory where the server.py script is located
        current_directory = os.getcwd()
        print("Current Directory:", current_directory)
        
        # Directory to list files from
        #funktionieren leider nur absolute filepaths
        directory = 'D:/cideon/innotrans/flutter/assetsserv'
        print("Listing files from Directory:", directory)
        
        # List all files in the current directory
        files = os.listdir(directory)
        print("Files in Directory:")
        for file in files:
            print(file)
        
        # Filter out directories from the list
        files = [f for f in files if os.path.isfile(os.path.join(directory, f))]

        # Find the first MP4 file and return its path
        mp4_file_path = None
        for file in files:
            if file.lower().endswith('.mp4'):
                mp4_file_path = os.path.join(directory, file)
                break
        
        if mp4_file_path:
            print("MP4 file found:", mp4_file_path)
            return mp4_file_path
        else:
            print("No MP4 file found in the directory")
            
    except Exception as e:
        # If an error occurs, return an error message
        return "error"

@app.route('/start_video', methods=['POST'])
def start_video():
    data = request.get_json()
    video_path = data.get('path')
    print(video_path)
    
    # Use subprocess to start the video player (e.g., VLC)
    try:
        subprocess.run(['vlc', video_path])
        return 'Video started successfully', 200
    except Exception as e:
        return str(e), 500

@app.route('/print_text', methods=['POST'])
def print_text():
    data = request.get_json()
    text = data.get('text')
    
    # Print text on the server console
    print(text)
    return 'Text printed successfully on server console', 200

@app.route('/start_video_with_params', methods=['GET'])
def start_video_with_params():
    video_path = request.args.get('path')
    
    # Use subprocess to start the video player
    try:
        subprocess.run(['vlc', video_path])
        return 'Video started successfully', 200
    except Exception as e:
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
