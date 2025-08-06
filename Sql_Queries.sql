/*
Spend through credit card across cities in India

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select min(str_to_date(date,'%d-%b-%y')),max(str_to_date(date,'%d-%b-%y')) from credit_card_transcations;
-- 2013-10-04 to 2015-05-26

select distinct card_type from credit_card_transcations;  -- Platinum Silver Signature Gold

select distinct exp_type from credit_card_transcations; -- Bills Food Entertainment Grocery Fuel Travel


-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
select city, sum(amount) as spent_by_city,
round(sum(amount)/ (select sum(amount) from credit_card_transcations) *100,2) as percentage
from credit_card_transcations 
group by city order by percentage desc,spent_by_city desc  limit 5;

-- STR_TO_DATE(date, '%d-%b-%y') convert string to date
-- 2- write a query to print highest spend month and amount spent in that month for each card type
with cte as (
select  card_type, 
monthname(STR_TO_DATE(date, '%d-%b-%y')) AS month ,
sum(amount) as spent ,
row_number() over(partition by card_type order by sum(amount) desc) as rn from credit_card_transcations
group by monthname(STR_TO_DATE(date, '%d-%b-%y')),card_type
order by card_type,spent desc
)
select card_type,month,spent from cte where rn = 1;

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
select * from credit_card_transcations;
with cte as(
select *,
sum(amount) over(partition by card_type order by str_to_date(date,'%d-%b-%y') , ind) as running_sum
from credit_card_transcations
)
select * from cte where running_sum in (select min(running_sum) from cte where running_sum>=1000000 group by card_type);


-- 4- write a query to find city which had lowest percentage spend for gold card type
with cte as (
select city,
round(sum(amount)/(select sum(amount) from credit_card_transcations where card_type in ('Gold')) *100,2) as spent_per
from credit_card_transcations where card_type in ('Gold')
group by city
order by spent_per)
select * from cte where spent_per in (select min(spent_per) from cte);


-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with cte as (
select city,exp_type,sum(amount) as spend_on,
dense_rank() over(partition by city order by sum(amount) desc) as most_spend,
dense_rank() over(partition by city order by sum(amount)) as least_spend
from credit_card_transcations group by city,exp_type
order by city,spend_on desc
)
select c1.city, c1.exp_type as highest_expense_type,c2.exp_type as lowest_expense_type from cte c1
inner join cte c2 on c1.city=c2.city where c1.most_spend =1 and c2.least_spend = 1;

-- 6- write a query to find percentage contribution of spends by females for each expense type

with cte as(
select sum(amount) as total_spent,exp_type from credit_card_transcations group by exp_type
), cte2 as(
select sum(amount) as Female_spent,exp_type from credit_card_transcations where gender = 'F' group by exp_type
) select c1.exp_type, round((Female_spent/total_spent)*100,2) as female_contribution, Female_spent,total_spent 
from cte c1 inner join
cte2 c2 on c1.exp_type = c2.exp_type;


-- 7- which card and expense type combination saw highest month over month growth in Jan-2014

with get_yr_and_mn as (
select card_type,exp_type,
year(str_to_date(date,'%d-%b-%y')) as yr,
month(str_to_date(date,'%d-%b-%y')) as mn,
sum(amount) as amount_p_month_for_card_n_exp
from credit_card_transcations
where (year(str_to_date(date,'%d-%b-%y')) = 2014 and month(str_to_date(date,'%d-%b-%y')) = 1) or
(year(str_to_date(date,'%d-%b-%y')) = 2013 and month(str_to_date(date,'%d-%b-%y')) = 12)
group by card_type, exp_type, yr,mn
),get_prev_mn_amount as (
select *,
lag(amount_p_month_for_card_n_exp) over (partition by card_type,exp_type order by yr,mn) as lag_amount 
from get_yr_and_mn
),get_growth_forjan as (
select *, (((amount_p_month_for_card_n_exp - lag_amount)/ lag_amount) * 100)as growth from get_prev_mn_amount
where yr = 2014 and mn = 1
)select * from get_growth_forjan where growth>0
order by growth desc limit 1 ; -- limit 1 to get card and exp_type with max growth


-- 9- during weekends which city has highest total spend to total no of transcations ratio
with cte as(
select sum(amount) as all_week, city from credit_card_transcations group by city
),cte2 as (
select sum(amount) as only_weekend, city from credit_card_transcations
where WEEKDAY(STR_TO_DATE(date, '%d-%b-%y')) IN (5, 6) 
group by city
), cte3 as (
select c1.city, round((only_weekend/all_week)*100,2) as max_spend_in_weekend from cte c1 
inner join cte2 c2 on c1.city = c2.city) 
select * from cte3 where max_spend_in_weekend in (select max(max_spend_in_weekend) from cte3)
order by max_spend_in_weekend desc;

-- 10- which city took least number of days to reach its 500th transaction after the first transaction in that city

with cte_initial as (
select *,str_to_date(date,'%d-%b-%y') as date_format from credit_card_transcations
), cte as 
(select *,
row_number() over(partition by city order by date_format,ind) as rn 
from cte_initial)
select c1.city,c1.date,c2.date,str_to_date(c1.date,'%d-%b-%y') as first_transaction,
str_to_date(c2.date,'%d-%b-%y') as five_hun_transaction,
datediff(str_to_date(c2.date,'%d-%b-%y'),str_to_date(c1.date,'%d-%b-%y')) as date_difference  from cte c1
inner join cte c2 on c1.city = c2.city where c1.rn = 1 and c2.rn=500
order by date_difference limit 1;


