## Project Overview

![Project Overview](https://raw.githubusercontent.com/salacjamesrhode77/portfolio_assets/refs/heads/main/images/airbnb_market_analysis/airbnb_thumbnail.png)

## Problem Statement

The increasing popularity of Airbnb has created a highly competitive environment for short-term rentals, making it difficult for hosts and investors to make decisions that maximize revenue and occupancy while ensuring guest satisfaction. Many listings are created based on assumptions rather than empirical evidence, resulting in suboptimal pricing, mismatched amenities, and poorly defined target markets.

This project aims to address these challenges by conducting a comprehensive data analysis and translating data insights into actionable strategies for both existing hosts and prospective investors planning to enter the short-term rental market. The goal is to identify patterns in customer behavior, accommodation preferences, and pricing distribution to support more informed decision-making.

Specifically, the analysis seeks to answer the following key questions:

- **Target Audience:** Which types of customers should be targeted? What are their behaviors and preferences?<br?>
- **Product Offering:** What types of accommodations and which amenities are essential for the product offering?<br?>
- **Pricing Strategy:** How can pricing be aligned with customer value perception? How much should be charged for premiums?


## The Dataset

The target location for this analysis is Siquijor Island, where tourism is rapidly growing alongside increasing demand for accommodations. However, due to the difficulty of retrieving data, as Airbnb strictly prohibits web scraping, an alternative data source was used.

Specifically, data from “Inside Airbnb,” an advocacy project that provides publicly available datasets on Airbnb listings, was utilized. For this analysis, the dataset for Bangkok was selected, as it is geographically close to the Philippines and shares comparable tourism and market characteristics.

While this approach provides a good proxy for understanding market behavior, the findings will be further refined through the manual collection and curation of listing data from Siquijor Island in subsequent phases of the project. This will enable a more localized and accurate assessment of the target market.


## Methodology / Approach

### Data Cleaning and Transformation

Tables were created in a PostgreSQL database, and listings and reviews data were copied from CSV files into the tables. The data was then transformed using SQL queries and dbt, moving from the staging layer to the intermediate layer and finally to the marts layer, where the data is already analysis-ready for exploratory data analysis in a Jupyter Notebook.


### Text Reviews Preprocessing

Additional preprocessing was performed on text reviews, as SQL transformations alone cannot identify non-English comments, remove custom stopwords, and lemmatize words. This process simplifies each review to its key terms, retaining only meaningful information for effective analysis.


### Customer Segmentation

To understand overall customer behavior from Airbnb listing reviews, the initial step is to identify broad customer groups using LDA (Latent Dirichlet Allocation), a machine learning algorithm that analyzes written reviews and identifies common topics without requiring predefined categories. This helps group similar feedback, such as comments about cleanliness, communication, or complaints.

The initial results revealed broad themes related to cleanliness and comfort, amenities and facilities, location and accessibility, and food and local experiences. Topics associated with these themes were retained for further analysis, while less relevant topics were excluded and added to the stopword list, along with some noisy terms from the selected topics. A second stage of LDA was then performed to identify the final topics.


## Target Audience: Which types of customers should be targeted, What are their behaviors and preferences?

| Customer Persona | Topic Basis | Who they are | Behaviors & Preferences |
|--------|------------|--------------|--------------------------|
| Home Comfort Seekers | Topic 0: clean, comfortable, pool, gym, spacious, view | Couples, families, short-term vacationers; tourists on relaxation trips; guests prioritizing comfort | Prefer clean, spacious, well-designed rooms; value amenities (pool, gym, view); spend more time indoors; expect hotel-like comfort; choose based on photos and comfort reviews |
| Local Transit Explorers | Topic 1: BTS, station, walk, restaurant, food, local | Solo travelers, backpackers, business travelers; short-stay or active explorers | Prefer walking access to BTS/MRT; prioritize food and local areas; spend more time outside; value convenience over luxury; choose based on accessibility and neighborhood vibrancy |


## Product Offering: What types of accommodations and which amenities are essential for the product offering?

Exploratory data analysis is conducted to understand the expressed preferences of the target customer segments. Specifically, this process identifies the most common features guests look for when booking an Airbnb, such as accommodation capacity, bedrooms, bathrooms, and amenities.

Based on the results, the following standardized product offering is recommended to serve both Home Comfort Seekers and Local Transit Explorers.

### Standard Listing Configuration

Property Type: Entire Place / Entire Condo / Entire Apartment 
Guest Capacity: 2 guests (up to 4 guests allowed upon request with an additional fee)  
Bedrooms: 1 bedroom  
Beds: 1 bed (additional bedding available upon request)  
Bathrooms: 1 full private bathroom  

### Core Amenities

**Comfort & Living Essentials**  
Air conditioning  
Hot water
Beddings
Wifi
TV

**Bathroom & Hygiene**  
Toiletries
Bathroooooom fixtures

**Kitchen & Dining**  
Kitchen
Refrigerator
Basic Cooking
Dining

**Kitchen & Dining**  
Kitchen
Refrigerator
Basic Cooking
Dining

**Laundry & Storage**  
Washer
Dryer 
Laundromat nearby
Storage

**Safety Features**  
Fire extinguisher
Smoke alarm
Carbon monoxide alarm

**Access & Convenience**  
Self check-in
Flexible Stays
Elevator
Parking Space


## Pricing Strategy: How can pricing be aligned with customer value perception? How much should be charged for premiums?

### Baseline Price

For the baseline price, the price distribution across target customer segments is analyzed to assess differences in willingness to pay between Home Comfort Seekers and Local Transit Explorers. Price points (median and mode) are examined to identify the most representative pricing level, which in this case is the modal price, as it reflects the highest concentration of demand and serves as the basis for determining an optimal base price that maximizes occupancy.


### Guest Surcharges

The property can comfortably accommodate 2 guests but allows up to 4 guests for an additional charge. To determine this charge, listings within each customer segment are grouped by the number of guests accommodated, and median prices are computed per segment to observe how prices change as guest capacity increases.

From this, the price increase per additional guest is estimated by analyzing the overall trend between lower-capacity and higher-capacity listings, with the slope of the trend line providing a practical estimate of the marginal price impact of each extra guest. This serves as the basis for the additional guest charge.


### Amenities Premiums

On top of the baseline price, which already includes commonly expected amenities, an additional premium is applied for extra amenities based on how much they increase listing prices relative to the baseline.

For each segment, listing prices are compared to the baseline to measure the effect of each amenity on overall price levels and identify which amenities are associated with higher prices.

A log-linear Ordinary Least Squares (OLS) regression model is then used within each segment to estimate the impact of multiple amenities on price, where listing prices (relative to the baseline) are modeled as a function of amenity variables. The resulting coefficients represent the marginal effect of each amenity on price.

These coefficients are converted into percentage price adjustments, which are used as the recommended premium added to the base price when a specific amenity is included.

Based on the results of the pricing strategies, these are the recommended base price and premiums for each target customer.

#### Home Comfort Seeker

Base Price Offer: 871 THB  
Premium per Extra Guest: 142 THB  

Recommended Price Percentage Adjustment for Premium Amenities:  
child friendly feature +16%  
pool +15%  
breakfast +11%  
ev support +9%  
exercise +5%  
sound system +4%  
housekeeping +4%  
luxury services +3%  
outdoor recreation +2%  


#### Local Transit Explorer

Base Price Offer: 828 THB  
Premium per Extra Guest: 99 THB  

Recommended Price Percentage Adjustment for Premium Amenities:  
pool +28%  
child friendly feature +20%  
ev support +10%  
sound system +9%  
breakfast +7%  
housekeeping +5%  
cleaning +2%  
pet friendly features +2%  
view +1% 