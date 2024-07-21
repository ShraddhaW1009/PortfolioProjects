select *
from PortfolioProject..CovidDeaths
order by 3,4


--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

select Location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as TotalcaseshPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

select Location, Population, max(total_cases) as HighestInfectionCount, Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by Location, Population
order by PercentPopulationInfected desc

select Location, max(total_deaths) as HighesDeathCount, Max((cast(total_deaths as float)/cast(population as float)))*100 as PercentDeathPopulation
from PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by PercentDeathPopulation desc

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by Location
order by TotalDeathCount desc

select Continent, max(cast(total_deaths as int)) as HighesDeathCount, Max((cast(total_deaths as float)/cast(population as float)))*100 as PercentDeathPopulation
from PortfolioProject..CovidDeaths
where continent is not null
group by Continent
order by PercentDeathPopulation desc

select sum(new_deaths) as TotalDeaths, sum(new_cases) as TotalCases, (sum(new_deaths)/sum(new_cases))*100 as DeathPercent
from PortfolioProject..CovidDeaths
--where location like 'India'
where continent is not null
--group by date
order by 1,2

with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)
	   as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac


Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)
	   as RollingPeopleVaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3