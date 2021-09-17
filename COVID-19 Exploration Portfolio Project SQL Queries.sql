/*

Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



Select * 
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4



--Select * 
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

--Lets Select the data that we are using

Select location,date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2



-- Lets Look at Total cases Vs Total Deaths
-- Show likelihood of dying if you contract Covid in different countries
Select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null and location like '%India%'
order by 1, 2

 


--Total cases Vs Population
-- This shows the % of population contrACTED WITH covid
Select location,date, total_cases, population, (total_cases/population)*100 as CovidPositivePercentage
FROM PortfolioProject..CovidDeaths
Where location like '%India%'
and continent is not null
Order By 1,2



-- Countries with Highest Infection Rate Compared to Population

Select location,Population,Max(total_cases) as HighestInfectionCount,Max(total_cases/population)*100 as InfectedPopulationPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group By location,population
Order By InfectedPopulationPercentage desc



--Countries with Highest Death Count per Population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group By location
Order By TotalDeathCount desc



-- Lets break it down by Continent
--Showing Continents with Highest Death Counts per Population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc





-- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by date
order by 1, 2




-- Total death %

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location like '%india%'
Where continent is not null
--Group by date
order by 1, 2

-----

Select *
From PortfolioProject..CovidVaccinations





--- Let's look at Toal Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) Over (Partition By dea.location Order By dea.location, dea.Date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order By 2,3




-- Lets Use CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) Over (Partition By dea.location Order By dea.location, dea.Date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





-- TEMP TABLE

DROP Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) Over (Partition By dea.location Order By dea.location, dea.Date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--- Creatng View to store data for later Visualixations


Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) Over (Partition By dea.location Order By dea.location, dea.Date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3


Select *
from PercentPopulationVaccinated
