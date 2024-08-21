USE covid_data;

SELECT * 
FROM world_covid_data;


-- see if there are any duplicates 
WITH covid_CTE AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY `Date_reported`, Country_code, Country, WHO_region, 
New_cases, Cumulative_cases, New_deaths, Cumulative_deaths) AS row_num
FROM world_covid_data
)
SELECT *
FROM covid_CTE
WHERE row_num >1; -- no duplicates after running this query, data is fairly clean


-- see if the format is what we wanted
SELECT
    `Date_reported`,
    STR_TO_DATE(`Date_reported`, '%Y-%m-%d')
FROM world_covid_data;

-- change the format 
UPDATE world_covid_data
SET `Date_reported` = STR_TO_DATE(`Date_reported`, '%Y-%m-%d');

-- now change the text format to the date format
ALTER TABLE world_covid_data
MODIFY COLUMN `Date_reported` DATE;

SELECT 
	Country,
    sum(New_cases) AS total_cases
FROM world_covid_data
GROUP BY 1
ORDER BY 2 DESC;

-- finding the total death, cases and death rate in each countries
SELECT 
    Country,
    SUM(New_deaths) AS total_deaths,
    SUM(New_cases) AS total_cases,
    SUM(New_deaths)/SUM(New_cases) AS death_rate
FROM world_covid_data
GROUP BY 1
ORDER BY 2 DESC;

-- finding the total deaths, total cases, death rate by year/month
SELECT 
    YEAR(Date_reported) AS report_year,
    MONTH(Date_reported) AS report_month,
    SUM(New_deaths) AS total_deaths,
    SUM(New_cases) AS total_cases,
    SUM(New_deaths)/SUM(New_cases) AS death_rate
FROM world_covid_data
GROUP BY YEAR(Date_reported), MONTH(Date_reported);

-- I wanted to find out the average percentage of death rate for covid
WITH covid_CTE AS( 
	SELECT 
    YEAR(Date_reported) AS report_year,
    MONTH(Date_reported) AS report_month,
    SUM(New_deaths) AS total_deaths,
    SUM(New_cases) AS total_cases,
    SUM(New_deaths)/SUM(New_cases) AS death_rate
FROM world_covid_data
GROUP BY YEAR(Date_reported), MONTH(Date_reported)
)
SELECT 
	AVG(death_rate) AS average_death_rate,
    SUM(total_deaths) AS total_deaths,
    SUM(total_cases) AS total_cases
FROM covid_CTE;

SELECT 
    Date_reported,
    SUM(New_deaths) AS total_deaths,
    SUM(New_cases) AS total_cases,
    SUM(New_deaths)/SUM(New_cases) AS death_rate
FROM world_covid_data
GROUP BY Date_reported;
