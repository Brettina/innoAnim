from flask import Flask, request
import webbrowser
import subprocess


app = Flask(__name__)
@app.route('/list_files', methods=['GET'])
def list_files():
    # Get the current directory where the server.py script is located
    current_directory = os.getcwd()
    
    # List all files in the current directory
    files = os.listdir(current_directory)
    
    # Filter out directories from the list
    files = [f for f in files if os.path.isfile(os.path.join(current_directory, f))]
    
    # Return the list of files as JSON response
    return jsonify(files)

@app.route('/python_http_method_post', methods=['POST'])
def python_http_method_post():
    # Open a new tab in the browser
    webbrowser.open_new_tab('https://ciceon-engineering.com')
    # Your Python method logic here
    return 'Python POST method executed successfully'

@app.route('/python_http_method_get', methods=['GET'])
def python_http_method_get():
    # Extract information from the request, if needed
    param1 = request.args.get('param1')
    param2 = request.args.get('param2')
    
    # Open a new tab in the browser
    webbrowser.open_new_tab(f'https://ciceon-engineering.com?param1={param1}&param2={param2}')
    
    return 'Python GET method executed successfully'

@app.route('/start_video', methods=['POST'])
def start_video():
    data = request.get_json()
    video_path = data.get('path')
    
    # Use subprocess to start the video player (e.g., VLC)
    try:
        subprocess.run(['vlc', video_path])
        return 'Video started successfully', 200
    except Exception as e:
        return str(e), 500

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
