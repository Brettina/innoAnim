
# this needs to run manually before starting anything,
# because python scripts rely on server connection through flask
#brauche 2 server bzw ports
# 1 on 5000> pzthon server> dieses file starten
# 2 on 8080> local server> python -m http.server 8080

#192.168.178.32:8080 oder wenn in ;ffentlichen netywerken localhost:8080

from flask import Flask, send_file, redirect
import urllib.request
from urllib.request import urlretrieve
import requests
from PIL import Image
from io import BytesIO

from flask_cors import CORS
fileserver = 'http://localhost:8080'


app = Flask(__name__)

@app.route("/hell")
def hello_world():
    print("Hello world")
    return "hellooooooo"


@app.route("/img")
def open_image():
    url = ("http://localhost:8080")
    filename = "/pic2.jpg"
    new = url+filename
    print(new)
    response = requests.get(new)
        
        # Check if the request was successful (status code 200)
    if response.status_code == 200:
            # Open the image using PIL
        img = Image.open(BytesIO(response.content))
            
            # Display the image (optional)
        img.show()
            
            # Save the image to a file (optional)
            # img.save('downloaded_image.jpg')
    else:
        print(f"Failed to retrieve image. Status code: {response.status_code}")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)