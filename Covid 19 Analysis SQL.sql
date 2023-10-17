--Q1: How many row entries does the covid_deaths table has?
SELECT COUNT (*) FROM covid_deaths

--Q2: How many row entries does the covid_vaccination table has?
SELECT COUNT (*) FROM covid_vaccination

--Q3: Viewing some important columns in the covid_deaths dataset
SELECT date, continent, location, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY location, date;

--Q4: Checking for duplicate values in the covid_deaths table
SELECT date, continent, location,COUNT(*)
FROM covid_deaths
GROUP BY date, continent, location
HAVING COUNT(*)>1;


--Q5: Checking for any duplicate values in the covid_vaccination table
SELECT date, continent, location,COUNT(*)
FROM covid_vaccination
GROUP BY date, continent, location
HAVING COUNT(*)>1;

--Q6: What is the number of continents and countries in the covid_deaths dataset?
SELECT COALESCE(continent, 'Total') as Continent,
COUNT(continent) AS Count
FROM(SELECT DISTINCT continent
FROM covid_deaths) AS Subquery
GROUP BY continent with rollup
ORDER BY continent
--The covid_deaths dataset has 6 continents and the 1 field that is counted as "continent" is due to empty values.

--Q7: What is the count of countries in the location column of covid_deaths dataset?
SELECT COUNT(location) AS Countries_Count
FROM(SELECT DISTINCT location
FROM covid_deaths) AS Subquery;

--Q8: What is the average number of deaths by day (Continents & Countries)?
SELECT location,ROUND(AVG(CAST(new_deaths AS FLOAT)),2) AS Average_Deaths
FROM covid_deaths
GROUP BY location
ORDER BY Average_Deaths DESC;
/*Usa, Brazil and India are the top 3 countries in the number of deaths.
But this information is not sufficient to conclude if they are also the higher percentage of deaths versus population.*/

--Q9: Countries with the highest number of deaths
SELECT location,MAX(total_deaths) AS Max_of_Deaths
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Max_of_Deaths DESC;

--Q10: Continents with the highest number of deaths
SELECT continent,MAX(total_deaths) AS Highest_Deaths
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY Highest_Deaths DESC;

--Q11: What is the number of newly vaccinated and rolling average of newly vaccinated over time by country in the 'Asia' continent?
SELECT covid_deaths.continent, covid_deaths.location, covid_deaths.date, covid_vaccination.new_vaccinations,
AVG(CONVERT(FLOAT,covid_vaccination.new_vaccinations)) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.date) AS Rolling_Avg_Vaccines
FROM covid_deaths
JOIN covid_vaccination 
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent = 'Asia'
ORDER BY location, date;

/*Q12: What is the ratio of total cases to total deaths for each country in the scenario of COVID-19? 
Show top 10 countries that have least total deaths according to total number of cases. */
SELECT location, MAX(total_deaths) AS Total_Deaths,MAX(total_cases) AS Total_Cases,ROUND(MAX(total_cases)/NULLIF(MAX(total_deaths),0),2) AS Ratio_Cases_to_Deaths 
FROM covid_deaths
GROUP BY location
ORDER BY Ratio_Cases_to_Deaths DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;
--Here, NULLIF() function is used in the SELECT statement to fix the error "Divide by zero error encountered"

-- END OF THE PROJECT


