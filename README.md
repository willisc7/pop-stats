# Population stats

Simple web app that pulls population data based on address queries. 

Population data gathered from the U.S. Census Bureau [Population Estimate API](https://www.census.gov/data/developers/data-sets/popest-popproj/popest.html).

## Building, Deploying & Running
This is a straightfoward Python Flask application which can be run in several ways including locally via python, as a Docker container, k8s, or Google Cloud Run.

### via Python

From the root dir of the app:

`$ python app.py`

The app will be available on localhost port 8080 (e.g., `http://0.0.0.0:8080`)

### via Dockerfile

From the root dir of the app:

`$ docker build -t popstats -f docker/pythonalpine.Dockerfile . && docker run --rm -p 8080:8080 -e PORT=8080 popstats`

The app will be available on localhost port 8080 (e.g., `http://0.0.0.0:8080`)

### via Google Cloud Run (via Cloud Build)

[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run)

\- OR -

Before you begin, [grant Cloud Build permission to deploy to Cloud Run](https://cloud.google.com/build/docs/deploying-builds/deploy-cloud-run#before_you_begin)

From the root dir of the app:

`$ gcloud builds submit . --config=cr-cloudbuild.yaml`

The build results will provide a unique URL for the app.

## Testing geolocation in dev
Geolocation is done by IP address (using [ip-api.com](https://ip-api.com)). When testing locally, your external IP may not be reported to the app, so set the `DEV_EXT_IP` to your external IP address in your dev environment or in the Dockerfile.

## Contributing
This is my first github project so feel free to submit recommendations via PR, or shoot me a message.
This project is not affiliated or sponsored by Alphabet or Google.
