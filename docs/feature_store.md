# CommerceAI Feature Store Documentation

## Overview

The CommerceAI Feature Store is the central repository of engineered features used by analytics, machine learning, recommendation systems, customer intelligence services, and GenAI agents.

The feature store is built from the Instacart dataset and follows a layered architecture:

```text
Raw Layer
    ↓
Staging Layer
    ↓
Feature Store
    ↓
Analytics & ML Services
```

---

# Data Architecture

```text
raw
│
├── orders
├── products
├── aisles
├── departments
└── order_products_prior

        ↓

staging

└── order_items

        ↓

features

├── customer_features
├── order_level
├── product_features
├── user_product_features
├── department_features
└── aisle_features

        ↓

analytics

└── feature_registry
```

---

# Feature Store Entities

## 1. Customer Features

### Table

```text
features.customer_features
```

### Grain

```text
One row per customer
```

### Row Count

```text
206,209
```

### Purpose

Customer Intelligence Service

Customer Segmentation

Churn Prediction

Customer Copilot

Recommendation Personalization

### Features

```text
user_id

total_orders

total_items

unique_products

avg_basket_size

avg_days_between_orders

std_days_between_orders

customer_tenure

reorder_rate

total_reorders

unique_departments

unique_aisles

favorite_hour

favorite_day
```

### Business Value

Identifies:

* Loyal customers
* High value customers
* Frequent shoppers
* Product explorers
* At-risk customers

---

## 2. Order Level Features

### Table

```text
features.order_level
```

### Grain

```text
One row per order
```

### Row Count

```text
3,214,874
```

### Purpose

Order Analytics

Demand Forecasting

Basket Analysis

Customer Frequency Modeling

### Features

```text
order_id

user_id

order_number

order_dow

order_hour_of_day

days_since_prior_order

basket_size

unique_products

unique_departments

unique_aisles

reorder_count

reorder_ratio
```

### Business Value

Provides order-level behavioral insights and serves as an intermediate layer for downstream feature engineering.

---

## 3. Product Features

### Table

```text
features.product_features
```

### Grain

```text
One row per product
```

### Row Count

```text
49,677
```

### Purpose

Product Intelligence Service

Recommendation Engine

Product Popularity Analysis

Demand Forecasting

### Features

```text
product_id

product_name

department

aisle

purchase_count

unique_customers

unique_orders

reorder_rate

total_reorders

avg_cart_position

std_cart_position

avg_purchase_hour
```

### Business Value

Identifies:

* Popular products
* Frequently reordered products
* High demand products
* Customer favorites

---

## 4. User Product Features

### Table

```text
features.user_product_features
```

### Grain

```text
One row per user-product pair
```

### Row Count

```text
13,307,953
```

### Purpose

Recommendation Engine

Customer Copilot

Next Product Prediction

Affinity Modeling

### Features

```text
user_id

product_id

purchase_count

reorder_count

reorder_rate

first_order

last_order

purchase_span

avg_cart_position

unique_orders
```

### Business Value

This is the most valuable feature table in the platform.

It captures customer-product affinity and forms the foundation for personalized recommendations.

---

## 5. Department Features

### Table

```text
features.department_features
```

### Grain

```text
One row per department
```

### Row Count

```text
21
```

### Purpose

Category Analytics

Business Intelligence

Customer Preference Analysis

### Features

```text
department

purchase_count

unique_customers

unique_products

reorder_rate
```

### Business Value

Provides department-level purchasing behavior and category trends.

---

## 6. Aisle Features

### Table

```text
features.aisle_features
```

### Grain

```text
One row per aisle
```

### Row Count

```text
134
```

### Purpose

Fine-Grained Category Analytics

Product Intelligence

Recommendation Insights

### Features

```text
aisle

purchase_count

unique_customers

unique_products

reorder_rate
```

### Business Value

Provides aisle-level purchasing behavior and customer preferences.

---

# Feature Registry

### Table

```text
analytics.feature_registry
```

### Purpose

Central metadata catalog for all feature tables.

### Metadata Stored

```text
entity_name

feature_table

row_count

grain

description

created_at
```

### Benefits

* Data discovery
* Governance
* Documentation
* Monitoring
* Future Feature Store Integration

---

# Current Platform Status

## Completed

```text
Raw Data Layer
Staging Layer
Feature Engineering
Feature Store
Feature Registry
Feature Validation
Customer Feature Analysis
```

## Upcoming

```text
Customer Intelligence Service
Product Intelligence Service
Recommendation Engine
Churn Prediction
Demand Forecasting
MLflow Integration
FastAPI Services
Docker Deployment
Airflow Orchestration
GenAI Business Insight Agent
```

---

# Summary

The CommerceAI Feature Store provides a production-style foundation for machine learning, analytics, recommendation systems, and GenAI applications.

Current Feature Store Assets:

```text
Customer Features       : 206,209 rows
Order Features          : 3,214,874 rows
Product Features        : 49,677 rows
User Product Features   : 13,307,953 rows
Department Features     : 21 rows
Aisle Features          : 134 rows
```

This feature store serves as the core data platform for all future CommerceAI services.
