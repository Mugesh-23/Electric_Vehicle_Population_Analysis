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
