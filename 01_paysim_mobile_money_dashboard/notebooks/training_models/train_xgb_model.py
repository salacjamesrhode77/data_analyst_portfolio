import pandas as pd
import joblib

from xgboost import XGBClassifier
from sklearn.model_selection import RandomizedSearchCV
from sklearn.metrics import make_scorer, recall_score
from google.cloud import storage


# LOAD DATA FROM GCS
X = pd.read_csv("gs://paysim_mobile_money/training_dataset/X_train.csv")
y = pd.read_csv("gs://paysim_mobile_money/training_dataset/y_train.csv")

y = y.values.ravel()


scoring = make_scorer(recall_score, pos_label=1)


# BASE MODEL
xgb = XGBClassifier(
    objective="binary:logistic",
    eval_metric="aucpr",
    random_state=2023,
    n_jobs=-1,
    tree_method="hist"
)


# HYPERPARAMETER SPACE
params = {
    "n_estimators": [200, 300, 400],
    "max_depth": [4, 6, 8],
    "learning_rate": [0.05, 0.1],
    "subsample": [0.7, 0.85, 1.0],
    "colsample_bytree": [0.7, 0.85, 1.0],
    "min_child_weight": [1, 5, 10],
    "gamma": [0, 0.1, 0.3],
    "scale_pos_weight": [1, 2, 5, 10]
}


# RANDOMIZED SEARCH
search = RandomizedSearchCV(
    estimator=xgb,
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
best_model = search.best_estimator_

best_model.save_model("/tmp/xgboost_fraud_model.json")

bucket_name = "paysim_mobile_money"
destination_blob = "models/xgboost_fraud_model.json"

client = storage.Client()
bucket = client.bucket(bucket_name)
blob = bucket.blob(destination_blob)

blob.upload_from_filename("/tmp/xgboost_fraud_model.json")