-- Βρίσκουμε τον πρώτο μήνα αγοράς για κάθε πελάτη (Cohort Month)
SELECT CustomerID,
       InvoiceDate,
       -- Εδώ βρίσκουμε την ημερομηνία της 1ης αγοράς για τον πελάτη
       MIN(InvoiceDate) OVER (PARTITION BY CustomerID) as CohortDate
FROM retail_cleaned;

SELECT CustomerID, MIN(InvoiceDate)
FROM retail_cleaned
GROUP BY CustomerID;

WITH base AS (SELECT CustomerID,
                     -- Φτιάχνουμε την ημερομηνία σε σωστή μορφή YYYY-MM-DD
                     CASE
                         WHEN instr(InvoiceDate, ' ') > 0 THEN substr(InvoiceDate, 1, instr(InvoiceDate, ' ') - 1)
                         ELSE InvoiceDate
                         END as short_date,
                     InvoiceDate
              FROM retail_cleaned),
     formatted_dates AS (SELECT CustomerID,
                                -- Μετατρέπουμε το M/D/YYYY σε YYYY-MM-DD
                                substr(short_date, -4) || '-' ||
                                printf('%02d', CASE
                                                   WHEN instr(short_date, '/') = 2 THEN substr(short_date, 1, 1)
                                                   ELSE substr(short_date, 1, 2)
                                    END) || '-' ||
                                printf('%02d', replace(
                                        replace(substr(short_date, instr(short_date, '/') + 1), substr(short_date, -5),
                                                ''), '/', '')) as clean_date
                         FROM base),
     cohort_logic AS (SELECT CustomerID,
                             clean_date,
                             MIN(clean_date) OVER (PARTITION BY CustomerID) as first_purchase
                      FROM formatted_dates)
SELECT
    -- Παίρνουμε το Έτος και το Μήνα από την καθαρή ημερομηνία
    substr(first_purchase, 1, 7)                              as cohort_month,
    -- Υπολογίζουμε τον Index χωρίς να χρησιμοποιήσουμε strftime που βγάζει NULL
    (substr(clean_date, 1, 4) - substr(first_purchase, 1, 4)) * 12 +
    (substr(clean_date, 6, 2) - substr(first_purchase, 6, 2)) as cohort_index,
    COUNT(DISTINCT CustomerID)                                as active_customers
FROM cohort_logic
GROUP BY cohort_month, cohort_index
ORDER BY cohort_month, cohort_index;
