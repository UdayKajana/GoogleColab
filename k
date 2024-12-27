# Use the official Dataflow Docker image  
FROM gcr.io/dataflow-templates/python3-template  
  
# Copy pipeline code  
COPY dfpipeline.py /app/pipeline.py  
  
# Set environment variables  
ENV DATAFLOW_ENDPOINT=https://dataflow.googleapis.com  
ENV DATAFLOW_PROJECT=vz-it-np-gudv-dev-vzntdo-0  
ENV DATAFLOW_REGION=us-east4  
ENV DATAFLOW_TEMP_LOCATION=gs://vznet-test/wireline_churn_test/tmp/  
  
# Use the standard entry point  
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
