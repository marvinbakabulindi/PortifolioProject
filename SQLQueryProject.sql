select * 
from PortifolioProject.dbo.CovidDeaths
order by 3,4

--select * 
--from PortifolioProject.dbo.CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortifolioProject..CovidDeaths
order by 1,2

--total case vs total deaths
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPerce
from PortifolioProject..CovidDeaths
where location like '%uganda%'
order by 1,2

--total cases vs popn
select location,date,total_cases,population, (total_cases/population)*100 as casePopn
from PortifolioProject..CovidDeaths
where location like '%uganda%'
order by 1,2

--countries with highest infection rate
select location,MAX(total_cases) as High, population, MAX((total_cases/population))*100 as PercePopnInfe
from PortifolioProject..CovidDeaths
group by location,population
order by PercePopnInfe desc

--countries with the highest death counts
select location,Max(cast(total_deaths as int)) as totalDeathCount
from PortifolioProject..CovidDeaths
where continent is not null
group by location
order by totalDeathCount desc

--grouping by continent
select location,Max(cast(total_deaths as int)) as totalDeathCount
from PortifolioProject..CovidDeaths
where continent is  null
group by location
order by totalDeathCount desc

--continents with highest death count
select location,Max(cast(total_deaths as int)) as totalDeathCount
from PortifolioProject..CovidDeaths
where continent is  null
group by location
order by totalDeathCount desc

--total popn vs vacination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as CummVac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte
with percePpleVac(continent,location,date,population,new_vaccinations,CummVac)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as CummVac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,( CummVac/population)*100 as PercePpleVac
from 
percePpleVac

--view for storing  data for visualization

create view PercenPopnVacci as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as CummVac
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

