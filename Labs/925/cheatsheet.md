# **To be execute in Cloud Shell only**

**1. Create a Pub/Sub topic**

    gcloud pubsub topics create myTopic

**2. Create Pub/Sub Subscription**

    gcloud  pubsub subscriptions create --topic myTopic mySubscription
