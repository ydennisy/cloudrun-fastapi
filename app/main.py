import logging

from fastapi import FastAPI
from pydantic import BaseModel
from google.cloud import error_reporting


app = FastAPI()
err_client = error_reporting.Client()


@app.get('/get', status_code=200)
def get():
    try:
        return 'Hello World!'
    except Exception as ex:
        logging.exception(ex)
        err_client.report_exception()
        raise


class Payload(BaseModel):
    message: str


@app.post('/post', status_code=200)
def post(params: Payload):
    try:
        return {
            'hello': params.message
        }
    except Exception as ex:
        logging.exception(ex)
        err_client.report_exception()
        raise
