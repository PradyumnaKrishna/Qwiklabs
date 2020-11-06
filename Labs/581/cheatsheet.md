# **To be execute in Cloud Shell only**

**1. Create Virtual Environment**

    sudo apt-get update

    sudo apt-get install virtualenv -y

    virtualenv -p python3 venv

    source venv/bin/activate

**2. Clone The Repo**

    git clone https://github.com/GoogleCloudPlatform/training-data-analyst.git

    cd training-data-analyst/self-paced-labs/tensorflow-2.x/census

**3. Deploy Traning Application Locally**

    mkdir data
    gsutil -m cp gs://cloud-samples-data/ml-engine/census/data/* data/

    export TRAIN_DATA=$(pwd)/data/adult.data.csv
    export EVAL_DATA=$(pwd)/data/adult.test.csv

    head data/adult.data.csv

**4. Install Dependencies**

    pip install -r requirements.txt

**5. Run Local Training Job**

    export MODEL_DIR=output

    gcloud ai-platform local train \
        --module-name trainer.task \
        --package-path trainer/ \
        --job-dir $MODEL_DIR \
        -- \
        --train-files $TRAIN_DATA \
        --eval-files $EVAL_DATA \
        --train-steps 1000 \
        --eval-steps 100
**6. Prepare Input for Prediction**

    python

    from trainer import util
    _, _, eval_x, eval_y = util.load_data()

    prediction_input = eval_x.sample(5)
    prediction_targets = eval_y[prediction_input.index]

    print(prediction_input)

    import json

    with open('test.json', 'w') as json_file:
      for row in prediction_input.values.tolist():
        json.dump(row, json_file)
        json_file.write('\n')

    quit()

**7. Use your Training Model for Prediciton**

    gcloud ai-platform local predict \
        --model-dir output/keras_export/ \
        --json-instances ./test.json

**8. Run your training job in the cloud**

    PROJECT_ID=$(gcloud config list project --format "value(core.project)")
    BUCKET_NAME=${PROJECT_ID}-aiplatform
    echo $BUCKET_NAME
    REGION=us-central1

    gsutil mb -l $REGION gs://$BUCKET_NAME

    gsutil cp -r data gs://$BUCKET_NAME/data

    TRAIN_DATA=gs://$BUCKET_NAME/data/adult.data.csv
    EVAL_DATA=gs://$BUCKET_NAME/data/adult.test.csv

    gsutil cp test.json gs://$BUCKET_NAME/data/test.json

    TEST_JSON=gs://$BUCKET_NAME/data/test.json

**9. Run a single-instance trainer in the cloud**

    JOB_NAME=census_single_1

    OUTPUT_PATH=gs://$BUCKET_NAME/$JOB_NAME

    gcloud ai-platform jobs submit training $JOB_NAME \
        --job-dir $OUTPUT_PATH \
        --runtime-version 2.1 \
        --python-version 3.7 \
        --module-name trainer.task \
        --package-path trainer/ \
        --region $REGION \
        -- \
        --train-files $TRAIN_DATA \
        --eval-files $EVAL_DATA \
        --train-steps 1000 \
        --eval-steps 100 \
        --verbosity DEBUG

    gcloud ai-platform jobs stream-logs $JOB_NAME

**10. Deploy your model to support prediction**

    MODEL_NAME=census

    gcloud ai-platform models create $MODEL_NAME --regions=$REGION

    gsutil ls -r $OUTPUT_PATH/keras_export

    MODEL_BINARIES=$OUTPUT_PATH/keras_export/

    gcloud ai-platform versions create v1 \
        --model $MODEL_NAME \
        --origin $MODEL_BINARIES \
        --runtime-version 2.1 \
        --python-version 3.7