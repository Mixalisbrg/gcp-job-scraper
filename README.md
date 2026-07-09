# Automated Web Scraper for Job Listings on Google Cloud Platform

## Project Overview
An end-to-end data pipeline that automatically scrapes job listings from the web and stores them in Google BigQuery. The scraper runs on a fully serverless, containerized setup on Google Cloud Platform (GCP) and executes automatically on a daily schedule — no manual intervention required.

## Architecture
The pipeline follows a serverless, event-driven design:

1. **Cloud Scheduler** sends a daily HTTP request to the Cloud Run service.
2. **Cloud Run** runs a containerized Flask app that launches a headless Chrome browser.
3. **Selenium** scrapes the job listings from the target website.
4. The data is cleaned and structured with **pandas**.
5. The result is loaded into a **BigQuery** table, overwriting the previous day's data.

## Skills Demonstrated
- **Web Scraping** — Automated data extraction with Selenium and headless Chrome.
- **Containerization** — Packaging the application (including the Chrome browser) into a Docker image.
- **Cloud Deployment** — Deploying a serverless service on Cloud Run.
- **Workflow Automation** — Scheduling recurring jobs with Cloud Scheduler.
- **Data Warehousing** — Storing and managing structured data in BigQuery.

## Tech Stack
- **Language:** Python
- **Scraping:** Selenium, webdriver-manager
- **Web framework:** Flask (served with Gunicorn)
- **Data:** pandas, Google Cloud BigQuery
- **Infrastructure:** Docker, Google Cloud Run, Google Cloud Scheduler

## Project Structure
| File | Description |
|------|-------------|
| `app.py` | Flask application — the entry point deployed on Cloud Run. Wraps the scraping logic in an HTTP endpoint. |
| `main.py` | Standalone version of the scraper for local development and testing. |
| `settings.example.py` | Template for configuration. Copy to `settings.py` and fill in your own values. |
| `requirements.txt` | Python dependencies. |
| `Dockerfile` | Builds the container image, including the Chrome browser and a virtual display for headless operation. |

## Setup and Local Testing

### Prerequisites
- A Google Cloud Platform account ([free trial](https://cloud.google.com/free))
- A GCP project with the BigQuery API enabled
- A service account with `BigQuery Data Editor` and `BigQuery Job User` roles, and its JSON key
- Python 3.11+ and Docker installed locally

### 1. Clone the repository
```bash
git clone https://github.com/Mixalisbrg/gcp-job-scraper.git
cd gcp-job-scraper
```

### 2. Configure your settings
Copy the example config and fill in your own project details:
```bash
cp settings.example.py settings.py
```
Then edit `settings.py` with your GCP project ID, dataset ID, table name, and the path to your service account JSON key.

> **Note:** `settings.py` and the service account `*.json` key are excluded from version control via `.gitignore`. Never commit credentials to a public repository.

### 3. Install dependencies
```bash
python -m venv venv
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
```

### 4. Run locally
```bash
python main.py
```
This runs the scraper directly and loads the results into your BigQuery table.

## Deployment on Google Cloud

### 1. Build and push the Docker image
```bash
docker build -t gcr.io/YOUR_PROJECT_ID/scraper-production .
docker push gcr.io/YOUR_PROJECT_ID/scraper-production
```

### 2. Deploy to Cloud Run
```bash
gcloud run deploy scraper-production \
  --image gcr.io/YOUR_PROJECT_ID/scraper-production \
  --platform managed \
  --region europe-west8 \
  --allow-unauthenticated \
  --memory 2Gi
```

### 3. Schedule with Cloud Scheduler
Create a Cloud Scheduler job that sends a daily HTTP `GET` request to the Cloud Run service URL (e.g. cron `0 8 * * *` for 08:00 daily).

## Acknowledgments
This project was built as part of the portfolio curriculum from [DataProjects.io](https://dataprojects.io), a platform that helps data professionals build real-world, end-to-end projects on the cloud.
