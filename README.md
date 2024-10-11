Lahman Baseball Database Analysis
This project uses SQL to answer a variety of questions about player and team statistics from the Lahman Baseball Database. The database, made available by Sean Lahman, contains historical data on Major League Baseball (MLB) players and teams. In this analysis, I used SQL queries to explore the dataset and answer specific baseball-related questions, ranging from player stats to team performance, trends, and correlations.

Project Overview
The goal of this project was to apply SQL to extract insights from the Lahman Baseball Database. I answered several structured questions regarding player heights, team wins, stolen bases, and more, then explored open-ended questions involving team salary, attendance, and player performance over time.

Questions Answered in This Project
1. What range of years for baseball games does the database cover?
To get a sense of the data's time span, I queried the minimum and maximum years in which baseball games were recorded in the database. The results showed that the dataset spans from 1871 to 2016.

sql
Copy code
SELECT MIN(yearid) FROM appearances
UNION
SELECT MAX(yearid) FROM appearances;
2. Who is the shortest player in the database, and how many games did he play?
Using joins across the people, appearances, and teams tables, I identified Eddie Gaedel as the shortest player (standing at just 43 inches). He played one game for the St. Louis Browns.

sql
Copy code
SELECT 
    people.namefirst || ' ' || people.namelast AS player_full_name,
    MIN(height) AS heightininches,
    Appearances.g_all AS num_games,
    teams.name
FROM Appearances
JOIN people USING (playerid)
JOIN teams USING (teamid)
GROUP BY player_full_name, teams.name, num_games
ORDER BY heightininches
LIMIT 1;
3. Which Vanderbilt University players earned the most in Major League Baseball?
I used subqueries and joins to identify players who attended Vanderbilt University and calculated the total salary they earned during their careers. The query returned a sorted list of players, showing the highest-paid Vanderbilt alumni in Major League Baseball.

sql
Copy code
WITH pidsal AS (
    SELECT playerid, SUM(salary) FROM salaries GROUP BY salaries.playerid
),
atvandy AS (
    SELECT DISTINCT playerid FROM collegeplaying WHERE schoolid = 'vandy'
)
SELECT 
    namefirst || ' ' || namelast AS player_full_name,
    pidsal.sum AS totalsalaryearned
FROM people
JOIN pidsal USING (playerid)
JOIN atvandy USING (playerid)
GROUP BY player_full_name, pidsal.sum;
4. How many putouts did Outfield, Infield, and Battery players make in 2016?
I categorized players into three groups based on their position—Outfield, Infield, and Battery—and calculated the number of putouts each group made in 2016.

sql
Copy code
SELECT 
    SUM(po) AS num_putout,
    CASE 
        WHEN pos = 'OF' THEN 'Outfield'
        WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
        WHEN pos IN ('P', 'C') THEN 'Battery'
    END AS position
FROM fielding
WHERE yearid = 2016
GROUP BY position
ORDER BY num_putout;
5. Average Strikeouts and Home Runs Per Game by Decade (1920 and beyond)
This query calculated the average number of strikeouts and home runs per game for each decade since 1920. The results showed how these stats evolved over time, revealing an upward trend in both strikeouts and home runs in recent decades.

sql
Copy code
SELECT 
    ROUND(SUM(SO * 1.0)/SUM(g), 2) AS avg_strikeouts,
    ROUND(SUM(HR * 1.0)/SUM(g), 2) AS avg_homeruns,
    ((yearid / 10) * 10) AS decade
FROM teams
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;
6. Who was the most successful base stealer in 2016?
Using the batting table, I found the player who had the highest stolen base success rate in 2016 (minimum 20 stolen base attempts). The query calculated the ratio of successful stolen bases to total attempts.

sql
Copy code
WITH playerid2016 AS (
    SELECT playerid FROM appearances WHERE yearid = 2016
)
SELECT 
    p.namefirst || ' ' || p.namelast AS player_full_name,
    ROUND((b.sb * 1.0 / COALESCE(b.sb + b.cs, 1)), 2) AS ratio_base_stolen, 
    b.sb AS num_base_stolen
FROM batting b
JOIN playerid2016 p16 ON b.playerid = p16.playerid
JOIN people p ON p.playerid = b.playerid
WHERE b.yearid = 2016 AND b.sb >= 20
ORDER BY ratio_base_stolen DESC
LIMIT 20;
7. Team Wins vs. World Series Wins (1970–2016)
This query explored the correlation between a team's regular-season wins and whether they won the World Series. It determined the team with the most wins that did not win the World Series and the team with the fewest wins that did win it.

sql
Copy code
SELECT
    SUM(w) AS wins,
    name
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
    AND teamid NOT IN (SELECT teamid FROM teams WHERE WSWin = 'Y')
GROUP BY name
ORDER BY wins DESC;
Future Enhancements
Further analysis on salary vs. performance trends.
Adding data visualizations to better present trends in team and player stats.
Expanding on open-ended questions related to attendance, wins, and team dynamics.
Technologies Used
SQL (for querying and data analysis)
Lahman Baseball Database
Conclusion
This project demonstrates my ability to manipulate and analyze large datasets using SQL. By tackling structured questions and uncovering trends, I was able to draw insights into historical baseball data, including player performance, team success, and broader league trends.
