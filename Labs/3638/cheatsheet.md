# **To be execute in Cloud Shell only**

**1. Create a new dataset**

    bq mk ecommerce

**2. Identify a key field in your ecommerce dataset**

    bq query --nouse_legacy_sql \
    'SELECT
      productSKU,
      COUNT(DISTINCT v2ProductName) AS product_count,
      STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
    FROM `data-to-insights.ecommerce.all_sessions_raw`
      WHERE v2ProductName IS NOT NULL
      GROUP BY productSKU
      HAVING product_count > 1
      ORDER BY product_count DESC'

**3. Pitfall: non-unique key**

    bq query --nouse_legacy_sql \
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
    GROUP BY productSKU"

**4. Join pitfall solution**

    bq query --nouse_legacy_sql \
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
    AND productSKU = 'GGOEGOLC013299'"

# **To be run on Bigquery Console only**

**2. Identify a key field in your ecommerce dataset**

    SELECT
      productSKU,
      COUNT(DISTINCT v2ProductName) AS product_count,
      STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
    FROM `data-to-insights.ecommerce.all_sessions_raw`
      WHERE v2ProductName IS NOT NULL
      GROUP BY productSKU
      HAVING product_count > 1
      ORDER BY product_count DESC

**3. Pitfall: non-unique key**

    WITH inventory_per_sku AS (
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
    GROUP BY productSKU

**4. Join pitfall solution**

    CREATE OR REPLACE TABLE ecommerce.site_wide_promotion AS
    SELECT .05 AS discount;

    SELECT DISTINCT
    productSKU,
    v2ProductCategory,
    discount
    FROM \`data-to-insights.ecommerce.all_sessions_raw\` AS website
    CROSS JOIN ecommerce.site_wide_promotion
    WHERE v2ProductCategory LIKE '%Clearance%'
    AND productSKU = 'GGOEGOLC013299'