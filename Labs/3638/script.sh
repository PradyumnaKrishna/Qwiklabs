#! /bin/bash

# Initialization
gcloud init < a

# Create a new dataset
if bq mk ecommerce
then
  printf "\n\e[1;96m%s\n\n\e[m" 'Dataset Created: Checkpoint Completed (1/4)'
  sleep 2.5

  # Identify a key field in your ecommerce dataset
  if (bq query --nouse_legacy_sql \
'SELECT
  productSKU,
  COUNT(DISTINCT v2ProductName) AS product_count,
  STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
FROM `data-to-insights.ecommerce.all_sessions_raw`
  WHERE v2ProductName IS NOT NULL
  GROUP BY productSKU
  HAVING product_count > 1
  ORDER BY product_count DESC')
  then
    printf "\n\e[1;96m%s\n\n\e[m" 'Key Field Identified: Checkpoint Completed (2/4)'
    sleep 2.5

    # Pitfall: non-unique key
    if (bq query --nouse_legacy_sql \
"WITH inventory_per_sku AS (
  SELECT DISTINCT
    website.v2ProductName,
    website.productSKU,
    inventory.stockLevel
  FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
  JOIN \`data-to-insights.ecommerce.products\` AS inventory
    ON website.productSKU = inventory.SKU
    WHERE productSKU = 'GGOEGPJC019099'
)

SELECT
  productSKU,
  SUM(stockLevel) AS total_inventory
FROM inventory_per_sku
GROUP BY productSKU")
    then
      printf "\n\e[1;96m%s\n\n\e[m" 'non-unique key: Checkpoint Completed (3/4)'
      sleep 2.5

      # Join pitfall solution
      if (bq query --nouse_legacy_sql \
'CREATE OR REPLACE TABLE ecommerce.site_wide_promotion AS
SELECT .05 AS discount;'

          bq query --nouse_legacy_sql \
"SELECT DISTINCT
productSKU,
v2ProductCategory,
discount
FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
CROSS JOIN ecommerce.site_wide_promotion
WHERE v2ProductCategory LIKE '%Clearance%'
AND productSKU = 'GGOEGOLC013299'")
      then
        printf "\n\e[1;96m%s\n\n\e[m" 'Pitfall Solution Joined: Checkpoint Completed (4/4)'
        sleep 2.5

        printf "\n\e[1;92m%s\n\n\e[m" 'Lab Completed'
      fi
    fi
  fi
fi

gcloud auth revoke --all