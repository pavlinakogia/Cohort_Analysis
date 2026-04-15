import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# 1. Φόρτωση των δεδομένων
# Λέμε στην Python ότι το αρχείο ΔΕΝ έχει επικεφαλίδες (header=None)
# και της δίνουμε εμείς τα ονόματα (names=[...])
df = pd.read_csv('../data/cohort_retention.csv', header=None,
                 names=['cohort_month', 'cohort_index', 'active_customers', 'cohort_size', 'retention_rate'])

# 2. Μετατροπή των δεδομένων
# Αφαιρούμε το % και το μετατρέπουμε σε αριθμό
df['retention_rate'] = df['retention_rate'].str.replace('%', '').astype(float)

# Δημιουργία του Pivot πίνακα για το Heatmap
retention_matrix = df.pivot(index='cohort_month',
                            columns='cohort_index',
                            values='retention_rate')

# 3. Δημιουργία του Heatmap (Το οπτικό κομμάτι)
plt.figure(figsize=(14, 10))
plt.title('Customer Retention Rate (%) - Cohort Analysis', fontsize=16, pad=20)

sns.heatmap(retention_matrix,
            annot=True,    # Εμφάνιση των ποσοστών
            fmt='.1f',     # 1 δεκαδικό ψηφίο
            cmap='YlGnBu', # Χρώματα: Κίτρινο -> Πράσινο -> Μπλε
            linewidths=.5,
            cbar_kws={'label': 'Retention %'})

plt.xlabel('Months Since First Purchase', fontsize=12)
plt.ylabel('Cohort Month', fontsize=12)

# Αποθήκευση της εικόνας για το portfolio
plt.savefig('cohort_heatmap.png', bbox_inches='tight')
print("Το γράφημα δημιουργήθηκε και αποθηκεύτηκε ως 'cohort_heatmap.png'!")

plt.show()