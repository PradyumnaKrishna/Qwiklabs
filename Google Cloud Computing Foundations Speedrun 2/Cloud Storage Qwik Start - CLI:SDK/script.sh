gcloud init < a 

echo -n "Project ID ->"
read ID

gsutil mb gs://$ID

gsutil cp ./ada.jpg gs://$ID/ada.jpg

gsutil cp gs://$ID/ada.jpg gs://$ID/image-folder/

gsutil acl ch -u AllUsers:R gs://$ID/ada.jpg
