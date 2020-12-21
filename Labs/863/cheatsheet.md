# **To be execute in Cloud Shell only**

**Initialization**

    ID=$(gcloud info --format='value(config.project)')

    echo "resources:
    - type: compute.v1.instance
      name: vm-my-first-deployment
      properties:
        zone: us-central1-f
        machineType: https://www.googleapis.com/compute/v1/projects/<MY_PROJECT>/zones/us-central1-f/machineTypes/f1-micro
        disks:
        - deviceName: boot
          type: PERSISTENT
          boot: true
          autoDelete: true
          initializeParams:
            sourceImage: https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/debian-9
        networkInterfaces:
        - network: https://www.googleapis.com/compute/v1/projects/<MY_PROJECT>/global/networks/default
          # Access Config required to give the instance a public IP address
          accessConfigs:
          - name: External NAT
            type: ONE_TO_ONE_NAT" > vm.yaml

    sed -i "s/<MY_PROJECT>/""$ID""/g" vm.yaml

**1. Deploy your configuration**

    gcloud deployment-manager deployments create my-first-deployment --config vm.yaml