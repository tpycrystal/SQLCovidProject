--Queries for Tableau

--1. Global Numbers overall
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From PortfolioProject..covidDeaths
Where continent is not null
Order by 1,2

--2
Select continent, sum(cast(new_deaths as int)) as TotalDeathCounts
From PortfolioProject..covidDeaths
Where continent is not null
--and location not in ("World", "European Union", "International")
Group by continent
Order by TotalDeathCounts desc

--3
Select Location, Population, max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PrecentagePopulationInfected
From PortfolioProject..covidDeaths
Group by Location, Population
Order by PrecentagePopulationInfected DESC

--4
Select Location, Population, date, max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PrecentagePopulationInfected
From PortfolioProject..covidDeaths
Group by Location, Population, date
Order by PrecentagePopulationInfected DESC