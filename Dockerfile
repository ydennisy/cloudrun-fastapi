# Use the official Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

# Set an environment to stream logs.
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY ./requirements.txt requirements.txt

# Update pip.
# Install any needed packages specified in requirements.txt
# Download the spacy models.
# Download the text embedding model at build time, not runtime. 
RUN python -m pip install --upgrade pip \
    && pip install --trusted-host pypi.python.org -r requirements.txt

COPY . ./

# Run the web service on container startup. 
CMD exec uvicorn main:app --host 0.0.0.0 --port 8080
