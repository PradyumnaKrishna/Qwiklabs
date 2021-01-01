sudo apt-get update
sudo apt-get install git wget -y
sudo apt-get install python3-setuptools python3-dev build-essential -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py

git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd ~/training-data-analyst/courses/developingapps/python/devenv/
sudo python3 server.py