# Google Cloud configuration
# Rename this file to settings.py and fill in your own values.

# Path to your Google Cloud service account JSON key
GOOGLE_APPLICATION_CREDENTIALS = "your-service-account-key.json"

# Google Cloud Project Configuration
BIGQUERY_PROJECT_ID = "your-gcp-project-id"
BIGQUERY_DATASET_ID = "your-dataset-id"
BIGQUERY_TABLE_NAME = "job_postings"
BIGQUERY_LOCATION = "europe-west8"

# Web Scraping Configuration
JOB_BOARD_URL = "https://realpython.github.io/fake-jobs/"
PAGE_LOAD_DELAY = 2