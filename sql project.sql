--select *
--from port.dbo.vacine

--select *
--from sqlll.dbo.vacine
--select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercent
--from sqlll.dbo.vacine
--where location like '%kingdom%'

--create view unitedkingdomcoviddata as
--select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as dpercent
--from sqlll.dbo.vacine
--where location like '%kingdom%'






--total cases versus the population
create view total_cases_versus_thepopulation as
select continent, location, date, population, total_cases, total_deaths, (total_cases/population)*100 as dpercent
from sqlll.dbo.vacine
where population is not null
and total_deaths 
is not null
order by 1,2

----looking at countries with highest infection rate compared to population
--select location, population,  max(total_cases) as highestcount, 
--max(total_cases/population)*100 as dpercent
--from sqlll.dbo.vacine
----where continent is not null
--group by location
----, population
----order by dpercent desc

--let break down by continent
--select location, max(cast(total_deaths as int)) as totaldeathcount
--from sqlll.dbo.vacine
--where continent is  null
--group by location
--order by totaldeathcount desc

--global numbers based on new cases

--SELECT date, continent, location, SUM(new_cases) AS total_new_cases,
--sum(cast(total_deaths as int))-- we are casting as integer because th table definition 
----of total deaths is in varchar 
--as totaldeaths
--FROM sqlll.dbo.vacine
--WHERE continent IS NOT NULL
--GROUP BY date, continent, location
--ORDER BY date, continent;

--moving in to joining the second table

--select *
--from port.dbo.vacine
--select *
--from sqlll.dbo.vacine as dea
--join port.dbo.vacine as vac
--on dea.location = vac.location and dea.date=vac.date

select dea.date, dea.continent, dea.location, sum(dea.population) as totalpopulation, 
sum(cast(vac.new_vaccinations as int)) over 
(partition by dea.location)as rollingpeoplevaccination
from sqlll.dbo.vacine as dea
join port.dbo.vacine as vac
on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null
GROUP BY 
    dea.date, dea.continent, dea.location, 
	dea.population, vac.new_vaccinations
	order by 2,3