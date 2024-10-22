FROM python:3.12.7-slim

WORKDIR /mlflow/

COPY pyproject.toml poetry.lock ./

RUN pip install --no-cache-dir poetry && \
	poetry config virtualenvs.create false && \
	poetry install --no-dev --no-interaction --no-ansi

# Expose the MLflow server port
EXPOSE 5000

# Set environment variables for MLflow
ENV BACKEND_URI=sqlite:////mlflow/mlflow.db
ENV ARTIFACT_ROOT=/mlflow/artifacts

# Create a script to start the MLflow server
RUN echo '#!/bin/sh\n\
	exec poetry run mlflow server --backend-store-uri "$BACKEND_URI" --default-artifact-root "$ARTIFACT_ROOT" --host 0.0.0.0 --port 5000' > start_mlflow.sh && \
	chmod +x start_mlflow.sh

# Command to run the MLflow server
CMD ["./start_mlflow.sh"]
