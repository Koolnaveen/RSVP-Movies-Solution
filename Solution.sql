USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
	table_name, table_rows
FROM 
	INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA ='imdb';
    
    -- CONCLUSION:-
-- DIRECTOR MAPPING TOTAL_NUMBER_OF_ROWS :- 3867
-- GENRE TOTAL_NUMBER_OF_ROWS :- 14662
-- MOVIE TOTAL_NUMBER_OF_ROWS :- 7997
-- NAMES TOTAL_NUMBER_OF_ROWS :-  25735
-- RATINGS TOTAL_NUMBER_OF_ROWS :-  7997
-- ROLE_MAPPING TOTAL_NUMBER_OF_ROWS :-  15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END ) id_null,
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END )  title_null,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END )  year_null,
	SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END )  date_published_null,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END )  duration_null,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END )  country_null,
	SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END )  worldwide_gross_income_null,
	SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END )  languages_null,
	SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END )  production_null
FROM movie;

-- CONCLUSION
-- COLUMN HAVING NULL VALUES:
           -- COUNTRY
           -- WORLWIDE_GROSS_INCOME
           -- LANGUAGES
           -- PRODUCTION_COMPANY

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
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

-- YEAR WISE MOVIES

SELECT  
	year, count(id)  number_of_movies
FROM 
	movie
GROUP BY year
ORDER by year;

-- CONCLUSION  
    -- MOST NUMBER OF MOVIES ARE RELEASED IN YEAR 2017 AROUND 3052
    --  LEAST NUMBER OF MOVIES ARE RELEASED IN YEAR 2019 AROUND 2001

-- MONTH WISE MOVIES
SELECT 
	month(date_published) month_num, count(id) number_of_movies
FROM 
	movie
GROUP BY 
	month(date_published) 
ORDER BY 
	1 ;
 
 -- CONCLUSION  
-- MARCH HAS THE HIGHEST NUMBER OF MOVIES  FOLLOWED BY SEPTEMBER AND  JANNUARY 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
		count(distinct id)  number_of_movies, year
	FROM 
		movie 
	WHERE 
		year=2019 and (country LIKE '%India%' OR country LIKE '%USA%');

-- CONCLUSION 
-- 1059 MOVIES IS THE EXACT NUMBER WERE PRODUCED IN THE USA OR INDIA IN THE YEAR 2019 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
	DISTINCT genre
FROM
	genre
ORDER BY 
	genre;

-- CONCLUSION 
       -- MOVIES BELONG TO 13 GENRES ARE MENTIONED IN THE DATASET.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
	genre, count(movie_id)  number_of_movies
FROM
	genre
GROUP BY 
	genre
ORDER BY
	2 desc
LIMIT 1;

-- CONCLUSION 
	-- DRAMA HAS THE HIGHEST NUMBER OF MOVIES FOLLOWED BY COMEDY AND TRILLER 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT 
	SUM(cnt_genre) single_genre_movies
FROM (
		SELECT 
			COUNT(genre) cnt_genre, movie_id
		FROM
			genre
		GROUP BY 
			movie_id
		HAVING
			COUNT(DISTINCT genre)=1
) AS genre_cnt;

-- CONCLUSION 
	-- 3289 IS THE EXACT NUMBER OF MOVIES HAS ONLY ONE GENRE

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
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
	genre, ROUND(AVG(duration),2) avg_duration
FROM
	movie m
INNER JOIN
	genre g
ON
	m.id=g.movie_id
GROUP BY
	genre
ORDER BY 2 DESC;

/* CONCLUSION:-
	-- AVERAGE DURATION OF MOVIES IN EACH GENRE:
	Action, 112.88
	Romance, 109.53
	Crime, 107.05
	Drama, 106.77
	Fantasy, 105.14
	Comedy, 102.62
	Adventure, 101.87
	Mystery, 101.80
	Thriller, 101.58
	Family, 100.97
	Others, 100.16
	Sci-Fi, 97.94
	Horror, 92.72
*/

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

SELECT *
FROM (
    SELECT
        genre,
        COUNT(movie_id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
    FROM
        genre g
    GROUP BY
        genre
) AS subquery
WHERE genre = 'thriller';


-- CONCLUSION:- 
	-- Thriller has the movie count of 1484 with 3  rank .

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
	MIN(avg_rating) min_avg_rating,
    MAX(avg_rating) max_avg_rating,
    MIN(total_votes) min_total_votes,
    MAX(total_votes) max_total_votes,
    MIN(median_rating) min_median_rating,
    MAX(median_rating) max_median_rating
FROM
	ratings;
	
-- CONCLUSION 
-- MINIMUM VALUE FOR AVERAGE RATING IS 1 AND MAXIMUM IS 10
-- FOR TOTAL VOTES MINIMUM VALUE IS 100 AND MAXIMUM IS 725138
-- MINIMUM VALUE FOR MEDIAN RATING IS 1 AND MAXIMUM IS 10	

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
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

SELECT
	title, avg_rating, DENSE_RANK() OVER(ORDER BY avg_rating DESC) movie_rank
FROM
	movie m
INNER JOIN
	ratings r
ON 
	m.id=r.movie_id
LIMIT 10;

-- CONCLUSION:- 
	-- KIRKET AND LOVE IN KILNERRY HAVE THE HIGHEST RATING OF 10 ARE AT 1ST RANK FOLLWED BY GINI HELIDA KATHE AND RUNAM WITH SECOND AND THRIRD RANK*
    -- AND YES WE FOUND THE MOVIE FAN WITH TOP AVG_RATING 9.6

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
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

SELECT 
	median_rating, COUNT(movie_id) movie_count
FROM
	ratings
GROUP BY 
	median_rating
ORDER by COUNT(movie_id) DESC;

-- CONCLUSION  
        -- MOVIE OF MEDIAN RATING 7 IS THE HIGHEST WITH MOVIE COUNT OF 2257.

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

WITH prod_comp AS(
	SELECT 
		production_company, COUNT(id) movie_count, DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) prod_company_rank
	FROM
		movie m
	INNER JOIN
		ratings  r
	ON
		m.id=r.movie_id
	WHERE 
		avg_rating>8 AND production_company IS NOT NULL
	GROUP BY production_company
)
SELECT * FROM prod_comp WHERE prod_company_rank = 1;

-- CONCLUSION
	-- 'DREAM WARRIOR PICTURES' AND NATIONAL THEATRE AS PRODUCED THE MOST NUMBER OF HIT MOVIES WITH AVERAGE RATING GREATER THAN 8 .

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

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

SELECT 
	genre, COUNT(g.movie_id) movie_count
FROM
	genre g
INNER JOIN
	movie m ON m.id=g.movie_id
INNER JOIN 
	ratings r ON m.id=r.movie_id
WHERE 
	country LIKE '%USA%' AND YEAR(date_published)=2017 AND MONTH(date_published)=3 AND total_votes>=1000
GROUP BY 
	genre
ORDER BY COUNT(g.movie_id) DESC;

-- CONSLUSION  
	-- DRAMA HAS THE HIGHEST MOVIE_COUNT IN 2017 AND IN THE MONTH OF MARCH AND WITH MORE THAN 1000 VOTES

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

SELECT 
	title, avg_rating, genre
FROM
	genre g
INNER JOIN
	movie m ON m.id=g.movie_id
INNER JOIN 
	ratings r ON m.id=r.movie_id
WHERE 
	avg_rating>8 AND title like 'The%'
ORDER BY 
	avg_rating DESC;

-- CONCLUSION 
	-- DRAMA GENRE HAS THE HIGHEST AVG_RATING OF 9.5 WHICH STARTS WITH THE LETTER  "THE"

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	median_rating, COUNT(id) movie_count
FROM
	ratings r
INNER JOIN 
	movie m
ON
	m.id=r.movie_id
WHERE
	date_published between '2018-04-01' AND '2019-04-01' AND median_rating=8;

-- CONCLUSION 
	-- MOVIES WITH RATING 8 FROM APRIL 2018 TO APRIL 2019 ARE 361.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes AS (
	SELECT 
		SUM(total_votes) total_votes, languages
	FROM
		movie m
	INNER JOIN
		ratings r
	ON 
		m.id=r.movie_id
	WHERE 
		languages LIKE '%Italian%' OR languages LIKE '%German%'
	GROUP BY 
		languages
)
SELECT SUM(total_votes) total_votes, 'German' languages
FROM votes WHERE languages LIKE '%German%'
UNION
SELECT SUM(total_votes) total_votes, 'Italian' languages
FROM votes WHERE languages LIKE '%Italian%';

-- CONCLUSION
	-- SINCE WE HAVE CHECKED USING BOTH LANGUAGES  IN THIS  CASE, WE CAN  CONCLUDE THAT GERMANY HAS MORE VOTES THAN ITALY.

-- Answer is Yes

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
	SUM(CASE WHEN n.name IS NULL THEN 1 ELSE 0 END) name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) known_for_movies_nulls
FROM
	names n;

-- CONCLUSION 
	-- TOTAL NUMBER OF NULLS IN NAME COLUMN IS 0
    -- TOTAL NUMBER OF NULLS IN HEIGHT COLUMN IS 17335 
    -- TOTAL NUMBER OF NULLS IN DATE_OF_BIRTH COLUMN IS 13431
    -- TOTAL NUMBER OF NULLS IN KNOWN_FOR_MOVIES COLUMN IS 15226    

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

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


WITH genre_final AS(
	/* GET TOP 3 GENRE */
	WITH genre_at_top AS(
		SELECT 
			genre, COUNT(id) movie_count, RANK() OVER(ORDER BY COUNT(id) DESC) genre_rank
		FROM 
			movie m
		INNER JOIN ratings r ON r.movie_id=m.id
		INNER JOIN genre g ON g.movie_id=m.id
		WHERE avg_rating>8
		GROUP BY genre
	)
	SELECT genre
	FROM genre_at_top
	WHERE genre_rank<4
)
,
/*GET top directors */
directors_at_top AS (
	SELECT n.name director_name, COUNT(dm.movie_id) AS movie_count, RANK() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS director_rank
		FROM names AS n 
		INNER JOIN director_mapping AS dm ON n.id=dm.name_id 
		INNER JOIN genre AS g ON dm.movie_id=g.movie_id 
		INNER JOIN ratings r ON r.movie_id= g.movie_id,
		genre_final
		WHERE g.genre IN (genre_final.genre) AND avg_rating>8
		GROUP BY director_name
		ORDER BY movie_count DESC
)
SELECT director_name, movie_count
FROM directors_at_top
WHERE director_rank<=3;

-- CONCLUSION 
	-- JAMES MANGOLD HAS THE MOST NUMBER OF MOVIE COUNT WITH AVERAGE MOVIE RATING OF ABOVE 8 
    -- FOLLOWED BY ANTHONY RUSSO 3 AND JOE RUSSO 3

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
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

SELECT
	name actor_name, COUNT(r.movie_id) movie_count
FROM
	ratings r 
INNER JOIN 	
	role_mapping rm 
USING
	(movie_id)
INNER JOIN 
	names n
ON 
	n.id=rm.name_id
WHERE 
	median_rating>=8 AND category='actor'
GROUP BY 
	name
ORDER BY
	movie_count DESC
LIMIT 2;

-- CONCLUSION 
	-- MAMMOOTTY IS AMONG THE TOP ACTOR WITH MOVIE COUNT OF 8 AND MEDIAN RATING >= 8
    -- FOLLOWED BY MOHANLAL WITH MOVIE_COUNT 5

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
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

SELECT
	production_company, SUM(total_votes) votes_count, DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) rank_prod_comp
FROM
	movie m
INNER JOIN
	ratings r
ON 
	m.id=r.movie_id
GROUP BY
	production_company
LIMIT 3;

 -- CONCLUSION
	-- MARVEL STUDIOS AMONG THE TOP PRODUCTION COMPANY WITH TOTAL VOTE COUNT OF 2656967 
	-- FOLLOWED BY TWENTIETH CENTURY FOX 2411163 AND WARNER BROS. 2396057

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

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

SELECT
	name actor_name, SUM(total_votes) total_votes, COUNT(m.id) movie_count, 
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)  actor_avg_rating,  
    RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) actor_rank
FROM
	movie m
INNER JOIN
	ratings r
ON
	m.id=r.movie_id
INNER JOIN 
	role_mapping rm
ON 
	m.id=rm.movie_id
INNER JOIN
	names n
ON 
	rm.name_id=n.id
WHERE
	category='actor' and country='india'
GROUP BY
	name
HAVING COUNT(m.id)>=5;

-- CONCLUSION
	-- Vijay Sethupathi is among top actor in India with actor average rating of 8.42 and total votes of 23115

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


SELECT
	name actress_name, SUM(total_votes) total_votes, COUNT(m.id) movie_count, 
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)  actress_avg_rating,  
    RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) actress_rank
FROM
	movie m
INNER JOIN
	ratings r
ON
	m.id=r.movie_id
INNER JOIN 
	role_mapping rm
ON 
	m.id=rm.movie_id
INNER JOIN
	names n
ON 
	rm.name_id=n.id
WHERE
	UPPER(category) = 'ACTRESS' AND UPPER(country) = 'INDIA' AND UPPER(languages) LIKE '%HINDI%'
GROUP BY
	name
HAVING COUNT(m.id)>=3
LIMIT 5;

-- CONCLUSION 
	-- TAPSEE PANNU IS AMONG TOP ACTRESS IN INDIA  WITH HINDI LANGUAGE AND ACTRESS AVERAGE RATING OF 7.74 AND TOTAL VOTES OF 18061

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
	title,
	avg_rating,
	CASE
	 WHEN avg_rating > 8 THEN "superhit movies"
	 WHEN avg_rating BETWEEN 7 AND 8 THEN "hit movies"
	 WHEN avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
	 WHEN avg_rating < 5 THEN "flop movies"
	END AS movie_category
FROM   
	movie m
JOIN 
	genre g
ON 
	m.id = g.movie_id
JOIN 
	ratings r
ON 
	m.id = r.movie_id
WHERE  
	genre = 'Thriller'; 

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

SELECT 
		genre,
		ROUND(AVG(duration),2) avg_duration,
        ROUND(SUM(AVG(duration)) OVER (ORDER BY genre),2) running_total_duration,
        ROUND(AVG(AVG(duration)) OVER (ORDER BY genre),2) moving_average_duration
FROM 
	movie m
JOIN 
	genre g
ON 
	g.movie_id=m.id
JOIN
	ratings r 
ON 
	g.movie_id=r.movie_id
GROUP BY 
	genre
ORDER BY genre;

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
-- I assume that the conversion here from INR to $ is not expected to be don ehere. 
-- So, replaced all INR with $ and added the logic on the final number

WITH top_3_genre AS(
	SELECT 
		genre, COUNT(movie_id) movie_count
	FROM 
		genre
	GROUP BY 
		genre
	ORDER BY 
		movie_count DESC
	LIMIT 3
),
Top AS (
	SELECT 
		g.genre,
		m.year,
		m.title movie_name,
		CONCAT('$', CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10))) AS worldwide_gross_income,
		DENSE_RANK () OVER ( PARTITION BY year ORDER BY CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) DESC) AS movie_rank
	FROM 
		movie m 
	INNER JOIN 
		genre g 		
	ON 
		m.id = g.movie_id
	INNER JOIN
		top_3_genre tm
	ON 
		g.genre=tm.genre
	WHERE 
		worlwide_gross_income IS NOT NULL
)
SELECT 
	*
FROM
	Top
WHERE 
	movie_rank <= 5
ORDER BY 
	year, movie_rank;



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
WITH prod AS(
SELECT 
	production_company, 
	COUNT(m.id) movie_count,
	RANK() OVER(ORDER BY COUNT(id) DESC) prod_comp_rank
FROM 
	movie m 
INNER JOIN 
	ratings r 
ON 
	m.id=r.movie_id
WHERE 
	median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company)
SELECT *
FROM 
	prod
WHERE 
	prod_comp_rank<3;
/* Output format:    
  


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

WITH top_3_actress AS (
	SELECT 
		n.name actress_name, sum(r.total_votes) total_votes, count(r.movie_id) movie_count, 
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) actress_avg_rating
	FROM
		names n 
	INNER JOIN 
		role_mapping rm 
	ON 
		n.id = rm.name_id 
	INNER JOIN 
		ratings r 
	ON
		r.movie_id = rm.movie_id
	INNER JOIN
		genre g 
	ON 
		g.movie_id = r.movie_id
	WHERE 
		avg_rating > 8 AND category = 'actress' AND genre = 'drama' 
	GROUP BY
		name
)
SELECT 
	*, RANK() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM
	top_3_actress 
LIMIT 3 ;

-- CONCLUSION :-
			-- TOP 3 ACTRESSES BASED ON NUMBER OF SUPER HIT MOVIES PARVATHY THIRUVOTHU, SUSAN BROWN, AMANDA LAWRENCE

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

WITH top_directors AS
(
	SELECT 
		name_id director_id, name director_name, dir.movie_id, duration,
	    avg_rating, total_votes , (avg_rating * total_votes) rating_votes, date_published,
        LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY date_published, name)  next_publish_date
	FROM 
		director_mapping dir
	INNER JOIN 
		names n 
	ON 
		dir.name_id = n.id
	INNER JOIN 
		movie mov 
	ON 
		dir.movie_id = mov.id 
	INNER JOIN 
		ratings rt 
	ON 
		mov.id = rt.movie_id
)
SELECT 
	director_id, director_name,
    COUNT(movie_id) AS number_of_movies,
	ROUND(SUM(DATEDIFF(Next_publish_date, date_published))/(COUNT(movie_id)-1)) AS avg_inter_movie_days,
	CAST(SUM(rating_votes)/SUM(total_votes)AS DECIMAL(4,2)) AS avg_rating,
	SUM(total_votes) AS total_votes, MIN(avg_rating) AS min_rating, MAX(avg_Rating) AS max_rating,
	SUM(duration) AS total_duration
FROM 
	top_directors
GROUP BY 
	director_id
ORDER BY 
	number_of_movies DESC, avg_rating DESC, total_duration DESC
LIMIT 9;
										
/*-- CONCLUSION 
	-- THE TOP 9 DIRECTORS WHO HAVE THE HIGHEST NUMBER OF MOVIES ARE:
		A.L. VIJAY
		ANDREW JONES
		STEVEN SODERBERGH
		SAM LIU
		SION SONO
		JESSE V. JOHNSON
		JUSTIN PRICE
		CHRIS STOKES
		OZGUR BAKAR
/*


-- THE END -- 





