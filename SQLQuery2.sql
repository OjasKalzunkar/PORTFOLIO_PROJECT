SELECT * FROM dbo.COWID_DEATHS ORDER BY Location, date
SELECT * FROM dbo.COWID_VACCINATIONS ORDER BY Location, date

DROP TABLE PORTFOLIO_PROJECT.dbo.COWID_DEATHS
DROP TABLE PORTFOLIO_PROJECT.dbo.COWID_VACCINATIONS

SELECT LOCATION,DATE,TOTAL_CASES,NEW_CASES,TOTAL_DEATHS,POPULATION FROM dbo.COWID_DEATHS ORDER BY Location, date

SELECT LOCATION,DATE,TOTAL_CASES,TOTAL_DEATHS,((TOTAL_DEATHS/TOTAL_CASES) *100) AS PERCENTAGE_OF_DEATH 
FROM dbo.COWID_DEATHS WHERE LOCATION='India' ORDER BY PERCENTAGE_OF_DEATH 

SELECT TOTAL_CASES FROM PORTFOLIO_PROJECT.dbo.COWID_DEATHS
ALTER TABLE PORTFOLIO_PROJECT.dbo.COWID_DEATHS
ALTER COLUMN TOTAL_DEATHS FLOAT

SELECT LOCATION,POPULATION,SUM(TOTAL_CASES),SUM(TOTAL_DEATHS) FROM PORTFOLIO_PROJECT.dbo.COWID_DEATHS
GROUP BY LOCATION,POPULATION

SELECT LOCATION,POPULATION,MAX(TOTAL_CASES) AS Highes_TOTALCASES_COUNT,
MAX((TOTAL_CASES/POPULATION) * 100) AS TOTAL_PERCENT_INFECTED
FROM PORTFOLIO_PROJECT.dbo.COWID_DEATHS GROUP BY LOCATION,POPULATION
ORDER BY TOTAL_PERCENT_INFECTED DESC


SELECT LOCATION,MAX(TOTAL_DEATHS) AS Highes_DEATH_COUNT
FROM PORTFOLIO_PROJECT.dbo.COWID_DEATHS WHERE CONTINENT IS NULL
GROUP BY LOCATION
ORDER BY Highes_DEATH_COUNT DESC

SELECT CONTINENT,SUM(NEW_CASES), SUM(NEW_DEATHS),(SUM(NEW_DEATHS)/SUM(NEW_CASES))AS DEATH_PERCENTAGE
FROM dbo.COWID_DEATHS
WHERE CONTINENT IS NOT NULL AND CONTINENT='ASIA'
GROUP BY CONTINENT ORDER BY 2,3


SELECT SUM(NEW_CASES), SUM(NEW_DEATHS),(SUM(NEW_DEATHS)/SUM(NEW_CASES))AS DEATH_PERCENTAGE
FROM dbo.COWID_DEATHS
WHERE CONTINENT IS NOT NULL


SELECT SUM(NEW_CASES), SUM(NEW_DEATHS),(SUM(NEW_DEATHS)/SUM(NEW_CASES))AS DEATH_PERCENTAGE
FROM dbo.COWID_DEATHS

SELECT Dth.CONTINENT , Dth.DATE, Dth.LOCATION, Dth.LOCATION, Vcine.New_vaccinations, 
SUM(New_Vaccinations) OVER (PARTITION BY Dth.LOCATION, Dth.DATE)
FROM dbo.COWID_DEATHS Dth
INNER JOIN dbo.COWID_VACCINATIONS Vcine
ON Dth.LOCATION = Vcine.LOCATION AND Dth.DATE = Vcine.DATE
WHERE CONTINENT IS NOT NULL


SELECT 
    Dth.CONTINENT,
    Dth.DATE,
    Dth.LOCATION,
    Vcine.New_vaccinations,
    SUM(CAST(Vcine.New_vaccinations AS BIGINT)) OVER (PARTITION BY Dth.LOCATION ORDER BY Dth.LOCATION,Dth.DATE) AS TOTALCASES_DAYBYDAY
FROM 
    dbo.COWID_DEATHS Dth
INNER JOIN 
    dbo.COWID_VACCINATIONS Vcine ON Dth.LOCATION = Vcine.LOCATION AND Dth.DATE = Vcine.DATE
WHERE 
    Dth.CONTINENT IS NOT NULL 
ORDER BY Dth.LOCATION,Dth.DATE




WITH CTE AS (
    SELECT 
        Dth.CONTINENT,
        Dth.DATE,
        Dth.LOCATION,
        Dth.POPULATION,  -- Assuming the population column is in dbo.COWID_DEATHS
        Vcine.New_vaccinations,
        SUM(CAST(Vcine.New_vaccinations AS BIGINT)) OVER (PARTITION BY Dth.LOCATION ORDER BY Dth.LOCATION, Dth.DATE) AS TOTALCASES_DAYBYDAY
    FROM 
        dbo.COWID_DEATHS Dth
    INNER JOIN 
        dbo.COWID_VACCINATIONS Vcine ON Dth.LOCATION = Vcine.LOCATION AND Dth.DATE = Vcine.DATE
    WHERE 
        Dth.CONTINENT IS NOT NULL
)
SELECT 
    CTE.CONTINENT,
    CTE.LOCATION,
    MAX(CTE.TOTALCASES_DAYBYDAY) AS MAX_TOTALCASES_DAYBYDAY,
    CTE.POPULATION  -- Include the population column in the final SELECT
FROM 
    CTE
GROUP BY 
    CTE.CONTINENT, CTE.LOCATION, CTE.POPULATION;



WITH CTE AS (
    SELECT 
        Dth.CONTINENT,
        Dth.DATE,
        Dth.LOCATION,
        Dth.POPULATION,
        Vcine.New_vaccinations,
        SUM(CAST(Vcine.New_vaccinations AS BIGINT)) OVER (PARTITION BY Dth.LOCATION ORDER BY Dth.LOCATION, Dth.DATE) AS TOTALCASES_DAYBYDAY
    FROM 
        dbo.COWID_DEATHS Dth
    INNER JOIN 
        dbo.COWID_VACCINATIONS Vcine ON Dth.LOCATION = Vcine.LOCATION AND Dth.DATE = Vcine.DATE
    WHERE 
        Dth.CONTINENT IS NOT NULL
)
SELECT 
    CTE.CONTINENT,
    CTE.LOCATION,
    MAX(CTE.TOTALCASES_DAYBYDAY) AS MAX_TOTALCASES_DAYBYDAY,
    CTE.POPULATION,
    (MAX(CTE.TOTALCASES_DAYBYDAY) * 100.0) / NULLIF(CTE.POPULATION, 0) AS PERCENTAGE
FROM 
    CTE
GROUP BY 
    CTE.CONTINENT, CTE.LOCATION, CTE.POPULATION;


--TABLEAU PROJECT

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.Cowid_Deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From dbo.Cowid_Deaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.Cowid_Deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Cowid_Deaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


    
--DATA CLEANING

SELECT * FROM dbo.Data_Cleaning;

Select SaleDateConverted, CONVERT(Date,SaleDate)
From dbo.Data_Cleaning;

UPDATE dbo.Data_Cleaning
SET SaleDateConverted = CONVERT(Date,SaleDate)

ALTER TABLE dbo.Data_Cleaning ADD SaleDateConverted DATE;

--ISNULL
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress FROM dbo.Data_Cleaning a
INNER JOIN dbo.Data_Cleaning b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.Data_Cleaning a
INNER JOIN dbo.Data_Cleaning b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM Data_Cleaning


ALTER TABLE Data_Cleaning
Add PropertySplitAddress Nvarchar(255);
Update Data_Cleaning
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Data_Cleaning
Add PropertySplitCity Nvarchar(255);
Update Data_Cleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

ALTER TABLE Data_Cleaning
DROP COLUMN PropertySplitCity;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Data_Cleaning;


ALTER TABLE Data_Cleaning
Add OwnerSplitAddress Nvarchar(255);
Update Data_Cleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Data_Cleaning
Add OwnerSplitCity Nvarchar(255);
Update Data_Cleaning
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE Data_Cleaning
Add OwnerSplitState Nvarchar(255);
Update Data_Cleaning
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Data_Cleaning
Group by SoldAsVacant

Select SoldAsVacant, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END AS Yes_OR_NO
From Data_Cleaning

UPDATE Data_Cleaning SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 
From Data_Cleaning


