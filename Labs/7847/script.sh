#! /bin/bash

# Initialization
gcloud init < a

printf "\e[1m%s\n\e[m" 'Update BigQuery Quota first from https://console.cloud.google.com/iam-admin/quotas'
read -n 1 -r -s -p $'Press enter to continue\n'

# Rerun the query
if bq query --nouse_legacy_sql \
' SELECT
     w1mpro_ep,
     mjd,
     load_id,
     frame_id
 FROM
     `bigquery-public-data.wise_all_sky_data_release.mep_wise`
 ORDER BY
     mjd ASC
 LIMIT 500'
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Query Ran: Checkpoint Completed (1/1)'
  sleep 2.5

  printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
fi

gcloud auth revoke --all
