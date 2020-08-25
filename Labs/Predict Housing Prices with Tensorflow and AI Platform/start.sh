git clone https://github.com/GoogleCloudPlatform/training-data-analyst
pip install runipy
cd training-data-analyst/blogs/housing_prices
ID=$(gcloud info --format='value(config.project)')
sed -i "s/BUCKET_NAME/""$ID""/g" cloud-ml-housing-prices.ipynb
runipy cloud-ml-housing-prices.ipynb