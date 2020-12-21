# **To be execute in Cloud Shell only**

**1. Find the total number of customers went through checkout**

    bq query --nouse_legacy_sql \
    'SELECT
    COUNT(DISTINCT fullVisitorId) AS visitor_count
    , hits_page_pageTitle
    FROM `data-to-insights.ecommerce.rev_transactions`
    GROUP BY hits_page_pageTitle'

    bq query --nouse_legacy_sql \
    'SELECT
    COUNT(DISTINCT fullVisitorId) AS visitor_count
    , hits_page_pageTitle
    FROM `data-to-insights.ecommerce.rev_transactions`
    WHERE hits_page_pageTitle = "Checkout Confirmation"
    GROUP BY hits_page_pageTitle'

**2. List the cities with the most transactions with your ecommerce site**

    bq query --nouse_legacy_sql \
    'SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS totals_transactions,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city'

    bq query --nouse_legacy_sql \
    'SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS totals_transactions,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    ORDER BY distinct_visitors DESC'

    bq query --nouse_legacy_sql \
    'SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS total_products_ordered,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
    SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    ORDER BY avg_products_ordered DESC'

    bq query --nouse_legacy_sql \
    'SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS total_products_ordered,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
    SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    HAVING avg_products_ordered > 20
    ORDER BY avg_products_ordered DESC'

**3. Find the total number of products in each product category**

    bq query --nouse_legacy_sql \
    'SELECT
    COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
    hits_product_v2ProductCategory
    FROM `data-to-insights.ecommerce.rev_transactions`
    WHERE hits_product_v2ProductName IS NOT NULL
    GROUP BY hits_product_v2ProductCategory
    ORDER BY number_of_products DESC
    LIMIT 5'

# **To be run on Bigquery Console only**

**1. Find the total number of customers went through checkout**

    SELECT
    COUNT(DISTINCT fullVisitorId) AS visitor_count
    , hits_page_pageTitle
    FROM `data-to-insights.ecommerce.rev_transactions`
    GROUP BY hits_page_pageTitle

    SELECT
    COUNT(DISTINCT fullVisitorId) AS visitor_count
    , hits_page_pageTitle
    FROM `data-to-insights.ecommerce.rev_transactions`
    WHERE hits_page_pageTitle = "Checkout Confirmation"
    GROUP BY hits_page_pageTitle

**2. List the cities with the most transactions with your ecommerce site**

    SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS totals_transactions,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city

    SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS totals_transactions,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    ORDER BY distinct_visitors DESC

    SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS total_products_ordered,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
    SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    ORDER BY avg_products_ordered DESC

    SELECT
    geoNetwork_city,
    SUM(totals_transactions) AS total_products_ordered,
    COUNT( DISTINCT fullVisitorId) AS distinct_visitors,
    SUM(totals_transactions) / COUNT( DISTINCT fullVisitorId) AS avg_products_ordered
    FROM
    `data-to-insights.ecommerce.rev_transactions`
    GROUP BY geoNetwork_city
    HAVING avg_products_ordered > 20
    ORDER BY avg_products_ordered DESC

**3. Find the total number of products in each product category**

    SELECT
    COUNT(DISTINCT hits_product_v2ProductName) as number_of_products,
    hits_product_v2ProductCategory
    FROM `data-to-insights.ecommerce.rev_transactions`
    WHERE hits_product_v2ProductName IS NOT NULL
    GROUP BY hits_product_v2ProductCategory
    ORDER BY number_of_products DESC
    LIMIT 5