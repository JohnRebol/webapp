import os
from importlib import import_module

APP_VERSION = os.environ.get("APP_VERSION", "dev")
GIT_SHA = os.environ.get("GIT_SHA", "unknown")

# Resolve Flask at runtime so static analyzers do not require Flask's stubs.
_flask = import_module("flask")
Flask = _flask.Flask
render_template = _flask.render_template

app = Flask(__name__)

# --- Site content -----------------------------------------------------
# Edit this dict to change contact info without touching the template.
COMPANY = {
    "name": "Bedrock & Beam Construction",
    "tagline": "Built on the ground up.",
    "phone": "(555) 812-4477",
    "email": "info@bedrockbeam.com",
    "address": "4210 Foundry Road, Millbrook, IL 60041",
    "hours": "Mon-Fri 7am-5pm, Sat by appointment",
}

# Filenames expected in static/images/. Swap these for your real photos.
GALLERY_IMAGES = [
    {"file": "project-1.jpg", "caption": "Custom kitchen remodel"},
    {"file": "project-2.jpg", "caption": "New home framing"},
    {"file": "project-3.jpg", "caption": "Commercial buildout"},
    {"file": "project-4.jpg", "caption": "Deck & outdoor living"},
]


@app.route("/")
def index():
    return render_template("index.html", company=COMPANY, gallery=GALLERY_IMAGES)


@app.route("/health")
def health():
    return {"status": "ok", "version": APP_VERSION, "sha": GIT_SHA[:7]}


if __name__ == "__main__":
    # host=0.0.0.0 so it's reachable from outside the container
    app.run(host="0.0.0.0", port=5000, debug=False)
