Select *
From PortfolioProject..covidDeaths
Where continent is not NULL -- get rid of continent is location
Order by 3,4

--Select *
--From PortfolioProject..covidVaccinations
--Order by 3,4

--Select Data that we are ging to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..covidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you got covid19 in the US

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentages
From PortfolioProject..covidDeaths
Where location like '%states%'
Order by 1,2


-- Looking Total Cases vs Population

Select Location, date, Population, total_cases,(total_cases/population)*100 as ContactPercentages
From PortfolioProject..covidDeaths
Where location like '%Taiwan%'
Order by 1,2


-- Looking at countries with highest Infection Rate compared to population

Select Location, Population, max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PrecentagePopulationInfected
From PortfolioProject..covidDeaths
Group by Location, Population
Order by PrecentagePopulationInfected DESC


-- Showing Countries with Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is not NULL
Group by Location
Order by TotalDeathCount DESC


-- Break down by continent

-- Showing the continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..covidDeaths
Where continent is not NULL
Group by continent
Order by TotalDeathCount DESC

-- Global Numbers
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From PortfolioProject..covidDeaths
Where continent is not null
Group by date
Order by 1,2

-- Global Numbers overall
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From PortfolioProject..covidDeaths
Where continent is not null
Order by 1,2


-- Looking at Total population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population) *100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
	On dea.Location = vac.Location
	and dea.date = vac.date
Where dea.continent is not Null
Order by 2,3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population) *100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
	On dea.Location = vac.Location
	and dea.date = vac.date
Where dea.continent is not Null
-- Order by 2,3
)

Select *,(RollingPeopleVaccinated/population) *100
From PopvsVac


-- Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
		
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
	On dea.Location = vac.Location
	and dea.date = vac.date
--Where dea.continent is not Null
-- Order by 2,3

Select *,(RollingPeopleVaccinated/population) *100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualization (View is permenant table now)

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		sum(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/population) *100
From PortfolioProject..covidDeaths dea
Join PortfolioProject..covidVaccinations vac
	On dea.Location = vac.Location
	and dea.date = vac.date
Where dea.continent is not Null
-- Order by 2,3
