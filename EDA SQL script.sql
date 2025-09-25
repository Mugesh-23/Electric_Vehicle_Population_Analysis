SELECT * FROM EVPopulation_data;
SELECT model,COUNT(*) FROM EVPopulation_data
GROUP BY model;

--1, How many total records (vehicles) are in the dataset?
SELECT COUNT(*) as total_count FROM EVPopulation_data;


--2,List all unique vehicle makes in the dataset.
SELECT DISTINCT(make) from  EVPopulation_data
Group by make;

--3, Count of vehicles by make
SELECT Make, COUNT(*) AS total
FROM EVPopulation_data
GROUP BY Make
ORDER BY total DESC;


--4, How many vehicles belong to the year 2023?

SELECT 
   model_year as Year,
   count(*) as Vehicle_count
FROM EVPopulation_data
WHERE model_year = 2023
GROUP BY model_year;

--5, Count how many vehicles are Battery Electric Vehicles (BEV) vs Plug-in Hybrid Electric Vehicles (PHEV).

SELECT 
    ev_type,
	count(*) as Ev_Type 
from EVPopulation_data
GROUP BY ev_type;

-- 6,Find the minimum and maximum model year in the dataset.

SELECT 
       MAX(model_year) as max_year,
       MIN(model_year) as Min_year 
from EVPopulation_data;


--7,Find the average electric range for each make.


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

-- 8,Which utility provider serves the highest number of EVs?

SELECT 
       electric_utility,
	   count(*) as total_vehicles
from EVPopulation_data
GROUP BY electric_utility
ORDER BY Utility_count desc
LIMIT 1

-- 9,Get the number of vehicles eligible vs not eligible for CAFV incentives.
SELECT 
     cafv_eligibility,
	 COUNT(*)
FROM EVPopulation_data
WHERE cafv_eligibility IN ('Eligible','Not Eligible')
GROUP BY cafv_eligibility;

SELECT
     distinct(make),
	 cafv_eligibility,
	 count(*) as vehicles_count
FROM EVPopulation_data
GROUP BY 
      make, 
	  cafv_eligibility

-- 10,Find the top 3 cities with the most electric vehicles.


SELECT 
    city,
	count(*) as vehicle_count
FROM EVPopulation_data
GROUP BY city
order by vehicle_count desc
limit 3

-- 11,For each model year, count how many vehicles are eligible for CAFV incentives.

SELECT model_year,count(*) as cafv_eligibil
FROM EVPopulation_data
WHERE cafv_eligibility in ('Eligible')
GROUP BY model_year

-- 12,Find the top 5 vehicle models with the highest average electric range.

SELECT 
     make,
     model, 
	 ROUND(AVG(electric_range),2) AS electric_range
FROM EVPopulation_data
GROUP BY make,model
ORDER BY electric_range desc
LIMIT 5;

-- Compare CAFV eligibility status across BEVs vs PHEVs (e.g., % eligible).

SELECT 
    cafv_eligibility, 
	ev_type,
	count(*)as total_count,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY ev_type), 2) AS percentage
FROM EVPopulation_data
GROUP BY cafv_eligibility,ev_type

-- Calculate the average MSRP per make, but only include vehicles with non-zero MSRP.


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


-- Top 3 makes in the district with most EVs
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


-- Get the trend of average electric range over years (group by Model Year).

SELECT 
    model_year,
    ROUND(AVG(electric_range), 2) AS avg_electric_range,
    COUNT(*) AS total_vehicles
FROM EVPopulation_data
WHERE electric_range IS NOT NULL
GROUP BY model_year
ORDER BY model_year;




















