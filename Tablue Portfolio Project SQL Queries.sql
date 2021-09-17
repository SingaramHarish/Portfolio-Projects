/*

Queries for Tableau Project

*/


--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location like %states%
where continent is not null
-- Group By date
Order By 1,2


-- Just a double check based off the data provided
--numbers are extremely close so we will keep them - The second includes 'International" Location

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where location = 'World'
--Group By date
Order By 1,2


--2. 


-- We take these out as they are not included in the above queries and want to stay consistent
--European Union is a part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc


-- 3.


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group By location, population
Order By PercentPopulationInfected desc


-- 4.

Select location,population, date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location like '%states%
Group by location, population, date
Order BY PercentPopulationInfected desc

