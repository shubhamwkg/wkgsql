-- =====================================================
-- SQL SERVER COMPLETE LEARNING PRACTICE FILE
-- Based on WiseOwl Tutorial Series
-- =====================================================

-- =====================================================
-- SECTION 1: DATABASE SETUP
-- =====================================================

-- Create database
CREATE DATABASE MovieDatabase;
GO

-- Use the database
USE MovieDatabase;
GO

-- =====================================================
-- SECTION 2: CREATE TABLES || E
-- =====================================================

-- Create Directors table
CREATE TABLE Directors (
    DirectorID INT IDENTITY(1,1) PRIMARY KEY,
    DirectorName VARCHAR(100) NOT NULL,
    BirthYear INT,
    BirthDate DATE
);

-- Create Countries table
CREATE TABLE Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName VARCHAR(50) NOT NULL
);

-- Create Films table
CREATE TABLE Films (
    FilmID INT IDENTITY(1,1) PRIMARY KEY,
    FilmName VARCHAR(100) NOT NULL,
    DirectorID INT,
    ReleaseYear INT,
    ReleaseDate DATE,
    RuntimeMinutes INT,
    BoxOffice DECIMAL(15,2),
    Budget DECIMAL(15,2),
    OscarWins INT DEFAULT 0,
    FOREIGN KEY (DirectorID) REFERENCES Directors(DirectorID)
);

-- Create FilmCountries junction table
CREATE TABLE FilmCountries (
    FilmID INT,
    CountryID INT,
    PRIMARY KEY (FilmID, CountryID),
    FOREIGN KEY (FilmID) REFERENCES Films(FilmID),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

-- Create Actors table (for string manipulation examples)
CREATE TABLE Actors (
    ActorID INT IDENTITY(1,1) PRIMARY KEY,
    ActorName VARCHAR(100) NOT NULL,
    BirthDate DATE
);

-- Create FilmActors junction table
CREATE TABLE FilmActors (
    FilmID INT,
    ActorID INT,
    RoleName VARCHAR(100),
    PRIMARY KEY (FilmID, ActorID),
    FOREIGN KEY (FilmID) REFERENCES Films(FilmID),
    FOREIGN KEY (ActorID) REFERENCES Actors(ActorID)
);

-- =====================================================
-- SECTION 3: INSERT SAMPLE DATA || E
-- =====================================================

-- Insert Directors
INSERT INTO Directors (DirectorName, BirthYear, BirthDate) VALUES
('Christopher Nolan', 1970, '1970-07-30'),
('Wachowski Sisters', 1965, '1965-06-21'),
('Steven Spielberg', 1946, '1946-12-18'),
('Quentin Tarantino', 1963, '1963-03-27'),
('Martin Scorsese', 1942, '1942-11-17'),
('David Fincher', 1962, '1962-08-28'),
('Ridley Scott', 1937, '1937-11-30'),
('James Cameron', 1954, '1954-08-16'),
('George Lucas', 1944, '1944-05-14'),
('Denis Villeneuve', 1967, '1967-10-03');

-- Insert Countries
INSERT INTO Countries (CountryName) VALUES
('USA'),
('UK'),
('Canada'),
('France'),
('Germany'),
('Japan'),
('Australia'),
('New Zealand');

-- Insert Films
INSERT INTO Films (FilmName, DirectorID, ReleaseYear, ReleaseDate, RuntimeMinutes, BoxOffice, Budget, OscarWins) VALUES
('The Matrix', 2, 1999, '1999-03-31', 136, 467500000.00, 63000000.00, 4),
('Inception', 1, 2010, '2010-07-16', 148, 836800000.00, 160000000.00, 4),
('Interstellar', 1, 2014, '2014-11-07', 169, 677400000.00, 165000000.00, 1),
('The Dark Knight', 1, 2008, '2008-07-18', 152, 1004900000.00, 185000000.00, 2),
('Pulp Fiction', 4, 1994, '1994-10-14', 154, 214200000.00, 8000000.00, 1),
('Fight Club', 6, 1999, '1999-10-15', 139, 100900000.00, 63000000.00, 0),
('The Shawshank Redemption', NULL, 1994, '1994-09-23', 142, 16000000.00, 25000000.00, 0),
('Goodfellas', 5, 1990, '1990-09-19', 146, 46800000.00, 25000000.00, 1),
('Taxi Driver', 5, 1976, '1976-02-08', 114, 28300000.00, 1300000.00, 0),
('Blade Runner', 7, 1982, '1982-06-25', 117, 33800000.00, 28000000.00, 0),
('Alien', 7, 1979, '1979-05-25', 117, 104900000.00, 11000000.00, 1),
('Titanic', 8, 1997, '1997-12-19', 195, 2200000000.00, 200000000.00, 11),
('Avatar', 8, 2009, '2009-12-18', 162, 2923700000.00, 237000000.00, 3),
('Star Wars: A New Hope', 9, 1977, '1977-05-25', 121, 775400000.00, 11000000.00, 7),
('Dune', 10, 2021, '2021-10-22', 155, 401800000.00, 165000000.00, 6),
('Arrival', 10, 2016, '2016-11-11', 116, 203400000.00, 47000000.00, 1),
('The Matrix Reloaded', 2, 2003, '2003-05-15', 138, 742100000.00, 150000000.00, 0),
('The Matrix Revolutions', 2, 2003, '2003-11-05', 129, 427300000.00, 150000000.00, 0),
('Dunkirk', 1, 2017, '2017-07-21', 106, 527000000.00, 100000000.00, 3),
('Se7en', 6, 1995, '1995-09-22', 127, 327300000.00, 33000000.00, 0);

-- Insert Actors
INSERT INTO Actors (ActorName, BirthDate) VALUES
('Keanu Reeves', '1964-09-02'),
('Leonardo DiCaprio', '1974-11-11'),
('Christian Bale', '1974-01-30'),
('Matthew McConaughey', '1969-11-04'),
('John Travolta', '1954-02-18'),
('Edward Norton', '1969-08-18'),
('Robert De Niro', '1943-08-17'),
('Harrison Ford', '1942-07-13'),
('Sigourney Weaver', '1949-10-08'),
('Mark Hamill', '1951-09-25'),
('Timothee Chalamet', '1995-12-27'),
('Amy Adams', '1974-08-20');

-- Insert FilmCountries relationships
INSERT INTO FilmCountries (FilmID, CountryID) VALUES
(1, 1), (1, 2), -- The Matrix: USA, UK
(2, 1), (2, 2), -- Inception: USA, UK
(3, 1), (3, 2), -- Interstellar: USA, UK
(4, 1), (4, 2), -- The Dark Knight: USA, UK
(5, 1), -- Pulp Fiction: USA
(6, 1), -- Fight Club: USA
(7, 1), -- The Shawshank Redemption: USA
(8, 1), -- Goodfellas: USA
(9, 1), -- Taxi Driver: USA
(10, 1), (10, 2), -- Blade Runner: USA, UK
(11, 1), (11, 2), -- Alien: USA, UK
(12, 1), -- Titanic: USA
(13, 1), -- Avatar: USA
(14, 1), -- Star Wars: USA
(15, 1), (15, 3), -- Dune: USA, Canada
(16, 1), -- Arrival: USA
(17, 1), -- The Matrix Reloaded: USA
(18, 1), -- The Matrix Revolutions: USA
(19, 1), (19, 2), (19, 4), -- Dunkirk: USA, UK, France
(20, 1); -- Se7en: USA

-- Insert FilmActors relationships
INSERT INTO FilmActors (FilmID, ActorID, RoleName) VALUES
(1, 1, 'Neo'),
(2, 2, 'Dom Cobb'),
(3, 4, 'Cooper'),
(4, 3, 'Batman'),
(5, 5, 'Vincent Vega'),
(6, 6, 'Narrator'),
(8, 7, 'Henry Hill'),
(9, 7, 'Travis Bickle'),
(10, 8, 'Rick Deckard'),
(11, 9, 'Ellen Ripley'),
(14, 10, 'Luke Skywalker'),
(15, 11, 'Paul Atreides'),
(16, 12, 'Louise Banks');

-- =====================================================
-- SECTION 4: PRACTICE QUERIES
-- Run these queries one by one to practice each concept
-- =====================================================

-- =====================================================
-- 4.1: BASIC QUERIES (SELECT and FROM) || E
-- =====================================================

-- Practice 1: Basic SELECT
-- Get all film names and release years
SELECT FilmName, ReleaseYear
FROM Films;

-- Practice 2: Select all columns
SELECT *
FROM Films;

-- Practice 3: Select specific columns with database context
USE MovieDatabase;
SELECT FilmName, DirectorID, RuntimeMinutes
FROM Films;

-- =====================================================
-- 4.2: ALIASES || E
-- =====================================================

-- Practice 4: Simple aliases
SELECT 
    FilmName AS Title,
    ReleaseYear AS Year,
    RuntimeMinutes AS Duration
FROM Films;

-- Practice 5: Aliases with spaces
SELECT 
    FilmName AS 'Movie Title',
    ReleaseYear AS [Release Year],
    RuntimeMinutes AS 'Duration (Minutes)'
FROM Films;

-- Practice 6: Aliases without AS keyword
SELECT 
    FilmName Title,
    ReleaseYear Year,
    RuntimeMinutes Duration
FROM Films;

-- =====================================================
-- 4.3: SORTING (ORDER BY)|| E
-- =====================================================

-- Practice 7: Basic sorting (ascending)
SELECT FilmName, ReleaseYear
FROM Films
ORDER BY ReleaseYear;

-- Practice 8: Descending sort
SELECT FilmName, ReleaseYear
FROM Films
ORDER BY ReleaseYear DESC;

-- Practice 9: Multiple column sorting
SELECT FilmName, ReleaseYear, RuntimeMinutes
FROM Films
ORDER BY ReleaseYear DESC, FilmName ASC;

-- Practice 10: Sort by alias
SELECT 
    FilmName AS Title,
    BoxOffice - Budget AS Profit
FROM Films
ORDER BY Profit DESC;

-- Practice 11: Sort by non-displayed column
SELECT FilmName, ReleaseYear
FROM Films
ORDER BY OscarWins DESC;

-- Practice 12: TOP clause
SELECT TOP 5 FilmName, RuntimeMinutes
FROM Films
ORDER BY RuntimeMinutes DESC;

-- Practice 13: TOP with TIES
SELECT TOP 5 WITH TIES FilmName, OscarWins
FROM Films
ORDER BY OscarWins DESC;

-- =====================================================
-- 4.4: FILTERING (WHERE) ||
-- =====================================================

-- Practice 14: Number criteria - Equality
SELECT FilmName, RuntimeMinutes
FROM Films
WHERE RuntimeMinutes = 120;

-- Practice 15: Number criteria - Comparison
SELECT FilmName, RuntimeMinutes
FROM Films
WHERE RuntimeMinutes > 150;

-- Practice 16: BETWEEN operator
SELECT FilmName, RuntimeMinutes
FROM Films
WHERE RuntimeMinutes BETWEEN 120 AND 150;

-- Practice 17: IN operator
SELECT FilmName, RuntimeMinutes
FROM Films
WHERE RuntimeMinutes IN (117, 136, 148);

-- Practice 18: Text criteria - Exact match
SELECT FilmName, ReleaseYear
FROM Films
WHERE FilmName = 'The Matrix';

-- Practice 19: LIKE with wildcards - starts with
SELECT FilmName, ReleaseYear
FROM Films
WHERE FilmName LIKE 'The%';

-- Practice 20: LIKE with wildcards - contains
SELECT FilmName, ReleaseYear
FROM Films
WHERE FilmName LIKE '%Matrix%';

-- Practice 21: LIKE with single character wildcard
SELECT FilmName
FROM Films
WHERE FilmName LIKE 'The Matrix_________';

-- Practice 22: NOT LIKE
SELECT FilmName, ReleaseYear
FROM Films
WHERE FilmName NOT LIKE '%The%';

-- Practice 23: Date criteria
SELECT FilmName, ReleaseDate
FROM Films
WHERE ReleaseDate > '2010-01-01';

-- Practice 24: Date functions in WHERE
SELECT FilmName, ReleaseDate
FROM Films
WHERE YEAR(ReleaseDate) = 1999;

SELECT FilmName, ReleaseDate
FROM Films
WHERE MONTH(ReleaseDate) = 7;

-- Practice 25: AND operator
SELECT FilmName, ReleaseYear, RuntimeMinutes
FROM Films
WHERE ReleaseYear > 2000 AND RuntimeMinutes > 140;

-- Practice 26: OR operator
SELECT FilmName, ReleaseYear
FROM Films
WHERE ReleaseYear = 1999 OR ReleaseYear = 2010;

-- Practice 27: Complex criteria with parentheses
SELECT FilmName, ReleaseYear, RuntimeMinutes, OscarWins
FROM Films
WHERE (ReleaseYear > 2000 AND RuntimeMinutes > 150) OR OscarWins > 5;

-- =====================================================
-- 4.5: CALCULATED COLUMNS
-- =====================================================

-- Practice 28: Basic calculation
SELECT 
    FilmName,
    BoxOffice,
    Budget,
    BoxOffice - Budget AS Profit
FROM Films;

-- Practice 29: Multiple calculations
SELECT 
    FilmName,
    RuntimeMinutes,
    RuntimeMinutes + 30 AS WithTrailers,
    RuntimeMinutes - 10 AS WithoutCredits,
    RuntimeMinutes * 2 AS DoubleFeature,
    RuntimeMinutes / 60.0 AS Hours,
    RuntimeMinutes % 60 AS MinutesRemainder
FROM Films;

-- Practice 30: Data type considerations
SELECT 
    FilmName,
    RuntimeMinutes,
    RuntimeMinutes / 60 AS HoursInteger,    -- Integer result
    RuntimeMinutes / 60.0 AS HoursDecimal   -- Decimal result
FROM Films;

-- Practice 31: Calculations in WHERE clause
SELECT 
    FilmName,
    BoxOffice - Budget AS Profit
FROM Films
WHERE (BoxOffice - Budget) > 500000000; -- $500M+ profit

-- Practice 32: ROI calculation
SELECT 
    FilmName,
    BoxOffice,
    Budget,
    ((BoxOffice - Budget) / Budget) * 100 AS ROI_Percentage
FROM Films
WHERE Budget > 0;

-- =====================================================
-- 4.6: CASE EXPRESSIONS
-- =====================================================

-- Practice 33: CASE with numbers
SELECT 
    FilmName,
    RuntimeMinutes,
    CASE
        WHEN RuntimeMinutes < 90 THEN 'Short'
        WHEN RuntimeMinutes < 120 THEN 'Medium'
        WHEN RuntimeMinutes < 180 THEN 'Long'
        ELSE 'Epic'
    END AS Category
FROM Films;

-- Practice 34: CASE with text patterns
SELECT 
    FilmName,
    CASE
        WHEN FilmName LIKE '%Matrix%' THEN 'Matrix Franchise'
        WHEN FilmName LIKE '%Star Wars%' THEN 'Star Wars Franchise'
        WHEN FilmName LIKE '%Dark Knight%' THEN 'Batman Franchise'
        ELSE 'Standalone'
    END AS Franchise
FROM Films;

-- Practice 35: CASE with dates
SELECT 
    FilmName,
    ReleaseYear,
    CASE
        WHEN ReleaseYear < 1980 THEN 'Classic Era'
        WHEN ReleaseYear < 2000 THEN 'Modern Era'
        ELSE 'Digital Age'
    END AS Era
FROM Films;

-- Practice 36: CASE for Oscar categories
SELECT 
    FilmName,
    OscarWins,
    CASE
        WHEN OscarWins = 0 THEN 'No Wins'
        WHEN OscarWins BETWEEN 1 AND 3 THEN 'Award Winner'
        WHEN OscarWins BETWEEN 4 AND 6 THEN 'Multiple Winner'
        ELSE 'Oscar Dominator'
    END AS AwardStatus
FROM Films;

-- Practice 37: Using CASE in WHERE
SELECT 
    FilmName,
    RuntimeMinutes,
    CASE
        WHEN RuntimeMinutes < 120 THEN 'Short'
        ELSE 'Long'
    END AS Length
FROM Films
WHERE CASE
        WHEN RuntimeMinutes < 120 THEN 'Short'
        ELSE 'Long'
    END = 'Long';

-- =====================================================
-- 4.7: JOINS
-- =====================================================

-- Practice 38: INNER JOIN
SELECT 
    F.FilmName,
    F.ReleaseYear,
    D.DirectorName
FROM Films AS F
INNER JOIN Directors AS D ON F.DirectorID = D.DirectorID;

-- Practice 39: LEFT OUTER JOIN
SELECT 
    F.FilmName,
    F.ReleaseYear,
    D.DirectorName
FROM Films AS F
LEFT OUTER JOIN Directors AS D ON F.DirectorID = D.DirectorID;

-- Practice 40: Find films without directors
SELECT 
    F.FilmName,
    F.ReleaseYear
FROM Films AS F
LEFT OUTER JOIN Directors AS D ON F.DirectorID = D.DirectorID
WHERE D.DirectorID IS NULL;

-- Practice 41: RIGHT OUTER JOIN
SELECT 
    F.FilmName,
    D.DirectorName
FROM Films AS F
RIGHT OUTER JOIN Directors AS D ON F.DirectorID = D.DirectorID;

-- Practice 42: Find directors without films
SELECT 
    D.DirectorName,
    D.BirthYear
FROM Films AS F
RIGHT OUTER JOIN Directors AS D ON F.DirectorID = D.DirectorID
WHERE F.FilmID IS NULL;

-- Practice 43: Multiple table joins
SELECT 
    F.FilmName,
    D.DirectorName,
    C.CountryName
FROM Films AS F
INNER JOIN Directors AS D ON F.DirectorID = D.DirectorID
INNER JOIN FilmCountries AS FC ON F.FilmID = FC.FilmID
INNER JOIN Countries AS C ON FC.CountryID = C.CountryID;

-- Practice 44: Join with calculations
SELECT 
    F.FilmName,
    D.DirectorName,
    F.BoxOffice - F.Budget AS Profit,
    CASE
        WHEN (F.BoxOffice - F.Budget) > 500000000 THEN 'Blockbuster'
        WHEN (F.BoxOffice - F.Budget) > 100000000 THEN 'Hit'
        WHEN (F.BoxOffice - F.Budget) > 0 THEN 'Profitable'
        ELSE 'Loss'
    END AS Success
FROM Films AS F
INNER JOIN Directors AS D ON F.DirectorID = D.DirectorID;

-- =====================================================
-- 4.8: FUNCTIONS
-- =====================================================

-- Practice 45: String functions
SELECT 
    FilmName,
    UPPER(FilmName) AS UpperCase,
    LOWER(FilmName) AS LowerCase,
    LEN(FilmName) AS NameLength,
    LEFT(FilmName, 5) AS FirstFiveChars,
    RIGHT(FilmName, 5) AS LastFiveChars
FROM Films;

-- Practice 46: String concatenation
SELECT 
    FilmName + ' (' + CAST(ReleaseYear AS VARCHAR(4)) + ')' AS FilmWithYear
FROM Films;

-- Practice 47: String search functions
SELECT 
    ActorName,
    CHARINDEX(' ', ActorName) AS SpacePosition,
    LEFT(ActorName, CHARINDEX(' ', ActorName) - 1) AS FirstName,
    RIGHT(ActorName, LEN(ActorName) - CHARINDEX(' ', ActorName)) AS LastName
FROM Actors;

-- Practice 48: Date functions
SELECT 
    FilmName,
    ReleaseDate,
    YEAR(ReleaseDate) AS ReleaseYear,
    MONTH(ReleaseDate) AS ReleaseMonth,
    DAY(ReleaseDate) AS ReleaseDay,
    DATENAME(month, ReleaseDate) AS MonthName,
    DATENAME(weekday, ReleaseDate) AS DayName
FROM Films;

-- Practice 49: Date calculations
SELECT 
    FilmName,
    ReleaseDate,
    DATEDIFF(day, ReleaseDate, GETDATE()) AS DaysOld,
    DATEDIFF(year, ReleaseDate, GETDATE()) AS YearsOld,
    GETDATE() AS Today
FROM Films;

-- Practice 50: Date formatting
SELECT 
    FilmName,
    ReleaseDate,
    CONVERT(VARCHAR(10), ReleaseDate, 103) AS UKFormat,    -- DD/MM/YYYY
    CONVERT(VARCHAR(10), ReleaseDate, 101) AS USFormat,    -- MM/DD/YYYY
    DATENAME(weekday, ReleaseDate) + ' ' + 
    DATENAME(day, ReleaseDate) + ' ' + 
    DATENAME(month, ReleaseDate) + ' ' + 
    DATENAME(year, ReleaseDate) AS CustomFormat
FROM Films;

-- Practice 51: Accurate age calculation
SELECT 
    D.DirectorName,
    D.BirthDate,
    DATEDIFF(year, D.BirthDate, GETDATE()) AS SimpleAge,
    CASE
        WHEN DATEADD(year, DATEDIFF(year, D.BirthDate, GETDATE()), D.BirthDate) > GETDATE()
        THEN DATEDIFF(year, D.BirthDate, GETDATE()) - 1
        ELSE DATEDIFF(year, D.BirthDate, GETDATE())
    END AS AccurateAge
FROM Directors;

-- =====================================================
-- 4.9: GROUPING AND AGGREGATION
-- =====================================================

-- Practice 52: Basic aggregate functions
SELECT 
    COUNT(*) AS TotalFilms,
    AVG(RuntimeMinutes) AS AverageRuntime,
    MIN(ReleaseYear) AS OldestFilm,
    MAX(ReleaseYear) AS NewestFilm,
    SUM(CAST(BoxOffice AS BIGINT)) AS TotalBoxOffice
FROM Films;

-- Practice 53: GROUP BY single column
SELECT 
    ReleaseYear,
    COUNT(*) AS FilmCount,
    AVG(RuntimeMinutes) AS AvgRuntime,
    SUM(CAST(BoxOffice AS BIGINT)) AS YearlyBoxOffice
FROM Films
GROUP BY ReleaseYear
ORDER BY ReleaseYear;

-- Practice 54: GROUP BY with joins
SELECT 
    D.DirectorName,
    COUNT(*) AS FilmCount,
    AVG(F.RuntimeMinutes) AS AvgRuntime,
    MAX(F.OscarWins) AS MostOscars
FROM Films F
INNER JOIN Directors D ON F.DirectorID = D.DirectorID
GROUP BY D.DirectorName
ORDER BY FilmCount DESC;

-- Practice 55: GROUP BY multiple columns
SELECT 
    D.DirectorName,
    (F.ReleaseYear / 10) * 10 AS Decade,
    COUNT(*) AS FilmCount,
    AVG(F.RuntimeMinutes) AS AvgRuntime
FROM Films F
INNER JOIN Directors D ON F.DirectorID = D.DirectorID
GROUP BY D.DirectorName, (F.ReleaseYear / 10) * 10
ORDER BY D.DirectorName, Decade;

-- Practice 56: HAVING clause
SELECT 
    ReleaseYear,
    COUNT(*) AS FilmCount,
    AVG(RuntimeMinutes) AS AvgRuntime
FROM Films
GROUP BY ReleaseYear
HAVING COUNT(*) > 1  -- Years with more than 1 film
ORDER BY ReleaseYear;

-- Practice 57: HAVING with complex conditions
SELECT 
    D.DirectorName,
    COUNT(*) AS FilmCount,
    AVG(F.RuntimeMinutes) AS AvgRuntime,
    SUM(CAST(F.BoxOffice AS BIGINT)) AS TotalBoxOffice
FROM Films F
INNER JOIN Directors D ON F.DirectorID = D.DirectorID
GROUP BY D.DirectorName
HAVING COUNT(*) >= 2 AND AVG(F.RuntimeMinutes) > 120
ORDER BY TotalBoxOffice DESC;

-- Practice 58: WITH ROLLUP
SELECT 
    ISNULL(CAST(ReleaseYear AS VARCHAR(10)), 'Grand Total') AS Year,
    COUNT(*) AS FilmCount,
    SUM(CAST(BoxOffice AS BIGINT)) AS TotalBoxOffice
FROM Films
GROUP BY ReleaseYear WITH ROLLUP
ORDER BY ReleaseYear;

-- Practice 59: Complex grouping with CASE
SELECT 
    CASE
        WHEN ReleaseYear < 1980 THEN '1970s and Earlier'
        WHEN ReleaseYear < 1990 THEN '1980s'
        WHEN ReleaseYear < 2000 THEN '1990s'
        WHEN ReleaseYear < 2010 THEN '2000s'
        ELSE '2010s and Later'
    END AS Decade,
    COUNT(*) AS FilmCount,
    AVG(RuntimeMinutes) AS AvgRuntime,
    AVG(OscarWins) AS AvgOscars
FROM Films
GROUP BY 
    CASE
        WHEN ReleaseYear < 1980 THEN '1970s and Earlier'
        WHEN ReleaseYear < 1990 THEN '1980s'
        WHEN ReleaseYear < 2000 THEN '1990s'
        WHEN ReleaseYear < 2010 THEN '2000s'
        ELSE '2010s and Later'
    END
ORDER BY MIN(ReleaseYear);

-- =====================================================
-- 4.10: SUBQUERIES
-- =====================================================

-- Practice 60: Simple subquery in WHERE
SELECT FilmName, OscarWins
FROM Films
WHERE OscarWins = (SELECT MAX(OscarWins) FROM Films);

-- Practice 61: Subquery with comparison
SELECT FilmName, RuntimeMinutes
FROM Films
WHERE RuntimeMinutes > (SELECT AVG(RuntimeMinutes) FROM Films);

-- Practice 62: Subquery with IN
SELECT FilmName, ReleaseYear
FROM Films
WHERE DirectorID IN (
    SELECT DirectorID 
    FROM Directors 
    WHERE BirthYear BETWEEN 1960 AND 1980
);

-- Practice 63: Subquery in SELECT list
SELECT 
    FilmName,
    RuntimeMinutes,
    (SELECT AVG(RuntimeMinutes) FROM Films) AS OverallAverage,
    RuntimeMinutes - (SELECT AVG(RuntimeMinutes) FROM Films) AS DifferenceFromAvg
FROM Films;

-- Practice 64: Multiple subqueries
SELECT 
    FilmName,
    BoxOffice,
    Budget,
    CASE
        WHEN BoxOffice > (SELECT AVG(BoxOffice) FROM Films) THEN 'Above Average'
        ELSE 'Below Average'
    END AS BoxOfficePerformance,
    CASE
        WHEN Budget > (SELECT AVG(Budget) FROM Films) THEN 'High Budget'
        ELSE 'Low Budget'
    END AS BudgetCategory
FROM Films;

-- Practice 65: Subquery with joins
SELECT 
    F.FilmName,
    D.DirectorName,
    F.OscarWins
FROM Films F
INNER JOIN Directors D ON F.DirectorID = D.DirectorID
WHERE F.OscarWins > (
    SELECT AVG(OscarWins) 
    FROM Films 
    WHERE DirectorID IS NOT NULL
);

-- =====================================================
-- 4.11: CORRELATED SUBQUERIES
-- =====================================================

-- Practice 66: Basic correlated subquery
SELECT 
    F1.FilmName,
    D.DirectorName,
    F1.RuntimeMinutes
FROM Films F1
INNER JOIN Directors D ON F1.DirectorID = D.DirectorID
WHERE F1.RuntimeMinutes = (
    SELECT MAX(F2.RuntimeMinutes)
    FROM Films F2
    WHERE F2.DirectorID = F1.DirectorID
);

-- Practice 67: Films above average for their director
SELECT 
    F1.FilmName,
    D.DirectorName,
    F1.RuntimeMinutes,
    (
        SELECT AVG(F2.RuntimeMinutes)
        FROM Films F2
        WHERE F2.DirectorID = F1.DirectorID
    ) AS DirectorAvgRuntime
FROM Films F1
INNER JOIN Directors D ON F1.DirectorID = D.DirectorID
WHERE F1.RuntimeMinutes > (
    SELECT AVG(F2.RuntimeMinutes)
    FROM Films F2
    WHERE F2.DirectorID = F1.DirectorID
);

-- Practice 68: Films above average for their year
SELECT 
    F1.FilmName,
    F1.ReleaseYear,
    F1.RuntimeMinutes
FROM Films F1
WHERE F1.RuntimeMinutes > (
    SELECT AVG(F2.RuntimeMinutes)
    FROM Films F2
    WHERE F2.ReleaseYear = F1.ReleaseYear
);

-- Practice 69: Most profitable film per director
SELECT 
    F1.FilmName,
    D.DirectorName,
    F1.BoxOffice - F1.Budget AS Profit
FROM Films F1
INNER JOIN Directors D ON F1.DirectorID = D.DirectorID
WHERE (F1.BoxOffice - F1.Budget) = (
    SELECT MAX(F2.BoxOffice - F2.Budget)
    FROM Films F2
    WHERE F2.DirectorID = F1.DirectorID
);

-- Practice 70: Directors with above-average film counts
SELECT 
    D.DirectorName,
    (
        SELECT COUNT(*)
        FROM Films F
        WHERE F.DirectorID = D.DirectorID
    ) AS FilmCount
FROM Directors D
WHERE (
    SELECT COUNT(*)
    FROM Films F
    WHERE F.DirectorID = D.DirectorID
) > (
    SELECT AVG(FilmCount)
    FROM (
        SELECT COUNT(*) AS FilmCount
        FROM Films
        WHERE DirectorID IS NOT NULL
        GROUP BY DirectorID
    ) AS DirectorCounts
);

-- =====================================================
-- 4.12: ADVANCED PRACTICE QUERIES
-- =====================================================

-- Practice 71: Complex analysis query
SELECT 
    D.DirectorName,
    D.BirthYear,
    COUNT(*) AS FilmCount,
    AVG(F.RuntimeMinutes) AS AvgRuntime,
    SUM(CAST(F.BoxOffice AS BIGINT)) AS TotalBoxOffice,
    AVG(F.OscarWins) AS AvgOscars,
    MIN(F.ReleaseYear) AS FirstFilm,
    MAX(F.ReleaseYear) AS LatestFilm,
    CASE
        WHEN AVG(CAST(F.BoxOffice AS BIGINT)) > 500000000 THEN 'Blockbuster Director'
        WHEN AVG(CAST(F.BoxOffice AS BIGINT)) > 200000000 THEN 'Commercial Director'
        ELSE 'Artistic Director'
    END AS DirectorType
FROM Films F
INNER JOIN Directors D ON F.DirectorID = D.DirectorID
GROUP BY D.DirectorName, D.BirthYear
HAVING COUNT(*) >= 2
ORDER BY TotalBoxOffice DESC;

-- Practice 72: Film profitability analysis
WITH FilmProfitability AS (
    SELECT 
        F.FilmName,
        D.DirectorName,
        F.BoxOffice - F.Budget AS Profit,
        ((F.BoxOffice - F.Budget) / NULLIF(F.Budget, 0)) * 100 AS ROI,
        CASE
            WHEN F.BoxOffice - F.Budget > 500000000 THEN 'Mega Hit'
            WHEN F.BoxOffice - F.Budget > 100000000 THEN 'Hit'
            WHEN F.BoxOffice - F.Budget > 0 THEN 'Profitable'
            ELSE 'Loss'
        END AS ProfitCategory
    FROM Films F
    LEFT JOIN Directors D ON F.DirectorID = D.DirectorID
    WHERE F.Budget > 0
)
SELECT 
    ProfitCategory,
    COUNT(*) AS FilmCount,
    AVG(Profit) AS AvgProfit,
    AVG(ROI) AS AvgROI
FROM FilmProfitability
GROUP BY ProfitCategory
ORDER BY AvgProfit DESC;

-- Practice 73: Decade comparison
SELECT 
    (ReleaseYear / 10) * 10 AS Decade,
    COUNT(*) AS FilmCount,
    AVG(RuntimeMinutes) AS AvgRuntime,
    AVG(CAST(BoxOffice AS BIGINT)) AS AvgBoxOffice,
    AVG(OscarWins) AS AvgOscars,
    STRING_AGG(FilmName, ', ') AS FilmsList
FROM Films
GROUP BY (ReleaseYear / 10) * 10
ORDER BY Decade;

-- =====================================================
-- 4.13: COMMON MISTAKES - EXAMPLES TO AVOID
-- =====================================================

-- Practice 74: INCORRECT - Using alias in WHERE (will fail)
/*
SELECT 
    FilmName,
    BoxOffice - Budget AS Profit
FROM Films
WHERE Profit > 100000000;  -- This will cause an error
*/

-- Practice 74: CORRECT - Repeat calculation in WHERE
SELECT 
    FilmName,
    BoxOffice - Budget AS Profit
FROM Films
WHERE (BoxOffice - Budget) > 100000000;

-- Practice 75: INCORRECT - Aggregate in WHERE (will fail)
/*
SELECT ReleaseYear, COUNT(*)
FROM Films
WHERE COUNT(*) > 1  -- This will cause an error
GROUP BY ReleaseYear;
*/

-- Practice 75: CORRECT - Use HAVING for aggregates
SELECT ReleaseYear, COUNT(*)
FROM Films
GROUP BY ReleaseYear
HAVING COUNT(*) > 1;

-- Practice 76: Data type conversion example
SELECT 
    FilmName,
    'This film has ' + CAST(OscarWins AS VARCHAR(10)) + ' Oscar wins' AS Description
FROM Films;

-- Practice 77: Date format safety
-- RISKY (depends on regional settings):
-- WHERE ReleaseDate = '01/07/2010'

-- SAFE (ISO format):
SELECT FilmName, ReleaseDate
FROM Films
WHERE ReleaseDate = '2010-07-01';

-- =====================================================
-- SECTION 5: CLEANUP (Optional)
-- =====================================================

-- Uncomment these lines if you want to clean up the database
/*
USE master;
DROP DATABASE MovieDatabase;
*/

-- =====================================================
-- END OF PRACTICE FILE
-- =====================================================

-- CONGRATULATIONS! 
-- You have completed all 77 practice queries covering:
-- 1. Basic SELECT and FROM
-- 2. Aliases
-- 3. Sorting with ORDER BY
-- 4. Filtering with WHERE
-- 5. Calculated columns
-- 6. CASE expressions
-- 7. JOINs (INNER, LEFT, RIGHT, FULL OUTER)
-- 8. Functions (String, Date, Aggregate)
-- 9. Grouping and aggregation
-- 10. Subqueries
-- 11. Correlated subqueries
-- 12. Common mistakes and best practices

-- Keep practicing these concepts to master SQL Server!