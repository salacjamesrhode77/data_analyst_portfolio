import os
import pandas as pd
from flask import Flask, request, jsonify

def create_api_app():
    app = Flask(__name__)

    # Load CSVs
    customer_csv = "/opt/airflow/data/fake_customers.csv"
    product_csv = "/opt/airflow/data/fake_products.csv"

    customer_df = pd.read_csv(customer_csv)
    product_df = pd.read_csv(product_csv)

    @app.route("/api/customers", methods=["GET"])
    def get_all_customers():
        return jsonify(customer_df.to_dict(orient="records")), 200

    @app.route("/api/customers/<customer_name>", methods=["GET"])
    def get_customer(customer_name):
        data = customer_df[customer_df['Full Name'] == customer_name]
        if data.empty:
            return jsonify({"error": "Customer not found"}), 404
        return jsonify(data.to_dict(orient="records")[0]), 200

    @app.route("/api/products", methods=["GET"])
    def get_all_products():
        page = int(request.args.get('page', 1))
        limit = int(request.args.get('limit', 50))
        if limit > 50:
            return jsonify({"error": "Maximum limit is 50"}), 400

        start = (page - 1) * limit
        end = start + limit
        return jsonify(product_df.iloc[start:end].to_dict(orient="records")), 200

    @app.route("/api/products/<product_sku>", methods=["GET"])
    def get_product(product_sku):
        data = product_df[product_df['Product SKU'] == product_sku]
        if data.empty:
            return jsonify({"error": "Product not found"}), 404
        return jsonify(data.to_dict(orient="records")[0]), 200

    return app

if __name__ == "__main__":
    app = create_api_app()
    app.run(host="0.0.0.0", port=5000, debug=True)
