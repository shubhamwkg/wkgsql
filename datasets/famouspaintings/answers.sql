
SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum;
SELECT * FROM museum_hours;
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;


-- PROBLEM 1: Fetch all the paintings 
-- which are not displayed on any museums?

SELECT COUNT(*) FROM work
WHERE museum_id IS NULL

-- ANSWER : there are 10223 paintings without museums


-- PROBLEM 2: Are there museuems without any 
-- paintings?

SELECT work_id, name
FROM work
WHERE work_id IS NULL

-- ANSWER : NO 

-- PROBLEM 3: How many paintings have 
-- an asking price of more than their regular price? 

SELECT COUNT(*)
FROM product_size
WHERE sale_price > regular_price

--ANSWER : Zero

-- PROBLEM 4: Identify the paintings whose 
-- asking price is less than 50% of its regular price

SELECT COUNT(*)
FROM product_size
WHERE ((regular_price * 1.0) /2) < sale_price

-- ANSWER: 110289 paintings


-- PROBLEM 5: Which canva size costs the most?

SELECT cs.label AS canvas, ps.sale_price
FROM (
    SELECT *,
           RANK() OVER(ORDER BY sale_price DESC) AS rnk 
    FROM product_size
) ps
JOIN canvas_size cs ON cs.size_id::TEXT = ps.size_id
WHERE ps.rnk = 1;

-- ANSWER -- 48" x 96"(122 cm x 244 cm) This size


-- PROBLEM 6 : Delete duplicate records from work, 
-- product_size, subject and image_link tables

DELETE FROM work 
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM work
    GROUP BY work_id
);


DELETE FROM product_size 
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM product_size
    GROUP BY work_id, size_id
);

DELETE FROM subject 
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM subject
    GROUP BY work_id, subject
);

DELETE FROM image_link 
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM image_link
    GROUP BY work_id
);

-- Duplicates removed



-- PROBLEM 7:  Identify the museums with invalid city 
-- information in the given dataset

SELECT * 
FROM museum 
WHERE city ~ '^[0-9]'

-- ANSWER : there are 6 museums with invalid city name


-- PROBLEM 8 : Museum_Hours table has 1 invalid entry. 
-- Identify it and remove it.
DELETE FROM museum_hours 
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM museum_hours
    GROUP BY museum_id, day
);



--PROBLEM 9: Fetch the top 10 most famous painting subject

SELECT * 
FROM (
    SELECT s.subject,
           COUNT(1) AS no_of_paintings,
           RANK() OVER(ORDER BY COUNT(1) DESC) AS ranking
    FROM subject s
    GROUP BY s.subject
) x
WHERE ranking <= 10


-- PROBLEM 10 : Identify the museums which are open
-- on both Sunday and Monday. Display museum name, city.

SELECT m.name AS museum_name, m.city AS city
FROM museum m
JOIN museum_hours mh ON m.museum_id = mh.museum_id
WHERE mh.day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city

-- 11) How many museums are open every single day?

SELECT COUNT(1)
FROM (SELECT museum_id, COUNT(1)
        FROM museum_hours
        GROUP BY museum_id
        HAVING COUNT(1) = 7)
-- ANSWER 17

-- PROBLEM 12 :Which are the top 5 most popular museum? 
-- (Popularity is defined based on most no of paintings 
-- in a museum)

SELECT w.museum_id ,m.name, m.city, COUNT(1) AS number_of_paintings
FROM work w JOIN museum m ON w.museum_id = m.museum_id
WHERE w.museum_id IS NOT NULL 
GROUP BY w.museum_id, m.name, m.city
ORDER BY COUNT(1) DESC
LIMIT 5


-- PROBLEM 13 : Who are the top 5 most popular artist? 
-- (Popularity is defined based on most no of 
-- paintings done by an artist)

SELECT w.artist_id,a.full_name, a.style, COUNT(1) AS no_of_paintings
FROM
    work w JOIN artist a 
    ON w.artist_id = a.artist_id
WHERE w.artist_id IS NOT NULL
GROUP BY w.artist_id, a.full_name, a.style
ORDER BY COUNT(1) DESC
LIMIT 5


-- PROBLEM 14 : Display the 3 least popular canva sizes

SELECT
    p.size_id, c.label, COUNT(1) as number_of_paintings
FROM
    product_size p JOIN canvas_size c 
    ON p.size_id = c.size_id::TEXT
GROUP BY p.size_id, c.label
ORDER BY COUNT(1)
LIMIT 3



-- PROBLEM 15 : Which museum is open for the longest 
-- during a day. 
-- Dispay museum name, state and hours open and which day?

SELECT museum_name,
       state AS city,
       day, 
       open, 
       close, 
       duration
FROM (
    SELECT m.name AS museum_name, 
           m.state, 
           day, 
           open, 
           close,
           TO_TIMESTAMP(open,'HH:MI AM'),
           TO_TIMESTAMP(close,'HH:MI PM'),
           TO_TIMESTAMP(close,'HH:MI PM') - TO_TIMESTAMP(open,'HH:MI AM') AS duration,
           RANK() OVER (ORDER BY (TO_TIMESTAMP(close,'HH:MI PM') - TO_TIMESTAMP(open,'HH:MI AM')) DESC) AS rnk
    FROM museum_hours mh
    JOIN museum m ON m.museum_id = mh.museum_id
) x
WHERE x.rnk = 1;

-- PROBLEM 16 : Which museum has the most no of 
-- most popular painting style?
SELECT w.style, m.museum_id, m.name, COUNT(1)
FROM work w JOIN museum m ON w.museum_id = m.museum_id
WHERE w.museum_id IS NOT NULL
GROUP BY style, m.museum_id, m.name
ORDER BY COUNT(1) DESC
LIMIT 1

-- PROBLEM 17 Identify the artists whose paintings 
-- are displayed in multiple countries
SELECT a.artist_id, a.full_name, COUNT(DISTINCT m.country)
FROM
    artist a JOIN work w ON a.artist_id = w.artist_id
    JOIN museum m ON w.museum_id = m.museum_id
WHERE w.work_id IS NOT NULL
GROUP BY a.artist_id, a.full_name
HAVING COUNT(DISTINCT m.country)>1
ORDER BY COUNT(DISTINCT m.country) DESC

WITH cte AS (
    SELECT DISTINCT a.full_name AS artist,
                    m.country
    FROM work w
    JOIN artist a ON a.artist_id = w.artist_id
    JOIN museum m ON m.museum_id = w.museum_id
)
SELECT artist,
       COUNT(1) AS no_of_countries
FROM cte
GROUP BY artist
HAVING COUNT(1) > 1
ORDER BY 2 DESC;



-- PROBLEM 18 : Display the country and the city 
-- with most no of museums.
-- Output 2 seperate columns to mention the city and country. 
-- If there are multiple value, seperate them with comma.


WITH cte_country AS (
    SELECT country, 
           COUNT(1),
           RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM museum
    GROUP BY country
),
cte_city AS (
    SELECT city, 
           COUNT(1),
           RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM museum
    GROUP BY city
)
SELECT STRING_AGG(DISTINCT country.country, ', '), 
       STRING_AGG(city.city, ', ')
FROM cte_country country
CROSS JOIN cte_city city
WHERE country.rnk = 1
AND city.rnk = 1;

-- PROBLEM 19 : Identify the artist and the museum 
-- where the most expensive and least expensive 
-- painting is placed. 
-- Display the artist name, sale_price, 
-- painting name, museum name, museum city and canvas label

WITH cte AS (
    SELECT *,
           RANK() OVER(ORDER BY sale_price DESC) AS rnk,
           RANK() OVER(ORDER BY sale_price) AS rnk_asc
    FROM product_size
)
SELECT w.name AS painting,
       cte.sale_price,
       a.full_name AS artist,
       m.name AS museum, 
       m.city,
       cz.label AS canvas
FROM cte
JOIN work w ON w.work_id = cte.work_id
JOIN museum m ON m.museum_id = w.museum_id
JOIN artist a ON a.artist_id = w.artist_id
JOIN canvas_size cz ON cz.size_id = cte.size_id::NUMERIC
WHERE rnk = 1 OR rnk_asc = 1;

-- PROBLEM 20 : Which country has the 5th highest 
-- no of paintings?

SELECT cte.country, no_of_paintings
FROM
(SELECT m.country, COUNT(1) as no_of_paintings, RANK() OVER(ORDER BY (COUNT(1)) DESC) AS rnk
FROM work w JOIN museum m ON w.museum_id = m.museum_id
GROUP BY m.country) cte
WHERE rnk = 5

WITH cte AS (
    SELECT m.country, 
           COUNT(1) AS no_of_paintings,
           RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM work w
    JOIN museum m ON m.museum_id = w.museum_id
    GROUP BY m.country
)
SELECT country, 
       no_of_paintings
FROM cte 
WHERE rnk = 5;

-- PROBLEM 21 : Which are the 3 most popular 
-- and 3 least popular painting styles?

SELECT style, CASE WHEN rnk_desc <= 3 THEN 'Most Popular' ELSE 'Least Popular' END AS remarks 
FROM (SELECT style, COUNT(1),
        RANK() OVER(ORDER BY COUNT(1)) AS rnk_asc,
        RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk_desc
        FROM work 
        WHERE style IS NOT NULL
        GROUP BY style)
WHERE rnk_asc <= 3 OR rnk_desc <= 3

WITH cte AS (
    SELECT style, 
           COUNT(1) AS cnt,
           RANK() OVER(ORDER BY COUNT(1) DESC) rnk,
           COUNT(1) OVER() AS no_of_records
    FROM work
    WHERE style IS NOT NULL
    GROUP BY style
)
SELECT style,
       CASE WHEN rnk <= 3 THEN 'Most Popular' ELSE 'Least Popular' END AS remarks 
FROM cte
WHERE rnk <= 3
OR rnk > no_of_records - 3;


-- PROBLEM 22 : Which artist has the most no of Portraits 
-- paintings outside USA?. Display artist name, 
-- no of paintings and the artist nationality.

SELECT cte.full_name, cte.nationality, COUNT(1) 
FROM (SELECT a.full_name, a.nationality
        FROM work w JOIN museum m ON w.museum_id = m.museum_id
        JOIN artist a ON w.artist_id = a.artist_id
        JOIN subject s ON w.work_id = s.work_id
        WHERE m.country NOT IN ('USA')
        AND s.subject IN ('Portraits')) cte
GROUP BY cte.full_name, cte.nationality
ORDER BY COUNT(1) DESC
FETCH FIRST 1 ROWS WITH TIES

SELECT full_name AS artist_name, 
       nationality, 
       no_of_paintings
FROM (
    SELECT a.full_name, 
           a.nationality,
           COUNT(1) AS no_of_paintings,
           RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
    FROM work w
    JOIN artist a ON a.artist_id = w.artist_id
    JOIN subject s ON s.work_id = w.work_id
    JOIN museum m ON m.museum_id = w.museum_id
    WHERE s.subject = 'Portraits'
    AND m.country != 'USA'
    GROUP BY a.full_name, a.nationality
) x
WHERE rnk = 1;

