--Select *
--From [Portfolio Project]..CovidVaccines
--order by 3,4

Select *
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 3,4



-- Select the Data that I are going to be using 
 
 Select Location, date, total_cases, new_cases, total_deaths, population 
 From [Portfolio Project]..CovidDeaths
 Where continent is not null
 order by 1,2

 -- Total Cases Vs Total Deaths

 Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
 From [Portfolio Project]..CovidDeaths
 Where location like '%Malawi%'
 and continent is not null
 order by 1,2
 

 -- Total cases Vs Population
 -- What percentage of population has covid

	 Select Location, date, population, total_cases,  (total_cases/population) as Percentofpopulationinfected 
	 From [Portfolio Project]..CovidDeaths
	 -- Where location like '%Malawi%'
	 Where continent is not null
	 order by 1,2

	 -- countries with highest infection rate compared to population

		 Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofPopulationinfected

		From [Portfolio Project]..CovidDeaths
		Group by Location, population 
		order by PercentofPopulationinfected desc

		-- countries with the Highest death count per population 
		
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '$Malawi$'
Where continent is not null
Group by Location 
order by TotalDeathCount desc

Break by continent 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '$Malawi$'
Where continent is not null
Group by continent 
order by TotalDeathCount desc 


--GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
 From [Portfolio Project]..CovidDeaths 
 --Where location like '%Malawi%'
 where continent is not null
 Group by date 
 order by 1,2
 
 -- Total Populations Vs Vaccinations 
 --CTE
 With PopulvsVaccinated (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated) 
as
( 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccines vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopulvsVaccinated

--CREATING a TEMP table 
DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_vaccinations Numeric,
RollingPeopleVaccinated Numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccines vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



--Creating views to store data for visualizations 

create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccines vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVaccinated



	



	