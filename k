# Use Dataflow's Python Flex Template base image
FROM gcr.io/dataflow-templates-base/python3-template-launcher

# Set working directory
WORKDIR /app

# Install additional dependencies if required
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file and install dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# Copy pipeline code
COPY dfpipeline.py /app/pipeline.py

# Set the entry point for the Dataflow launcher
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]


gcloud dataflow flex-template build \
gs://vznet-test/wireline_churn_test/src/template.json \
--image us-east4-docker.pkg.dev/vz-it-np-gudv-dev-vzntdo-0/vznet/pipeline_env:V1 \
--sdk-language "PYTHON" \
--metadata-file /home/udayka/workspace/metadata.json



gcloud dataflow flex-template run bigquery123 \
--template-file-gcs-location gs://vznet-test/wireline_churn_test/src/template.json \
--region us-east4 \
--parameters query="SELECT * FROM vz-it-np-gudv-dev-vzntdo-0.vzn_nsdl_common_core_tbls.echo_ticket_opened_proc_v0 LIMIT 10",project="vz-it-np-gudv-dev-vzntdo-0" \
--temp-location=gs://vznet-test/wireline_churn_test/tmp/ \
--num-workers 2 \
--max-workers 2 \
--worker-machine-type n2-standard-2 \
--disable-public-ips \
--network=shared-np-east \
--dataflow-kms-key=projects/vz-it-np-d0sv-vsadkms-0/locations/us-east4/keyRings/vz-it-np-kr-aid/cryptoKeys/vz-it-np-kms-gudv \
--subnetwork=https://www.googleapis.com/compute/v1/projects/vz-it-np-exhv-sharedvpc-228116/regions/us-east4/subnetworks/shared-np-east-green-subnet-2 \
--service-account-email sa-dev-gudv-app-vzntdo-0@vz-it-np-gudv-dev-vzntdo-0.iam.gserviceaccount.com
