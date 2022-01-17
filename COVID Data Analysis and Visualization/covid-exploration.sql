-- Set empty cells to 'NULL' in deaths table
update COVID.deaths 
SET continent = NULLIF(continent, '');
update COVID.deaths 
SET population = NULLIF(population, '');
update COVID.deaths 
SET total_cases = NULLIF(total_cases, '');
update COVID.deaths 
SET new_cases = NULLIF(new_cases, '');
update COVID.deaths 
SET new_cases_smoothed = NULLIF(new_cases_smoothed, '');
update COVID.deaths 
SET total_deaths = NULLIF(total_deaths, '');
update COVID.deaths 
SET new_deaths = NULLIF(new_deaths, '');
update COVID.deaths 
SET new_deaths_smoothed = NULLIF(new_deaths_smoothed, '');
update COVID.deaths 
SET total_cases_per_million = NULLIF(total_cases_per_million, '');
update COVID.deaths 
SET new_cases_per_million = NULLIF(new_cases_per_million, '');
update COVID.deaths 
SET new_cases_smoothed_per_million = NULLIF(new_cases_smoothed_per_million, '');
update COVID.deaths 
SET total_deaths_per_million = NULLIF(total_deaths_per_million, '');
update COVID.deaths 
SET new_deaths_per_million = NULLIF(new_deaths_per_million, '');
update COVID.deaths 
SET new_deaths_smoothed_per_million = NULLIF(new_deaths_smoothed_per_million, '');
update COVID.deaths 
SET reproduction_rate = NULLIF(reproduction_rate, '');
update COVID.deaths 
SET icu_patients = NULLIF(icu_patients, '');
update COVID.deaths 
SET icu_patients_per_million = NULLIF(icu_patients_per_million, '');
update COVID.deaths 
SET hosp_patients = NULLIF(hosp_patients, '');
update COVID.deaths 
SET hosp_patients_per_million = NULLIF(hosp_patients_per_million, '');
update COVID.deaths 
SET weekly_icu_admissions = NULLIF(weekly_icu_admissions, '');
update COVID.deaths 
SET weekly_icu_admissions_per_million = NULLIF(weekly_icu_admissions_per_million, '');
update COVID.deaths 
SET weekly_hosp_admissions = NULLIF(weekly_hosp_admissions, '');
update COVID.deaths 
SET weekly_hosp_admissions_per_million = NULLIF(weekly_hosp_admissions_per_million, '');

-- Set empty cells to 'NULL' in vaccinations table
update COVID.vaccinations
SET continent = NULLIF(continent, '');
update COVID.vaccinations
SET new_tests = NULLIF(new_tests, '');
update COVID.vaccinations
SET total_tests = NULLIF(total_tests, '');
update COVID.vaccinations
SET total_tests_per_thousand = NULLIF(total_tests_per_thousand, '');
update COVID.vaccinations
SET new_tests_per_thousand = NULLIF(new_tests_per_thousand, '');
update COVID.vaccinations
SET new_tests_smoothed = NULLIF(new_tests_smoothed, '');
update COVID.vaccinations
SET new_tests_smoothed_per_thousand = NULLIF(new_tests_smoothed_per_thousand, '');
update COVID.vaccinations
SET positive_rate = NULLIF(positive_rate, '');
update COVID.vaccinations
SET tests_per_case = NULLIF(tests_per_case, '');
update COVID.vaccinations
SET tests_units = NULLIF(tests_units, '');
update COVID.vaccinations
SET total_vaccinations = NULLIF(total_vaccinations, '');
update COVID.vaccinations
SET people_vaccinated = NULLIF(people_vaccinated, '');
update COVID.vaccinations
SET people_fully_vaccinated = NULLIF(people_fully_vaccinated, '');
update COVID.vaccinations
SET total_boosters = NULLIF(total_boosters, '');
update COVID.vaccinations
SET new_vaccinations = NULLIF(new_vaccinations, '');
update COVID.vaccinations
SET new_vaccinations_smoothed = NULLIF(new_vaccinations_smoothed, '');
update COVID.vaccinations
SET total_vaccinations_per_hundred = NULLIF(total_vaccinations_per_hundred, '');
update COVID.vaccinations
SET people_vaccinated_per_hundred = NULLIF(people_vaccinated_per_hundred, '');
update COVID.vaccinations
SET people_fully_vaccinated_per_hundred = NULLIF(people_fully_vaccinated_per_hundred, '');
update COVID.vaccinations
SET total_boosters_per_hundred = NULLIF(total_boosters_per_hundred, '');
update COVID.vaccinations
SET new_vaccinations_smoothed_per_million = NULLIF(new_vaccinations_smoothed_per_million, '');
update COVID.vaccinations
SET new_people_vaccinated_smoothed = NULLIF(new_people_vaccinated_smoothed, '');
update COVID.vaccinations
SET new_people_vaccinated_smoothed_per_hundred = NULLIF(new_people_vaccinated_smoothed_per_hundred, '');
update COVID.vaccinations
SET stringency_index = NULLIF(stringency_index, '');
update COVID.vaccinations
SET population_density = NULLIF(population_density, '');
update COVID.vaccinations
SET median_age = NULLIF(median_age, '');
update COVID.vaccinations
SET aged_65_older = NULLIF(aged_65_older, '');
update COVID.vaccinations
SET aged_70_older = NULLIF(aged_70_older, '');
update COVID.vaccinations
SET gdp_per_capita = NULLIF(gdp_per_capita, '');
update COVID.vaccinations
SET extreme_poverty = NULLIF(extreme_poverty, '');
update COVID.vaccinations
SET cardiovasc_death_rate = NULLIF(cardiovasc_death_rate, '');
update COVID.vaccinations
SET diabetes_prevalence = NULLIF(diabetes_prevalence, '');
update COVID.vaccinations
SET female_smokers = NULLIF(female_smokers, '');
update COVID.vaccinations
SET male_smokers = NULLIF(male_smokers, '');
update COVID.vaccinations
SET handwashing_facilities = NULLIF(handwashing_facilities, '');
update COVID.vaccinations
SET hospital_beds_per_thousand = NULLIF(hospital_beds_per_thousand, '');
update COVID.vaccinations
SET life_expectancy = NULLIF(life_expectancy, '');
update COVID.vaccinations
SET human_development_index = NULLIF(human_development_index, '');


select location, continent, record_date, new_cases, total_deaths, population
from COVID.deaths
where continent is not null
order by 1,2;

-- Total cases vs. Total deaths (Death Rate)
select location, record_date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from COVID.deaths
where location like 'Canada'
order by 1,2;

-- Total cases vs. Population (Infection Rate)
select location, record_date, total_cases, population, (total_cases/population)*100 as infection_rate
from COVID.deaths
where location like 'Canada'
order by 1,2;

-- Max infection rates for each country
select location, MAX(total_cases) as max_cases, population, MAX((total_cases/population))*100 as infection_rate
from COVID.deaths
group by location, population
order by infection_rate desc;

-- Sort countries by highest death count
select location, MAX(total_deaths) as max_deaths
from COVID.deaths
where continent is not null
group by location
order by max_deaths desc;

-- Sort continents by highest total death count
select location, MAX(total_deaths) as max_deaths
from COVID.deaths
where continent is null
group by location
order by max_deaths desc;

-- GLOBAL DATA

-- Daily total new cases and deaths
select record_date, SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_rate
from COVID.deaths
where continent is not null
group by record_date
order by 1,2;

-- Join deaths and vaccinations tables (by location and date)
select *
from COVID.deaths deaths join COVID.vaccinations vax
on deaths.location = vax.location and deaths.record_date = vax.record_date;

-- Population vs. vaccinations
-- rolling_vaccinations: Rolling count of vaccinations (by country)
select deaths.continent, deaths.location, deaths.record_date, deaths.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.record_date) as rolling_vaccinations
from COVID.deaths deaths join COVID.vaccinations vax
on deaths.location = vax.location and deaths.record_date = vax.record_date
where deaths.continent is not null
order by 2,3;

-- Perform further calculations on 'rolling_vaccinations' using CTE
-- percent_vaccinated: Total vaccinations / Population
-- max_percent_vaccinated: Current percentage of population vaccinated (by country)
with Pop_Vax (continent, location, record_date, population, new_vaccinations, rolling_vaccinations) as
	(select deaths.continent, deaths.location, deaths.record_date, deaths.population, vax.new_vaccinations,
	SUM(vax.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.record_date) as rolling_vaccinations
	from COVID.deaths deaths join COVID.vaccinations vax
	on deaths.location = vax.location and deaths.record_date = vax.record_date
	where deaths.continent is not null)
select *, (rolling_vaccinations/population)*100 as percent_vaccinated,
MAX((rolling_vaccinations/population)*100) over (partition by location) as max_percent_vaccinated
from Pop_Vax;

-- Perform further calculations on 'rolling_vaccinations' using TEMP TABLE
drop table if exists PercentPopulationVaccinated;
create temporary table PercentPopulationVaccinated
(
continent VARCHAR(100),
location VARCHAR(100),
record_date VARCHAR(100),
population double,
new_vacciations VARCHAR(100),
rolling_vaccinations VARCHAR(100)
);

insert into PercentPopulationVaccinated
select deaths.continent, deaths.location, deaths.record_date, deaths.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.record_date) as rolling_vaccinations
from COVID.deaths deaths join COVID.vaccinations vax
on deaths.location = vax.location and deaths.record_date = vax.record_date
where deaths.continent is not null
order by 2,3;

select *, (rolling_vaccinations/population)*100 as percent_vaccinated
from PercentPopulationVaccinated;

-- Create views to store data for visualizations in Tableau
create view PercentPopulationVaccinated as
select deaths.continent, deaths.location, deaths.record_date, deaths.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.record_date) as rolling_vaccinations
from COVID.deaths deaths join COVID.vaccinations vax
on deaths.location = vax.location and deaths.record_date = vax.record_date
where deaths.continent is not null;