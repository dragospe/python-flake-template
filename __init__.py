#!/usr/bin/env python3

from flask import send_file
from flask import Flask
from io import BytesIO
from PIL import Image
import requests


app = Flask(__name__)


IMAGE_URL = "https://farm1.staticflickr.com/422/32287743652_9f69a6e9d9_b.jpg"
IMAGE_SIZE = (300, 300)


@app.route('/')
def hello():
    return "Hello World!"


@app.route('/image')
def image():
    r = requests.get(IMAGE_URL)
    if not r.status_code == 200:
        raise ValueError(f"Response code was '{r.status_code}'")

    img_io = BytesIO()

    img = Image.open(BytesIO(r.content))
    img.thumbnail(IMAGE_SIZE)
    img.save(img_io, 'JPEG', quality=70)

    img_io.seek(0)

    return send_file(img_io, mimetype='image/jpeg')


def main():
    app.run()


if __name__ == '__main__':
    main()
