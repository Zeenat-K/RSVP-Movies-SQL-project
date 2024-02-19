USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) AS movie_row_count FROM movie;
SELECT COUNT(*) AS genre_row_count FROM genre;
SELECT COUNT(*) AS director_mapping_row_count FROM director_mapping;
SELECT COUNT(*) AS names_row_count FROM names;
SELECT COUNT(*) AS ratings_row_count FROM ratings;
SELECT COUNT(*) AS role_mapping_row_count FROM role_mapping;

-- Total number of rows in movie table : 7997
-- Total number of rows in genre table : 14662
-- Total number of rows in director_mapping table : 3867
-- Total number of rows in names table : 25735
-- Total number of rows in ratings table : 7997
-- Total number of rows in role_mapping table : 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    (COUNT(*) - COUNT(id)) AS id_null_count,
    (COUNT(*) - COUNT(title)) AS title_null_count,
    (COUNT(*) - COUNT(year)) AS year_null_count,
    (COUNT(*) - COUNT(date_published)) AS date_published_null_count,
    (COUNT(*) - COUNT(duration)) AS duration_null_count,
    (COUNT(*) - COUNT(country)) AS country_null_count,
    (COUNT(*) - COUNT(worlwide_gross_income)) AS worlwide_gross_income_null_count,
    (COUNT(*) - COUNT(languages)) AS languages_null_count,
    (COUNT(*) - COUNT(production_company)) AS production_company_null_count
FROM
    movie;
    
-- Columns with Null Values in movie table - country, worldwide_gross_income,languages and production_company.

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- First part solution
SELECT 
    year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year
ORDER BY year;

/* The number of movies has decreased over years from 2017 to 2019 */

-- Second part solution
SELECT
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

-- The lowest number of movies are published in month of December .
-- The highest number of movies is produced in the month of March.


-- Let's dig in some more into the movies table..
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(ID) AS TOTAL_MOVIES
FROM
    MOVIE
WHERE
    COUNTRY LIKE '%INDIA%'
        OR COUNTRY LIKE '%USA%' AND YEAR = 2019;

-- 1818 movies were produced in USA / India in the year 2019.

-- Let's explore the various genres*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    GENRE
FROM
    GENRE;

-- There are 13 unique genres present in the genre table.

/* Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM genre AS g
	INNER JOIN movie AS m 
		ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 1;

-- Drama had the highest number of movies produced overall

/* Based on the above analysis, RSVP Movies should focus on the ‘Drama’ genre. 
However, a movie can belong to two or more genres. So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre_movies
     AS (SELECT movie_id,
                Count(genre)
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT Count(*)
FROM   single_genre_movies; 

-- Number of movies belong to only one genre : 3289

/* There are more than three thousand movies which has only one genre associated with them.

Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    ROUND(AVG(duration),2) AS avg_duration
FROM movie AS m
	INNER JOIN genre AS g 
		ON m.id = g.movie_id
GROUP BY g.genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_summary AS 
(
SELECT genre,COUNT(movie_id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT * FROM genre_rank_summary
WHERE genre = "Thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies


-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 


/* Since, the minimum and maximum values in each column of the ratings table are in the expected range, it implies there are no outliers in the table. 

Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rank_on_rating
     AS (SELECT title,
                avg_rating,
                Row_number()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   rank_on_rating
WHERE  movie_rank BETWEEN 1 AND 10; 



/* So, now that we know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating; 


/* Movies with a median rating of 7 is highest in number. 

Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Count(id)                            AS movie_count,
           Rank() over(ORDER BY count(id) DESC) AS prod_company_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      avg_rating > 8
AND        production_company IS NOT NULL
GROUP BY   production_company
ORDER BY   movie_count DESC
LIMIT      2 ;
		
-- Dream warrior Pictures and National Theatre Live had produced highest rated films.


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Count(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  Month(date_published) = 3
       AND country = "usa"
       AND total_votes > 1000
GROUP  BY genre; 

-- Looks like Drama is the highest grossing when it comes to votes.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  title REGEXP "^the"
       AND avg_rating > 8
ORDER  BY avg_rating DESC;  



-- We should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(id) AS movies_with_median_8,
       median_rating
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  date_published BETWEEN "2018-04-01" AND "2019-04-01"
       AND median_rating = 8
GROUP  BY median_rating; 


-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country,
       Sum(total_votes) AS TOTAL_VOTES
FROM   movie M
       INNER JOIN ratings R
               ON M.id = R.movie_id
WHERE  country IN ( "germany", "italy" )
GROUP  BY country; 

-- Yes, German movies get more votes than Italian movies.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0
		END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0
		END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0
		END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0
		END) AS known_for_movies_nulls
FROM
    names;

-- Columns height, date_of_birth and known_for_movies have null values in names column.
-- There are no Null value in the column 'name'.



/*Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_genre
AS
(
SELECT
g.genre,
COUNT(g.movie_id) as movie_count
FROM genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
WHERE avg_rating>8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top_director
AS
(
SELECT
n.name as director_name,
COUNT(d.movie_id) as movie_count,
RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM names n
INNER JOIN director_mapping d
ON n.id = d.name_id
INNER JOIN ratings r
ON r.movie_id = d.movie_id
INNER JOIN genre g
ON g.movie_id = d.movie_id,
top_genre
WHERE r.avg_rating > 8 AND g.genre IN (top_genre.genre)
GROUP BY n.name
ORDER BY movie_count DESC
)
SELECT director_name,
movie_count
FROM top_director
WHERE director_rank <= 3
LIMIT 3;

/* James Mangold, Soubin Shahir and Joe Russo can be hired as the director for RSVP's upcoming projects. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH actor_ranking_summary AS
(
	SELECT 
		n.name AS actor_name,
		COUNT(rm.movie_id) AS movie_count,
        DENSE_RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actor_rankings
	FROM names AS n
		INNER JOIN role_mapping AS rm
			ON n.id = rm.name_id
		INNER JOIN ratings AS r
			ON r.movie_id = rm.movie_id
	WHERE median_rating >=8
	GROUP BY n.name
)
SELECT 
	actor_name,
    movie_count
FROM actor_ranking_summary
WHERE actor_rankings <=2;

-- Top 2 actors are 'Mammootty' and 'Mohanlal'.

/*RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_companies
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Dense_rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie M
                INNER JOIN ratings R
                        ON M.id = R.movie_id
         GROUP  BY production_company)
SELECT *
FROM   top_production_companies
WHERE  prod_comp_rank <= 3 ;

-- Top 3 production companies are Marvel Studios, Twentieth Century Fox, Warner Bros.


/*These are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT name AS actor_name, total_votes,
                COUNT(m.id) as movie_count,
                ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
                RANK() OVER(ORDER BY avg_rating DESC) AS actor_rank
FROM names AS n
	INNER JOIN role_mapping AS rm
		ON n.id = rm.name_id
	INNER JOIN ratings AS r
		ON r.movie_id = rm.movie_id
	INNER JOIN movie AS m
		ON m.id = r.movie_id
WHERE country like "%India%" AND category ="actor"
GROUP BY n.name
HAVING COUNT(r.movie_id) >=5;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_rank_summary AS
(
SELECT 
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes) / SUM(total_votes),2) AS actress_avg_rating,
    DENSE_RANK() 
		OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(total_votes),2) DESC,r.total_votes DESC) 
			AS actress_rank
FROM names AS n
	INNER JOIN role_mapping AS rm
		ON n.id = rm.name_id
	INNER JOIN ratings AS r
		ON r.movie_id = rm.movie_id
	INNER JOIN movie AS m
		ON m.id = r.movie_id
WHERE 
	country like "%India%" 
    AND category ="actress" 
    AND languages like '%hindi%'
GROUP BY n.name
HAVING COUNT(r.movie_id) >=3
)
SELECT * FROM actress_rank_summary
WHERE actress_rank <=5 ;


/* Taapsee Pannu tops with average rating 7.74. Kriti Sanon and Shraddha Kapoor follow close (Please note that even though Shraddha Kapoor ranks 4th, she has higher no. of votes) */

-- Now let us divide all the thriller movies in the following categories and find out their numbers.

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT
	title AS movie_name_thriller,
(
	CASE
		 WHEN avg_rating > 8 THEN "Superhit movies"
		 WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
		 WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
		 ELSE "Flop movies"
	END
) 		 AS avg_rating_classification
			
FROM movie AS m
	INNER JOIN ratings AS r
		ON m.id = r.movie_id
	INNER JOIN genre AS g
		ON g.movie_id = r.movie_id
WHERE g.genre = "Thriller";


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH movies_avg_duration
AS
  (
             SELECT     genre,
                        round(avg(duration),2) AS avg_duration
             FROM       genre g
             INNER JOIN movie m
             ON         g.movie_id = m.id
             GROUP BY   genre
             ORDER BY   avg_duration DESC)
  SELECT   *,
           sum(avg_duration) over w          AS running_total_duration,
           round(avg(avg_duration) over w,2) AS moving_avg_duration
  FROM     movies_avg_duration window w      AS (ORDER BY avg_duration rows unbounded preceding) ;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genres
AS
  (
           SELECT   genre,
                    count(movie_id) AS movie_count
           FROM     genre
           GROUP BY genre
           ORDER BY movie_count DESC
           LIMIT    3)
  ,
  movie_gross_income
AS
  (
             SELECT     genre,
                        year,
                        title                                                                    AS movie_name,
                        worlwide_gross_income                                                    AS worldwide_gross_income,
                        dense_rank() over(partition BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
             FROM       genre g
             INNER JOIN movie m
             ON         g.movie_id = m.id
             WHERE      genre IN
                        (
                               SELECT genre
                               FROM   top_3_genres) )
  SELECT *
  FROM   movie_gross_income
  WHERE  movie_rank BETWEEN 1 AND    5 ;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_company_rank
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                Rank()
                  over(
                    ORDER BY Count(id) DESC) AS prod_comp_rank
         FROM   movie m
                inner join ratings r
                        ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position("," IN languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   prod_company_rank
WHERE  prod_comp_rank BETWEEN 1 AND 2; 


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH rank_actress
     AS (SELECT NAME                                 AS actress_name,
                Sum(total_votes)                     AS total_votes,
                Count(r.movie_id)                    AS movie_count,
                Round(Avg(avg_rating))               AS actress_avg_rating,
                Row_number()
                  OVER(
                    ORDER BY Count(r.movie_id) DESC) AS actress_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN ratings r
                        ON rm.movie_id = r.movie_id
                INNER JOIN genre g
                        ON r.movie_id = g.movie_id
         WHERE  category = "actress"
                AND genre = "drama"
         GROUP  BY actress_name)
SELECT *
FROM   rank_actress
WHERE  actress_rank BETWEEN 1 AND 3; 


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_details
AS
  (
             SELECT     dm.name_id,
                        n.name,
                        dm.movie_id,
                        m.date_published,
                        lead(date_published,1) over(partition BY name ORDER BY m.date_published,dm.movie_id) AS date_published_next,
                        r.avg_rating,
                        r.total_votes,
                        m.duration
             FROM       director_mapping dm
             INNER JOIN names n
             ON         dm.name_id = n.id
             INNER JOIN movie m
             ON         dm.movie_id = m.id
             INNER JOIN ratings r
             ON         m.id = r.movie_id),
  director_details_new
AS
  (
         SELECT *,
                datediff(date_published_next,date_published) AS inter_movie_days
         FROM   director_details)
  SELECT   name_id                        AS director_id,
           name                           AS director_name,
           count(movie_id)                AS no_of_movies,
           round(avg(inter_movie_days),2) AS avg_inter_movie_days,
           round(avg(avg_rating),2)       AS avg_rating,
           sum(total_votes)               AS total_votes,
           min(avg_rating)                AS min_rating,
           max(avg_rating)                AS max_rating,
           sum(duration)                  AS total_duration
  FROM     director_details_new
  GROUP BY director_id
  ORDER BY count(movie_id) DESC
  LIMIT    9;

-- This concludes our Case Study