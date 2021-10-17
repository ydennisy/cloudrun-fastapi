.EXPORT_ALL_VARIABLES:

PORT ?= 8080
RUN_REGION ?= europe-west1
GCP_PROJECT ?= ag-edgekit-dev
SERVICE_NAME ?= cloudrun-fastapi

install-deps:
	pip install -r requirements.txt 

serve:
	uvicorn app.main:app --reload

gcloud-build:
	gcloud builds submit \
		--project $(GCP_PROJECT) \
		--tag gcr.io/$(GCP_PROJECT)/$(SERVICE_NAME)

gcloud-deploy:
	gcloud run deploy $(SERVICE_NAME) \
		--quiet \
		--project $(GCP_PROJECT) \
		--image gcr.io/$(GCP_PROJECT)/$(SERVICE_NAME) \
		--region $(RUN_REGION) \
		--platform managed \
		--max-instances 10 \
		--cpu 1 \
		--memory 1Gi \
		--timeout 60 \
		--set-env-vars GCP_PROJECT=$(GCP_PROJECT),BQ_DATASET=$(BQ_DATASET),BQ_TABLE=$(BQ_TABLE)
