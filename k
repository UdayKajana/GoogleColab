#!/usr/bin/env python3
import argparse
import logging
import subprocess
import sys

def main():
    # Set up argument parser for Flex Template parameters
    parser = argparse.ArgumentParser()
    parser.add_argument('--query', required=True, help='BigQuery SQL query to execute')
    parser.add_argument('--project', required=True, help='GCP Project ID')
    args, pipeline_args = parser.parse_known_args()

    # Log received arguments
    logging.basicConfig(level=logging.INFO)
    logging.info(f"Launcher received arguments: query={args.query}, project={args.project}")

    # Run the pipeline script with the received arguments
    pipeline_command = [
        "python",
        "/app/pipeline.py",  # Path to your pipeline script
        f"--query={args.query}",
        f"--project={args.project}"
    ] + pipeline_args

    # Execute the pipeline
    logging.info(f"Executing pipeline with command: {' '.join(pipeline_command)}")
    result = subprocess.run(pipeline_command, check=True)
    logging.info(f"Pipeline finished with return code: {result.returncode}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logging.error(f"Error in launcher: {e}")
        sys.exit(1)


# Use Apache Beam Python SDK image or a standard Python image
FROM apache/beam_python3.9_sdk:2.48.0

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file and install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# Copy pipeline code and launcher script
COPY dfpipeline.py /app/pipeline.py
COPY python_template_launcher.py /app/python_template_launcher.py

# Set launcher as the entry point
ENTRYPOINT ["python", "/app/python_template_launcher.py"]
