# **To be execute in Cloud Shell only**

**Initialization**

    ID=$(gcloud info --format='value(config.project)')

**1. Creating a custom role**

    gcloud iam roles create editor --project $ID \
        --title "Role Editor" \
        --description "Edit access for App Versions" \
        --permissions appengine.versions.create,appengine.versions.delete \
        --stage ALPHA

    gcloud iam roles create viewer --project $ID \
        --title "Role Viewer" \
        --description "Custom role description." \
        --permissions compute.instances.get,compute.instances.list \
        --stage ALPHA


**2. Editing an existing custom role**

    gcloud iam roles update editor --project $ID \
        --add-permissions storage.buckets.get,storage.buckets.list

    gcloud iam roles update viewer --project $ID \
        --add-permissions storage.buckets.get,storage.buckets.list

**3. Disabling a custom role**

    gcloud iam roles update viewer --project $ID \
        --stage DISABLED

**4. Deleting & Undeleting a custom role**

    gcloud iam roles delete viewer --project $ID

    gcloud iam roles undelete viewer --project $ID
