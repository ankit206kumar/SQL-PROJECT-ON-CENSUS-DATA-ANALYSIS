select * from data1;
select * from data2;

-- number of rows in our dataset
select count(*) from data1;
select count(*) from data2;

-- dataset from bihar and jharkhand
select * from data1
where state in ('Jharkhand','Bihar');
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- population of india
update data2
set population=replace(upper(population),',','');
select sum(population) as total_population
from data2;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- average population growth 
select avg(growth) as growth_rate
from data1;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
 -- average growth percentage by state
select state,avg(growth) as growth_rate
from data1
group by state
order by growth_rate desc;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- average sex ratio
select state, round(avg(sex_ratio),0) from data1
group by state
order by avg(sex_ratio) desc;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- average literacy rate
select state,round(avg(literacy),2) as literacy_rate
from data1
group by state
order by literacy_rate desc;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- states having literacy rate greater than 90
select state,round(avg(literacy),2) as literacy_rate
from data1
group by state
having literacy_rate>90
order by literacy_rate desc;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- top 3 states showing highest population growth rate
select state, round(avg(growth),2) as growth_rate
 from data1
 group by state 
 order by growth_rate desc limit 3;
 -- -------------------------------------------------------------------------------------------------------------------------------------------
 
 -- bottom 3 states in terms of population growth
 select state, round(avg(growth),2) as growth_rate
 from data1
 group by state 
 order by growth_rate limit 3;
 -- --------------------------------------------------------------------------------------------------------------------------------------------
-- top 3 states in terms of literay rate

 select state,round(avg(literacy),2) as literacy_rate
from data1
group by state
order by literacy_rate desc limit 3;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
--  bottom 3 states in terms of literay rate
 select state,round(avg(literacy),2) as literacy_rate
from data1
group by state
order by literacy_rate limit 3;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- top 3 states in terms of sex ratio
select state, round(avg(sex_ratio),0) from data1
group by state
order by avg(sex_ratio) desc limit 3;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- bottom 3 states in terms of sex ratio
select state, round(avg(sex_ratio),0) from data1
group by state
order by avg(sex_ratio)  limit 3;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- states starting with letter a
select * from data1
where state like 'a%';
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- joining both tables
select  
a.district ,a.state,a.sex_ratio,a.literacy,b.population 
from data1 as a 
inner join data2 as b
 on a.district=b.district;
 -- --------------------------------------------------------------------------------------------------------------------------------------------
 -- No. of males and females in each district
 select c.district,c.state,round((c.population)/((c.sex_ratio/1000)+1),0) as males,round((c.population*((c.sex_ratio/1000)/(c.sex_ratio/1000+1))),0) as females from
 (select  
a.district ,a.state,a.sex_ratio,a.literacy,b.population 
from data1 as a 
inner join data2 as b
 on a.district=b.district) as c;
 -- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- total male and female population state-wise
 select d.state,sum(d.males) as total_males,sum(d.females) as total_females from
 (
  select c.district,c.state,round((c.population)/((c.sex_ratio/1000)+1),0) as males,round((c.population*((c.sex_ratio/1000)/(c.sex_ratio/1000+1))),0) as females from
 (select  
a.district ,a.state,a.sex_ratio,a.literacy,b.population 
from data1 as a 
inner join data2 as b
 on a.district=b.district)as c )as d
 group by d.state;
 -- --------------------------------------------------------------------------------------------------------------------------------------------
-- total literate population
select d.state,sum(d.literate_people) as total_literate_people,sum(d.illeterate_people) as total_illeterate_people from
(select c.district,c.state,round(c.literacy_ratio * c.population,0) as literate_people,round((1-c.literacy_ratio)*c.population) as illeterate_people from
(select a.district,a.state,a.literacy/100 as literacy_ratio,b.population 
from data1 as a inner join data2 as b
on a.district =b.district) as c ) as d
group by d.state; 
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- population in previous census
select d.state,sum(d.previous_population) as population_last_census,sum(d.current_population) as population_current_census from
(
select c.state,c.district,c.growth_rate,round(c.population/(1+c.growth_rate),0) as previous_population,c.population as current_population from
(
select a.district,a.state,a.growth/100 as growth_rate,b.population 
from data1 as a inner join data2 as b
on a.district=b.district
) as c)as d
group by d.state;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- total population of india in previous and current census
select sum(m.population_last_census) as India_population_prev_census,sum(m.population_current_census) as India_population_curr_census from
(
select d.state,sum(d.previous_population) as population_last_census,sum(d.current_population) as population_current_census from
(
select c.state,c.district,c.growth_rate,round(c.population/(1+c.growth_rate),0) as previous_population,c.population as current_population from
(
select a.district,a.state,a.growth/100 as growth_rate,b.population 
from data1 as a inner join data2 as b
on a.district=b.district
) as c)as d
group by d.state) as m;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- total population density
select *, curr_pop_density-prev_pop_density pop_den_growth, round(((curr_pop_density-prev_pop_density)/prev_pop_density)*100,2) pop_den_growth_pct from 
(
select state, sum(Area_km2) state_area, sum(population) curr_pop, round(sum(population)/sum(area_km2),0) curr_pop_density, sum(prev_pop) prev_pop, round(sum(prev_pop)/sum(area_km2),0) prev_pop_density,(sum(population)-sum(prev_pop)) growth from
(
select c.district, c.state, c.population,c. growth, c.Area_km2, round(c.population/(1+c.Growth),0) prev_pop from 
(
select a.district, a.state, a.Growth, b.Area_km2, b.population
 from Data1 as a inner join data2 b 
 on a.district = b.district) c) d
group by state) e
order by pop_den_growth_pct desc;
-- ---------------------------------------------------------------------------------------------------------------------------------------------







