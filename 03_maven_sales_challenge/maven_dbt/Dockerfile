# Base image with Python
FROM python:3.10-slim

# Set environment variables
ENV DBT_HOME=/usr/app/dbt
ENV PATH="$DBT_HOME:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR $DBT_HOME

# Install DBT and required modules
RUN pip install --no-cache-dir \
    dbt-core dbt-postgres boto3 pandas requests psycopg2

# Copy project files
COPY . $DBT_HOME

# Set entrypoint for DBT
ENTRYPOINT ["dbt"]