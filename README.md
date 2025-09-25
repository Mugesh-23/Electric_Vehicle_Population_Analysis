# Electric Vehicle Population Analysis

* Data_set -> https://drive.google.com/file/d/1742EmyM50VPfV3u8lhY2gsnaO1BgZm7F/view?usp=sharing
## 1. Project Introduction

- Dataset:Electric Vehicle Population
- Goal: Clean, explore, and analyze EV adoption trends (by make, model, year, eligibility, utility provider, etc.).
- Tool: PostgreSQL,Microsoft EXCEL

## 2. Data Cleaning Steps

- Remove duplicate VINs
- Replace 0 values in MSRP and Electric Range with NULL
- Standardize CAFV Eligibility categories (Eligible, Not Eligible, Unknown)
- Trim text fields (Make, Model, Utility)

## 3.  Database Setup

- **Database Creation**: Created a EV_Population Analysis
- **Table Creation**: Created tables for EVPopulation_data
```SQL
CREATE TABLE EVPopulation_data(
      VIN VARCHAR(20),
	  county VARCHAR(30),
	  city VARCHAR(40),
	  state	VARCHAR(10),
	  postal_code INT,
	  model_Year INT,
	  make	VARCHAR(30),
	  model VARCHAR(30),
	  ev_Type VARCHAR(60),
	  cafv_eligibility VARCHAR(30),
	  electric_range VARCHAR(10),
	  base_msrp VARCHAR(20),
	  legislative_district	VARCHAR(10),
	  dol_vehicle_id INT PRIMARY KEY,
	  vehicle_location	VARCHAR(50),
	  electric_Utility	VARCHAR(150),
	  census_tract VARCHAR(20)
    )
```
## 4. Exploratory Data Analysis (EDA)
1, How many total records (vehicles) are in the dataset?
```sql
SELECT 
    COUNT(*) as total_count 
FROM EVPopulation_data;
```
2,List all unique vehicle makes in the dataset.
```sql
SELECT 
     DISTINCT(make) from  EVPopulation_data
Group by make;
```
3, Count of vehicles by make
```sql
SELECT Make, COUNT(*) AS total
FROM EVPopulation_data
GROUP BY Make
ORDER BY total DESC;
```
4, How many vehicles belong to the year 2023?
```sql
SELECT 
   model_year as Year,
   count(*) as Vehicle_count
FROM EVPopulation_data
WHERE model_year = 2023
GROUP BY model_year;
```
5, Count how many vehicles are Battery Electric Vehicles (BEV) vs Plug-in Hybrid Electric Vehicles (PHEV).
```sql
SELECT 
    ev_type,
	count(*) as Ev_Type 
from EVPopulation_data
GROUP BY ev_type;
```
 6,Find the minimum and maximum model year in the dataset.
```sql
SELECT 
       MAX(model_year) as max_year,
       MIN(model_year) as Min_year 
from EVPopulation_data;
```
7,Find the average electric range for each make.

```sql
ALTER TABLE EVPopulation_data
ALTER COLUMN electric_range TYPE INT

UPDATE EVPopulation_data
SET electric_range = NULL
WHERE electric_range = 0;

SELECT 
      ROUND(AVG(electric_range),2) as avg_range,
	  make
from EVPopulation_data
GROUP BY make
ORDER BY avg_range desc;
```
8,Which utility provider serves the highest number of EVs?
```sql
SELECT 
       electric_utility,
	   count(*) as total_vehicles
from EVPopulation_data
GROUP BY electric_utility
ORDER BY Utility_count desc
LIMIT 1
```
9,Get the number of vehicles eligible vs not eligible for CAFV incentives.
```sql
SELECT
     distinct(make),
	 cafv_eligibility,
	 count(*) as vehicles_count
FROM EVPopulation_data
GROUP BY 
      make, 
	  cafv_eligibility
```
10,Find the top 3 cities with the most electric vehicles.
```sql
SELECT 
    city,
	count(*) as vehicle_count
FROM EVPopulation_data
GROUP BY city
order by vehicle_count desc
limit 3
```
11,For each model year, count how many vehicles are eligible for CAFV incentives.
```sql
SELECT model_year,count(*) as cafv_eligibil
FROM EVPopulation_data
WHERE cafv_eligibility in ('Eligible')
GROUP BY model_year
```
12,Find the top 5 vehicle models with the highest average electric range.
```sql
SELECT 
     make,
     model, 
	 ROUND(AVG(electric_range),2) AS electric_range
FROM EVPopulation_data
GROUP BY make,model
ORDER BY electric_range desc
LIMIT 5;
```
13,Compare CAFV eligibility status across BEVs vs PHEVs (e.g., % eligible).
```sql
SELECT 
    cafv_eligibility, 
	ev_type,
	count(*)as total_count,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY ev_type), 2) AS percentage
FROM EVPopulation_data
GROUP BY cafv_eligibility,ev_type
```
14,Calculate the average MSRP per make, but only include vehicles with non-zero MSRP.
```sql
UPDATE EVPopulation_data
SET base_msrp = NULL
WHERE base_msrp = 'NaN';

ALTER TABLE EVPopulation_data
ALTER COLUMN base_msrp TYPE INT
USING base_msrp::INT;

select  
       make,
       ROUND(avg(base_msrp),2) as avg_msrp
from EVPopulation_data
WHERE base_msrp IS NOT NULL AND base_msrp != 0
group by make
ORDER BY avg_msrp DESC;
```
15,Top 3 makes in the district with most EVs
```sql
WITH top_district AS (
    SELECT legislative_district
    FROM EVPopulation_data
    GROUP BY legislative_district
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT make, COUNT(*) AS vehicle_count
FROM EVPopulation_data
WHERE legislative_district = (SELECT legislative_district FROM top_district)
GROUP BY make
ORDER BY vehicle_count DESC
LIMIT 3;
```
16,Get the trend of average electric range over years (group by Model Year).
```sql
SELECT 
    model_year,
    ROUND(AVG(electric_range), 2) AS avg_electric_range,
    COUNT(*) AS total_vehicles
FROM EVPopulation_data
WHERE electric_range IS NOT NULL
GROUP BY model_year
ORDER BY model_year;
```
## 4. Insights / Findings

- Tesla has the highest number of EVs

- BEVs have much higher ranges than PHEVs

- Some utilities (like Puget Sound Energy) serve the majority of EVs

- Most CAFV ineligibility comes from low-range PHEVs

## 5. Conclusion

- Adoption is growing steadily after 2019

- CAFV incentives are strongly linked to electric range

- Utilities and districts show concentration of EV ownership

