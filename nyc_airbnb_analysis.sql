-- Project Airbnb
CREATE DATABASE airbnb_project;
USE airbnb_project;
CREATE TABLE airbnb (
    id INT PRIMARY KEY,
    name TEXT,
    host_id INT,
    host_name VARCHAR(255),
    neighbourhood_group VARCHAR(100),
    neighbourhood VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    room_type VARCHAR(100),
    price INT,
    minimum_nights INT,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month FLOAT,
    calculated_host_listings_count INT,
    availability_365 INT
);
-- Clean working copy
CREATE TABLE airbnb_clean  
AS SELECT * FROM  airbnb;

-- Data Validation and cleaning diagnostics

-- Invalid values
SELECT price, minimum_nights FROM airbnb_clean WHERE price<=0 OR minimum_nights <=0;

-- Null values
SELECT SUM(CASE WHEN name is NULL THEN 1 ELSE 0 END) as name_null,
SUM(CASE WHEN host_name is NULL THEN 1 ELSE 0 END) AS hosts_null
FROM airbnb_clean;

-- Duplicate listings
SELECT COUNT(id) FROM airbnb_clean GROUP BY id HAVING COUNT(id)>1;

-- Listings not available for any day 
SELECT * FROM airbnb_clean WHERE availability_365 = 0;

-- Exploratory Analysis

--  Top 5 most expensive listings in Manhattan
SELECT name, host_name,neighbourhood,price FROM airbnb_clean WHERE availability_365>0  AND neighbourhood_group = 'Manhattan' ORDER BY price DESC LIMIT 5;

-- Average price by room type across all boroughs
SELECT room_type, ROUND(AVG(price),2) AS avg_price FROM airbnb_clean WHERE availability_365> 0 GROUP BY room_type ORDER BY avg_price DESC;

-- Top 10 hosts with most listings
SELECT host_name, COUNT(*) AS listings_count FROM airbnb_clean GROUP BY host_name ORDER BY listings_count DESC LIMIT 10; 

-- Most popular neighbourhoods by number of listings
SELECT neighbourhood, COUNT(*) AS total_listings FROM airbnb_clean GROUP BY neighbourhood ORDER BY total_listings DESC LIMIT 10;

-- Listings with 300 reviews and high availability
SELECT name, host_name, number_of_reviews, availability_365 FROM airbnb_clean WHERE number_of_reviews> 300 AND availability_365>200 ORDER BY number_of_reviews DESC;

-- Average availability per borough
SELECT neighbourhood_group, ROUND(AVG(availability_365),2) AS avg_availability FROM airbnb_clean GROUP BY neighbourhood_group ORDER BY avg_availability DESC;

-- Listings with extreme minimum nights requirements
SELECT name, host_name, neighbourhood_group, minimum_nights FROM airbnb_clean WHERE minimum_nights >100;

-- Borough wise total number of reviews
SELECT neighbourhood_group, SUM(number_of_reviews) AS total_reviews FROM airbnb_clean GROUP BY neighbourhood_group ORDER BY total_reviews DESC;

-- Top 5 most reviewed listings
SELECT name, host_name, neighbourhood_group, number_of_reviews FROM airbnb_clean ORDER BY number_of_reviews DESC LIMIT 10;

-- Listings with price between 100 and 150 dollars with high review score
SELECT name, host_name, neighbourhood, price, number_of_reviews FROM airbnb_clean WHERE price BETWEEN 100 AND 150 AND number_of_reviews>5 AND availability_365>0;

-- Listings with no reviews but high price
-- No listings found in this data set
SELECT name, host_name, price FROM airbnb_clean WHERE number_of_reviews = 0 AND price>200 AND availability_365 >0;

-- Listings with very high price and low availability
SELECT name, host_name, neighbourhood_group, price, availability_365 FROM airbnb_clean WHERE price > 300 AND availability_365<30 ORDER BY price DESC; 

-- Average reviews per month by room type (Excluding nulls)
SELECT room_type, ROUND(AVG(reviews_per_month), 2) AS average_reviews_month FROM airbnb_clean WHERE reviews_per_month IS NOT NULL GROUP BY room_type ORDER BY average_reviews_month DESC;