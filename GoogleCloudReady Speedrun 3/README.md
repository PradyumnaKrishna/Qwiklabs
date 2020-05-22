# Speed-Run-3
##### Script for Speed Run 3 

There are 4 labs in game [**Speed Run 3**](https://www.qwiklabs.com/games/950) in which script for 4th lab is still in development. May be 4th lab can be done only by login to GCP console.
Hence script for other labs are ready for run.

## 1st LAB : [Cloud IAM: Qwik Start](https://www.qwiklabs.com/focuses/551?parent=catalog)
In this lab, Two username will be given. The password given is password of both usernames.
1. we have to login through the script using 1st username because username1 has Cloud IAM owner rights.
2. And then script will ask for project ID and 2nd username which we should copy and paste that.
* **Note**: You can avoid asking for project ID by editing the script. but you will have to set the name for bucket storage as project id is used for naming bucket storage.
3. then process clicking check points and end the lab.

## 2nd LAB : [Introduction to SQL for BigQuery and Cloud SQL](https://www.qwiklabs.com/focuses/2802?parent=catalog)
This lab has minimum time requirement of 2-3 minutes because of only one command that is the creation of cloud sql vm.
The process is divided into 2 stage:
first run in local system using gcloud and second run through ssh for sql server access and running sql commands.
1. Run the script and login and enter Project ID when asked.
* **Note**: Same as above
2. When we proceed to ssh, we simply copy commands from **copypaste** file given in **2** directory and paste it to ssh prompt for running the commands
* **Note**: run the first command given in **copypaste** separately because first command will ask for password. Simply press enter key when ask for password and then run second command that is *SQL Command*

## 3rd LAB : [Multiple VPC Networks](https://www.qwiklabs.com/focuses/1230?parent=catalog)
This lab is easiest lab with minimum effort.
Just run the script and login and paste the project ID and start clicking check points.

## 4th LAB : [Cloud Monitoring: Qwik Start](https://www.qwiklabs.com/focuses/10599?parent=catalog)
All the commands for this lab is not available on gcloud command line.
So you need to follow procedure to create Alerting & Uptime Check in cloud monitoring from Google Cloud Console.
