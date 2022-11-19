-- In this project, I focused on global COVID data from 2020-2021. By having two tables (Vaccinations and Deaths), I was able to see the correlations in the data when it came to certain countries and timeframes. I hope you enjoy my data cleaning and exploration.


select * 
From PortfolioProject..CovidDeaths
order by 3,4

--select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs. Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases,population, (total_cases/population)*100 as TotalCasesPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location,max(total_cases) as HighestInfectionCount,population, max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location,population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
-- Convert (cast) as an int

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Showing Continents with Highest Death Count per Population


Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global Numbers

Select SUM(new_cases) as total_case,SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group By date
order by 1,2

-- Looking at Total Population vs. Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccination as
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From #PercentPopulationVaccinated

Create View TotalDeathCount as
Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
--order by TotalDeathCount desc

Create View TotalCasesPercentage as
Select Location, date, total_cases,population, (total_cases/population)*100 as TotalCasesPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
--order by 1,2

Select *
From TotalCasesPercentage
