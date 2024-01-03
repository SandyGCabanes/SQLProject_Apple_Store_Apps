-- AppleStore dataset from Kaggle https://www.kaggle.com/datasets/leandrojnr/applestore-database

create table applestore_description_combined as

Select * From appleStore_description1
UNION ALL
Select * From appleStore_description2
UNION ALL
Select * From appleStore_description3
UNION ALL
Select * From appleStore_description4

-- check the number of unique apps in both data tables   
select count (distinct id) as UniqueAppIDs
From AppleStore
-- 7197

select count (distinct id) as UniqueAppIDs
From applestore_description_combined
-- 7197 Conclusion: No missing data

-- check for any missing values in some of the key fields   
select count(*) as MissingValues
From AppleStore
Where track_name is null or user_rating is null or prime_genre is NULL
-- 0 Conclusion: No missing values in these columns

select count(*) as MissingValues
From applestore_description_combined
Where track_name is null or app_desc is NULL
-- 0 Conclusion: No missing values in these as well  

select prime_genre, count(*) as AppsPerGenre
From AppleStore
Group by prime_genre
Order by AppsPerGenre DESC

-- get an overview of the apps' ratings
select min(user_rating) as MinRating,
       max(user_rating) AS MaxRating,
       avg(user_rating) as AvgRating
from AppleStore
-- MinRating 0, MaxRating 5, AvgRating 3.52695567597AppleStore

** Data Analysis **
-- determine whether paid apps have higher rating than free apps   

select case 
	when price > 0 then 'paid'
	else 'free'
    end as App_type,
    Avg(user_rating) as AvgUserRating
from AppleStore
Group by App_type
-- free 3.3767  paid 3.7209 Conclusion: Paid apps are rated slightly higherAppleStore

-- check if apps that support more languages have higher ratings   

select case
	when lang_num < 10 then '<10' 
    when lang_num between 10 and 20 then 'bet 10 and 20' 
    when lang_num between 20 and 30 then 'bet 20 and 30' 
    when lang_num >30 then '> 30' 
    end as Num_lang_supported,
    count (lang_num) as count_apps_lang,
    ROUND(Avg(user_rating), 2)as AvgRating
from AppleStore
Group by Num_lang_supported
Order by AvgRating DESC

--Num_lang_supported	count_lang	AvgRating
--bet 10 and 20		1200		4.15
--bet 20 and 30		206		4.02
--> 30			171		3.78
--<10			5620		3.37
-- Conclusion: The more languages supported > 10, the higher the rating
-- suggesting limited reach as a barrier to positive rating


-- check opportunities by genre using ratings

select prime_genre,
		ROUND(Avg(user_rating), 2)as AvgRating,
		count(*) as AppsPerGenre
FROM AppleStore
Group by prime_genre
Order by AvgRating
-- Conclusion: Seems like there are opportunities in the smaller genres        

-- does size of the genre have an impact on ratings

select prime_genre,
		count(prime_genre) as size_of_genre,
        Avg(user_rating) as AvgRating
FROM AppleStore
Group by prime_genre
Order by AvgRating, size_of_genre  
-- Yes, bigger genres tend have higher ratings except for games, which is an outlier

-- does length of app description matter   

SELECT CASE
	WHEN length(b.app_desc) < 500 then 'short'
    WHEN length(b.app_desc) BETWEEN 500 and 1000 THEN 'medium'
    ELSE 'long'
    END AS description_length_bucket,
    ROUND(Avg(a.user_rating),2) as AvgRating
FROM AppleStore as a
JOIN applestore_description_combined as b
	on a.id = b.id
Group by description_length_bucket
ORDER BY AvgRating

--description_length_bucket	AvgRating
--short	2.533613445
--medium	3.23280943
--long	3.855946945
-- Conclusion:  Longer description may encourage higher engagement

--** TOP RATED APPS PER CATEGORY ***

SELECT prime_genre,
		track_name,
        user_rating
FROM  (  
		SELECT 
  		prime_genre,
		track_name,
        user_rating,
  		RANK () OVER (PARTITION BY prime_genre ORDER BY user_rating DESC , rating_count_tot DESC) as RANK
  		FROM AppleStore
  	   ) as A
WHERE A.rank = 1




