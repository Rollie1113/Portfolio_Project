
select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



select *
from PortfolioProject..CovidVaccinations
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2


Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..CovidDeaths
where location like 'Philippines'
and continent is not null
order by 1,2


select location, date, population, total_cases, (total_cases/NULLIF(population,0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/NULLIF(population,0)))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by PercentPopulationInfected desc



select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



Select SUM(cast(new_cases as int))as total_cases, SUM(cast(new_deaths as int))as total_deaths, NULLIF(SUM(cast(new_deaths as float)),0)/NULLIF(SUM(cast(new_cases as float)),0)*100 as DeathPercentage
--(total_deaths/NULLIF(total_cases,0)) * 100 AS Deathpercentage
from PortfolioProject..CovidDeaths
--where location like 'Philippines'
where continent is not null
--group by date
order by 1,2


with PopvsVac (continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, (cast (vac.new_vaccinations as float)) as new_vaccinations, SUM(NULLIF(cast(vac.new_vaccinations as float),0)) OVER (partition by dea.location Order by dea.date ) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, (cast (vac.new_vaccinations as float)) as new_vaccinations, SUM(NULLIF(cast(vac.new_vaccinations as float),0)) OVER (partition by dea.location Order by dea.date ) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, (cast (vac.new_vaccinations as float)) as new_vaccinations, SUM(NULLIF(cast(vac.new_vaccinations as float),0)) OVER (partition by dea.location Order by dea.date ) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3




with PopvsVac (continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, (cast (vac.new_vaccinations as float)) as new_vaccinations, SUM(cast(vac.new_vaccinations as float)) OVER (partition by dea.location Order by dea.location, dea.date ) as RollingPeopleVaccinated
from PortfolioProject2..CovidDeaths dea
Join PortfolioProject2..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
From PopvsVac










