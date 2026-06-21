use yelp_data_analysis;
rename table yelp_data to yelp;
select * from yelp;

# Which are the top 10 most reviewed businesses?;

select organization ,sum(numberreview) as numberreviews
from yelp
group by organization
order by numberreviews desc 
limit 10;

# Which categories have the highest number of businesses?

select category , count(organization) as organizations
from yelp 
group by category 
order by organizations desc 
limit 10;

# Which categories receive the highest average ratings?
select category, round(avg(rating),1) as avg_rating
from yelp 
group by category 
order by avg_rating desc 
limit 3;

# Which categories generate the most customer reviews?
select category , sum(numberreview) as cus_review
from yelp 
group by category
order by cus_review desc 
limit 1;

# Which cities have the largest number of businesses listed?
select city , count(organization) as org
from yelp
group by city 
order by org desc 
limit 3;

# Which states have the highest concentration of businesses?
select state , count(organization) as org
from yelp
group by state 
order by org desc 
limit 3; 

# Which cities have the highest average business ratings?
select city , avg(rating) as avg_rating 
from yelp
group by city 
order by avg_rating desc
limit 2;

SELECT city,
       ROUND(AVG(rating),2) AS avg_rating
FROM yelp
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY avg_rating DESC
LIMIT 10;
# Which states have the highest average business ratings?
 
# Is there a relationship between ratings and number of reviews?
select  
	case
		when rating >=0 and rating<=2.5 then "poor review"
        when rating >2.5 and rating<= 3.5 then "good review"
        when rating > 3.5 and rating<= 5 then "excellent review"
        End as review_rating ,
	sum(numberreview) as total_review
from yelp
group by review_rating 
order by total_review desc ;

        
# Which businesses have high ratings but relatively few reviews (hidden gems)?

	select organization, max(rating) as ratings , sum(numberreview) as total_review 
	from yelp
    group by organization 
	having ratings > 4.5 and 
    total_review <= (select round(avg(numberreview),2 )as numberreviews from yelp)
	order by total_review asc;

# Which businesses have many reviews but low ratings (customer satisfaction issues)?

 select organization , min(rating ) as ratings, sum( numberreview) avg_review
 from yelp
 group by organization
 having ratings <2.5 
 and avg_review >= (select avg(numberreview) from yelp)
order by avg_review desc
limit 10;

# What percentage of businesses have ratings above 4.0?
select count(organization), count(organization) * 100 / (select count(organization) from yelp) as percentage_of_bussiness 
from yelp
where rating > 4


# Which city contributes the highest share of total reviews?

select city , sum(numberreview) as total_review
from yelp
group by city 
order by (total_review) desc
limit 3;



# Which category dominates in each state?

SELECT state,
       category,
       total_businesses
FROM (
    SELECT state,
           category,
           COUNT(organization) AS total_businesses,
           ROW_NUMBER() OVER (
               PARTITION BY state
               ORDER BY COUNT(*) DESC
           ) AS rn
    FROM yelp
    GROUP BY state, category
) t
WHERE rn = 1;



# Which business category shows the best combination of high ratings and high review volume?

select category ,round( avg(rating),2) as avg_rating , sum(numberreview) as total_review
from yelp
group by category
order by avg_rating desc , total_review desc
