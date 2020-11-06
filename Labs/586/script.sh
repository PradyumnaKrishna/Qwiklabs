#! /bin/bash


gcloud init < a

gcloud config set dataproc/region global

gcloud dataproc clusters create example-cluster

gcloud dataproc jobs submit spark --cluster example-cluster  --class org.apache.spark.examples.SparkPi  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000 
gcloud dataproc clusters update example-cluster --num-workers 4


