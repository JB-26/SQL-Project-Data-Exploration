SELECT cd.location,
       cd.date,
       cd.total_cases,
       cd.new_cases,
       cd.total_deaths,
       cd.population
FROM covid_deaths cd
ORDER BY 1,
         2;


SELECT *
FROM covid_deaths
LIMIT 50;


SELECT *
FROM covid_vaccinations
LIMIT 50;

-- looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country

SELECT cd.location,
       cd.date,
       cd.total_cases,
       cd.total_deaths,
       (cd.total_deaths/cd.total_cases)*100 AS death_percentage
FROM covid_deaths cd
WHERE cd.location like '%States'
    AND cd.continent IS NOT NULL
ORDER BY 1,
         2;

-- Looking at total cases vs population
-- shows percentage of population that caught covid

SELECT cd.location,
       cd.date,
       cd.total_cases,
       cd.population,
       (cd.total_cases/cd.population)*100 AS InfectionPercentage
FROM covid_deaths cd
WHERE cd.location like '%States'
    AND cd.continent IS NOT NULL
ORDER BY 1,
         2;

-- Looking at countries with highest infection rate compared to population

SELECT cd.location,
       cd.population,
       MAX(cd.total_cases) AS HighestInfectionCount,
       MAX((cd.total_cases/cd.population))*100 AS PercentPopulationInfected
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.population,
         cd.location
ORDER BY PercentPopulationInfected DESC;

-- showing countries with highest death count per population

SELECT cd.location,
       MAX(cd.total_deaths) AS TotalDeathCount
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.location
ORDER BY TotalDeathCount DESC;

-- breaking things down by continent

SELECT cd.continent,
       MAX(cd.total_deaths) AS TotalDeathCount
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.continent
ORDER BY TotalDeathCount DESC;


SELECT cd.location,
       MAX(cd.total_deaths) AS TotalDeathCount
FROM covid_deaths cd
WHERE cd.continent IS NULL
GROUP BY cd.location
ORDER BY TotalDeathCount DESC;

-- showing continents with highest death count per population

SELECT cd.continent,
       MAX(cd.total_deaths) AS TotalDeathCount
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.continent
ORDER BY TotalDeathCount DESC;

-- global numbers
-- handling dividing by zero

SELECT cd.date,
       SUM(cd.new_cases) AS total_cases,
       SUM(cd.new_deaths) AS total_deaths,
       CASE
           WHEN SUM(cd.new_cases) = 0 THEN NULL
           ELSE SUM(cd.new_deaths)/SUM(cd.new_cases)*100
       END AS death_percentage
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
    AND cd.new_cases IS NOT NULL
GROUP BY cd.date
ORDER BY 1,
         2;

-- total population versus vaccinations
 -- Use Common Table Expression
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
    (SELECT cd.continent,
            cd.location,
            cd.date,
            cd.population,
            cv.new_vaccinations,
            SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location
                                           ORDER BY cd.location,
                                                    cd.date) as RollingPeopleVaccinated
     FROM covid_deaths cd
     JOIN covid_vaccinations cv ON cd.location = cv.location
     AND cd.date = cv.date
     WHERE cd.continent IS NOT NULL
         AND cv.new_vaccinations IS NOT NULL)
SELECT *
FROM PopVsVac;


-- handling for divsion by zero

SELECT cd.continent,
       cd.location,
       cd.date,
       cd.population,
       cv.new_vaccinations,
       CASE
           WHEN cd.population = 0 THEN NULL
           WHEN cv.new_vaccinations = 0 THEN NULL
           ELSE (cv.new_vaccinations/cd.population)*100
       END as PercentageVaccinated
FROM covid_deaths cd
JOIN covid_vaccinations cv ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
    AND cv.new_vaccinations IS NOT NULL
ORDER BY 1,
         2,
         3;

-- create a view

CREATE VIEW country_infection_rate AS
SELECT cd.location,
       cd.population,
       MAX(cd.total_cases) AS HighestInfectionCount,
       MAX((cd.total_cases/cd.population))*100 AS PercentPopulationInfected
FROM covid_deaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.population,
         cd.location
ORDER BY PercentPopulationInfected DESC;

SELECT *
FROM country_infection_rate;

-- add more views later