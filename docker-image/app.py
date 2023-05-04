import socket
import time
from datetime import datetime
from flask import Flask

app = Flask(__name__)

@app.route('/')
def worker():
    ts = time.time()
    dt = datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    hostname = socket.gethostname()
    message = f"{dt} {hostname}\n"
    return message

if __name__ == '__main__':
    app.run(port=8080, debug=True)