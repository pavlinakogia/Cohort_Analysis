WITH base AS (
    SELECT CustomerID,
           TRIM(CASE WHEN instr(InvoiceDate, ' ') > 0 THEN substr(InvoiceDate, 1, instr(InvoiceDate, ' ') - 1) ELSE InvoiceDate END) as d
    FROM retail_cleaned
),
parsed AS (
    SELECT CustomerID,
           -- Μήνας: Όλα πριν την 1η κάθετο
           printf('%02d', CAST(substr(d, 1, instr(d, '/') - 1) AS INT)) as M,
           -- Το υπόλοιπο της ημερομηνίας μετά την 1η κάθετο
           substr(d, instr(d, '/') + 1) as rest,
           d
    FROM base
),
parsed_v2 AS (
    SELECT CustomerID, M,
           -- Μέρα: Από την αρχή του 'rest' μέχρι την επόμενη κάθετο
           printf('%02d', CAST(substr(rest, 1, instr(rest, '/') - 1) AS INT)) as D,
           -- Έτος: Όλα μετά την κάθετο στο 'rest'
           substr(rest, instr(rest, '/') + 1) as Y
    FROM parsed
),
clean AS (
    SELECT CustomerID, (Y || '-' || M || '-' || D) as clean_date
    FROM parsed_v2
    WHERE length(Y) = 4
),
logic AS (
    SELECT CustomerID, clean_date,
           MIN(clean_date) OVER (PARTITION BY CustomerID) as first_m
    FROM clean
),
retention_counts AS (
    SELECT substr(first_m, 1, 7) as cohort_month,
           (substr(clean_date, 1, 4) - substr(first_m, 1, 4)) * 12 + (substr(clean_date, 6, 2) - substr(first_m, 6, 2)) as cohort_index,
           COUNT(DISTINCT CustomerID) as active_customers
    FROM logic
    GROUP BY 1, 2
)
SELECT
    cohort_month,
    cohort_index,
    active_customers,
    FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY cohort_index) as cohort_size,
    ROUND(active_customers * 100.0 / FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY cohort_index), 2) || '%' as retention_rate
FROM retention_counts
ORDER BY cohort_month, cohort_index;