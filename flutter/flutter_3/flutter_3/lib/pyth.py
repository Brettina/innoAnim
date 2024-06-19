from flask import Flask, send_file
import cv2
# this needs to run manually before starting anything,
# because python scripts rely on server connection through flask

#notwendig> python -m http.server 8080
app = Flask(__name__)

@app.route("/hello_world")
#def hello_world():
  #  print("heasdfadfao rowlrd")
  #  return "hellooooooo"


@app.route("/open_image")
def open_image():
    try:
        # Replace this path with your image path
        image_path = 'http://localhost:8080/pic1.jpg'
        img = cv2.imread(image_path)
        
        # Example processing with OpenCV
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # Convert processed image to bytes
        _, img_encoded = cv2.imencode('.jpg', gray)
        
        # Convert bytes to bytesio object
        img_bytes = io.BytesIO(img_encoded)
        
        return send_file(img_bytes, mimetype='image/jpeg')
    
    except Exception as e:
        print(f"Error opening image: {e}")
        return "Error opening image"
    


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)