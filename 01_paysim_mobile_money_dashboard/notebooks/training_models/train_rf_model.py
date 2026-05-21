import pandas as pd
import joblib

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import RandomizedSearchCV
from sklearn.metrics import make_scorer, recall_score
from scipy.stats import randint
from google.cloud import storage


# LOAD DATA FROM GCS
X = pd.read_csv("gs://paysim_mobile_money/training_dataset/X_train.csv")
y = pd.read_csv("gs://paysim_mobile_money/training_dataset/y_train.csv")

y = y.values.ravel()

scoring = make_scorer(recall_score, pos_label=1)

# BASE MODEL
rf = RandomForestClassifier(
    random_state=2023,
    n_jobs=-1
)


# HYPERPARAMETER SPACE
params = {
    "n_estimators": [200, 300, 400],
    "max_depth": [10, 15, 20, 25, None],
    "min_samples_split": [10, 20, 30, 40],
    "min_samples_leaf": [5, 10, 15, 20],
    "max_features": ["sqrt", 0.3, 0.5],
    "bootstrap": [True],
    "class_weight": ["balanced", {0: 1, 1: 5}, {0: 1, 1: 8}, {0: 1, 1: 10}]
}



# RANDOMIZED SEARCH
search = RandomizedSearchCV(
    estimator=rf,
    param_distributions=params,
    n_iter=15,
    scoring=scoring,
    cv=3,
    verbose=2,
    random_state=2023,
    n_jobs=-1
)

search.fit(X, y)


# SAVE BEST MODEL TO GCS
joblib.dump(search.best_estimator_, "/tmp/random_forest_fraud_model.pkl")

bucket_name = "paysim_mobile_money"
destination_blob = "models/random_forest_fraud_model.pkl"

client = storage.Client()
bucket = client.bucket(bucket_name)
blob = bucket.blob(destination_blob)

blob.upload_from_filename("/tmp/random_forest_fraud_model.pkl")