# **To be execute in Cloud Shell only**

**Update the quota first**
Update Quota from <https://console.cloud.google.com/iam-admin/quotas>

**1. Rerun the Query**

    bq query --nouse_legacy_sql \
    'SELECT
     job_id,
     creation_time,
     error_result
    FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
    WHERE creation_time > TIMESTAMP_SUB(CURRENT_TIMESTAMP, INTERVAL 1 DAY)'