import logging

from fastapi import FastAPI
from pydantic import BaseModel
from google.cloud import error_reporting


app = FastAPI()
err_client = error_reporting.Client()


class Payload(BaseModel):
    message: str


@app.post('/', status_code=200)
def process(params: Payload):
    try:
        return params.message
    except Exception as ex:
        logging.exception(ex)
        err_client.report_exception()
        return
