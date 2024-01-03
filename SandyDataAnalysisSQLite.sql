-- These are additional questions not in the original guided SQL project

/*For the preliminary database creation and table creation, as well as
preliminary data exploration, e.g., null values, missing values, 
number of unique apps, see the GuidedSQL file.
*/

**DEEPER DATA ANALYSIS**

-- What are all the apps with 5.0 user_ratings for each of the top 5 prime_genres
-- with higher average ratings. Recall that the top prime_genres with high 
-- average ratings are: productivity, music, photo & video, business, health & fitness

-- free apps with user rating = 5 in top 5 categories
Select prime_genre, track_name, user_rating, price
From AppleStore
Where prime_genre in ('Health & Fitness', 'Business', 'Photo & Video', 'Music', 'Productivity')
and user_rating = 5
and price = 0
Order By prime_genre


-- paid apps with user rating = 5 in top 5 categories
Select prime_genre, track_name, user_rating, price
From AppleStore
Where prime_genre in ('Health & Fitness', 'Business', 'Photo & Video', 'Music', 'Productivity')
and user_rating = 5
and price > 0
Order By prime_genre, price DESC

-- apps with user rating = 5 in 'Games' category
Select prime_genre, track_name, user_rating, price
From AppleStore
Where prime_genre in ('Games')
and user_rating = 5
Order By price DESC


-- apps with prices greater than 10
Select prime_genre, track_name, price
From AppleStore
Where price > 10
and prime_genre in ('Health & Fitness', 'Business', 'Photo & Video', 'Music', 'Productivity')
Order By prime_genre, price DESC

-- games that have prices greater than 10 and their cont_rating
Select prime_genre, track_name, price, cont_rating
From AppleStore
Where price > 10
and prime_genre = 'Games'
Order By price DESC, cont_rating DESC

-- games that are the most expensive and have a rating of 5
With CTE_Ranking as
(
Select prime_genre, track_name, user_rating, price,
   Rank() OVER (PARTITION BY prime_genre ORDER BY price DESC) AS Ranking
From AppleStore
Where user_rating = 5
and price > 0
)
SELECT *
FROM CTE_Ranking
Where Ranking < 5
Order By prime_genre, price DESC


