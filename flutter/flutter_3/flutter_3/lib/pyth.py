from flask import Flask, send_file
import cv2
import numpy as np
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    # Your Python method here
    print("Hello, world!")
    return 'Hello, World!'

@app.route('/process_image', methods=['POST'])
def process_image():
    # Generate a simple image with OpenCV
    image = np.zeros((100, 200, 3), dtype=np.uint8)
    cv2.putText(image, 'Hello, World!', (5, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)
    
    # Save the image
    output_path = '/assets/pdv.png'
    cv2.imwrite(output_path, image)
    
    # Send the image file back to the client
    return send_file(output_path, mimetype='image/png')

if __name__ == '__main__':
    app.run(port=8080, debug=True)
