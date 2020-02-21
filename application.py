from flask import Flask

application = Flask(__name__)

@application.route("/")
def index():
    return """
    <html>
      <head>
        <title>Hello, Docker!</title>
      </head>
      <body>
        <h1>Hello, Docker!</h1>
        <div>Welcome to the docker world!</div>
      </body>
    </html>
    """
if __name__ == "__main__":
    application.run(host='0.0.0.0')
