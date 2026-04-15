-- Δημιουργία πίνακα με καθαρά δεδομένα
CREATE TABLE retail_cleaned AS
SELECT CustomerID,
       InvoiceDate,
       Quantity,
       UnitPrice,
       -- Εδώ "καθαρίζουμε" την ημερομηνία για να κρατήσουμε μόνο τον Μήνα και το Έτος

       InvoiceDate as RawDate
FROM online_retail
WHERE CustomerID IS NOT NULL
  AND Quantity > 0;