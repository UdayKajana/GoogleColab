gcloud dataflow flex-template run my-flex-template-job \
  --template-file-gcs-location gs://<your-bucket>/templates/my-template-name \
  --parameters input_bq_table=test_dataset.dim_inventory_customer_profiles_norm_v0,output_gcs_path=gs://vznet-test/wireline_churn_test/tmp/
