SELECT * FROM SHARK_TANK..data;

--total episodes 

select count(distinct ep_no) as [Total Episodes] from shark_tank..data;

select max( ep_no) from shark_tank..data;


--no of pitches

select count(distinct brand) as [No. of Pitches] from shark_tank..data;

--if startup got funding

select sum(converted_not_converted) as [No of startup Fundings], count(*) as [total pitches] from 
(select amount_invested_lakhs, case when amount_invested_lakhs > 0 then 1 else 0 end as 'Converted_not_converted' from shark_tank..data)a; 

--success percentage

select round((cast(sum(converted_not_converted) as float)/cast(count(*) as float))*100,2) as [Success Percentage] from 
(select amount_invested_lakhs, case when amount_invested_lakhs > 0 then 1 else 0 end as 'Converted_not_converted' from shark_tank..data)a; 

--total male

select sum(male) as Males from shark_tank..data;

--total female

select sum(female) as females from shark_tank..data;

--total invested amount

select sum(amount_invested_lakhs) as [Total Invested Amount in Lakhs] from shark_tank..data;

--avg equity taken

select round(avg(equity_taken),2) as [Avg Equity Taken]from 
(select * from shark_tank..data
where equity_taken > 0)a;

--highest deal taken

select max(amount_invested_lakhs) as highest_deal from shark_tank..data;

--highest equity taken

select max(equity_taken) as highest_equity_taken from shark_tank..data;

--pitches which had atleast 1 woman

select count(*) 
from shark_tank..data
where female >=1;

or

select sum(female_count) from
(select female, case when female > 0 then 1 else 0 end as female_count from shark_tank..data) a;

--pitches converted having atleast 1 woman

select sum(female_count) from
(select case when female > 0 then 1 else 0 end as female_count,* from
(SELECT * FROM SHARK_TANK..data
where deal != 'No Deal') a) b;

--average team members

select avg(team_members) from shark_tank..data

--amount invested per deal

select avg(amount_invested_lakhs) as [Amount Invested per Deal] from
(SELECT * FROM SHARK_TANK..data
where deal != 'No Deal')a;

--Avg age group for entrepreneur

select avg_age, count(avg_age) as Count
from shark_tank..data
group by avg_age
order by count desc;

--Avg location for entrepreneur

select location, count(location) as Count
from shark_tank..data
group by location
order by count desc;

--Avg sector for entrepreneur

select sector, count(sector) as Count
from shark_tank..data
group by sector
order by count desc;

--partner deals

select partners, count(partners) as count
from shark_tank..data
where Partners != '-'
group by Partners
order by count desc

--making the matrix for ashneer

select 'Ashneer' as keyy,count(ashneer_amount_invested) from shark_tank..data
where Ashneer_Amount_Invested is not null


select 'Ashneer' as keyy,count(ashneer_amount_invested) from shark_tank..data
where Ashneer_Amount_Invested is not null and Ashneer_Amount_Invested !=0

select 'Ashneer' as keyy, sum(ashneer_amount_invested), avg(ashneer_equity_taken) 
from (
select * from shark_tank..data
where Ashneer_Amount_Invested !=0 and Ashneer_Amount_Invested is not null) c



select m.keyy, m.total_deals_present, m.total_deals, n.total_amount_invested, n.avg_equity_taken from 
(select a.keyy, a.total_deals_present, b.total_deals from(
select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals_present from shark_tank..data
where Ashneer_Amount_Invested is not null) a
inner join(
select 'Ashneer' as keyy,count(ashneer_amount_invested) total_deals from shark_tank..data
where Ashneer_Amount_Invested is not null and Ashneer_Amount_Invested !=0) b
on a.keyy = b.keyy) m
inner join
(select 'Ashneer' as keyy, sum(ashneer_amount_invested) total_amount_invested, avg(ashneer_equity_taken) avg_equity_taken
from (
select * from shark_tank..data
where Ashneer_Amount_Invested !=0 and Ashneer_Amount_Invested is not null) c)n
on m.keyy = n.keyy;


--which is the startup which has the highest invest amount in each sector

select * from
(select brand,sector, amount_invested_lakhs, rank() over (partition by sector order by amount_invested_lakhs desc) as rank
from shark_tank..data) a
where rank = 1;