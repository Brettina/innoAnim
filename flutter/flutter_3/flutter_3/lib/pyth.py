from flask import Flask, request
import webbrowser

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
