-- ## Lahman Baseball Database Exercise
-- - this data has been made available [online](http://www.seanlahman.com/baseball-archive/statistics/) by Sean Lahman
-- - A data dictionary is included with the files for this project.

-- ### Use SQL queries to find answers to the *Initial Questions*. If time permits, choose one (or more) of the *Open-Ended Questions*. Toward the end of the bootcamp, we will revisit this data if time allows to combine SQL, Excel Power Pivot, and/or Python to answer more of the *Open-Ended Questions*.

-- Allright what are we working with here
-- 	SELECT *
-- 	FROM people
-- 	limit 10;

-- **Initial Questions**

-- 1. What range of years for baseball games played does the provided database cover? 

-- select min(yearid)
-- from appearances
-- Union
-- select max(yearid) 
-- from appearances

-- 1871 - 2016

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

 --   SELECT 
	-- 	people.namefirst || ' ' || people.namelast as player_full_name,
	-- 	min(height) AS heightininches,
	-- 	Appearances.g_all AS num_games,
	-- 	teams.name
	-- FROM Appearances
	-- Join people
	-- 	using (playerid)
	-- join teams
	-- 	using (teamid)
	--    GROUP BY people.namefirst, people.namelast,teams.name,num_games
	--    ORDER BY heightininches
	--    limit 1;

	-- "Eddie Gaedel"	43	1	"St. Louis Browns"
		
-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
-- WITH pidsal AS
-- 	(SELECT playerid,
-- 	sum(salary)
-- 	from salaries 
-- 	GROUP BY salaries.playerid
-- 	),

-- atvandy AS
-- 	(SELECT distinct playerid  				
-- 	from collegeplaying
-- 	where schoolid = 'vandy')
	
-- SELECT 
-- 		namefirst || ' ' || namelast as player_full_name,
-- 		pidsal.sum AS totalsalaryearned
-- 	FROM people
-- 	Join pidsal
-- 		using (playerid)
-- 	join atvandy
-- 	using (playerid)
-- 	group by player_full_name,pidsal.sum
-- ;



-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

-- SELECT 
-- 	sum(po) as num_putout,	
-- 	CASE 
-- 		WHEN pos = 'OF' THEN 'Outfield'
-- 		WHEN pos IN ('SS', '1B', '2B',  '3B') THEN 'Infield'
-- 		WHEN pos IN ( 'P', 'C') THEN 'Battery'
-- 		END as posistion
		 
-- 	FROM fielding
-- 	WHERE yearid = 2016
-- 	GROUP BY posistion
-- 	ORDER BY num_putout;


-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

-- SELECT 
-- 	ROUND(sum(SO * 1.0)/sum(g),2) as avg_strikeouts,
-- 	ROUND(sum(HR * 1.0)/sum(g),2) as avg_homeruns,
-- 	((yearid/10)*10) as decade
-- FROM teams
-- WHERE yearid >= 1920
-- group by decade
-- order by decade;

-- Try to use the rank function? possibly by the ratio of hr to so?
-- SELECT 
--     ROUND(SUM(SO * 1.0) / SUM(g), 2) as avg_strikeouts,
--     ROUND(SUM(HR * 1.0) / SUM(g), 2) as avg_homeruns,
--     ((yearid / 10) * 10) as decade,
--     RANK() OVER (ORDER BY SUM(HR * 1.0) / SUM(SO * 1.0) DESC) AS hr_so_ratio
-- FROM teams
-- WHERE yearid >= 1920
-- GROUP BY decade
-- ORDER BY decade;

-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.

-- WITH playerid2016 AS (
--     SELECT playerid
--     FROM appearances
--     WHERE yearid = 2016
-- )

-- SELECT 
--     p.namefirst || ' ' || p.namelast AS player_full_name,
--     ROUND((b.sb * 1.0 / COALESCE(b.sb + b.cs, 1)),2) AS ratio_base_stolen, 
--     b.sb AS num_base_stolen,
--     RANK() OVER (ORDER BY (b.sb * 1.0 / COALESCE(b.sb + b.cs, 1)) DESC) AS stolen_metric
-- FROM 
--     batting b
-- JOIN 
--     playerid2016 p16 ON b.playerid = p16.playerid
-- JOIN 
--     people p ON p.playerid = b.playerid
-- WHERE 
--     b.yearid = 2016 AND
--     b.sb >= 20
-- ORDER BY 
--     stolen_metric
-- LIMIT 
--     20;


-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
--Teams that won alot of games but did not win the wold series
-- SELECT
-- 	sum(w) as wins,
-- 	name
-- FROM teams
	
-- WHERE yearid  BETWEEN 1970 AND 2016
-- 	AND teamid NOT IN (	SELECT teamid
-- 						FROM teams
-- 						WHERE WSWin = 'Y'
	
-- 	)
-- 	GROUP BY teams.name
-- 	ORDER BY wins desc;

-- "Houston Astros"

-- What is the smallest number of wins for a team that did win the world series? 
-- 	SELECT
-- 	sum(w) as wins,
-- 	name
-- FROM teams
	
-- WHERE yearid  BETWEEN 1970 AND 2016
-- 	AND teamid IN (	SELECT teamid
-- 						FROM teams
-- 						WHERE WSWin = 'Y'
	
-- 	)
-- 	GROUP BY teams.name
-- 	ORDER BY wins;

-- ""Anaheim Angels"" 664
-- 	Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.
-- Select
-- 	*

-- from teams
-- 	WHERE  name = 'Anaheim Angels'
-- 	and yearid  BETWEEN 1970 AND 2016
-- 	order by w;
	
-- 	Then redo your query, excluding the problem year.
	
-- 	How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
	
-- 	What percentage of the time?

-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

-- (
-- select teams.name,
-- 	teams.park,
-- 	homegames.attendance/games as avg_att
-- from homegames
-- 	join teams
-- 	ON homegames.team = teams.teamid
-- 		WHERE year = 2016
-- 		AND games >= 10
-- 	GROUP BY teams.name, teams.park, year, homegames.attendance, games
-- 	ORDER BY avg_att desc
-- 	LIMIT 5

-- )
-- UNION
-- (
-- select teams.name,
-- 	teams.park,
-- 	homegames.attendance/games as avg_att
-- from homegames
-- 	join teams
-- 	ON homegames.team = teams.teamid
-- 		WHERE year = 2016
-- 		AND games >= 10
-- 	GROUP BY teams.name, teams.park, year, homegames.attendance, games
-- 	ORDER BY avg_att 
-- 	LIMIT 5
-- )

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
--Do managers "win the award" if they tie?

-- SELECT 
-- 	namefirst || ' '|| namelast AS manager_full_name,
-- 	teams.name AS team_name
-- 	WHERE playerid IN (
-- 			(SELECT playerid
-- 				FROM AwardsManagers
-- 				WHERE lgid ILIKE 'NL')
-- 		UNION ALL	
-- 			(SELECT playerid
-- 				FROM AwardsManagers
-- 				WHERE lgid ILIKE 'AL')
-- )
-- 	AND
-- 		AwardsManagers.yearid = teams.yearid AS thing
	
-- FROM people
-- 	join AwardsManagers
-- USING (playerid)
-- 	join teams
-- 	on using (yearid)
-- -- My garbage above
-- 	WITH cte1 AS (
-- SELECT playerid, yearid
-- FROM AwardsManagers
-- WHERE lgid ILIKE 'NL'
-- 	AND awardid = 'TSN Manager of the Year'),

-- cte2 AS (
-- SELECT playerid, yearid
-- FROM AwardsManagers
-- WHERE lgid ILIKE 'AL'
-- 	AND awardid = 'TSN Manager of the Year'
-- )

-- SELECT playerid, 
-- 	p.namefirst || ' '|| p.namelast AS manager_full_name,
-- 	t.name
-- FROM cte1
-- JOIN cte2
-- USING(playerid)
-- LEFT JOIN people as p
-- USING(playerid)
-- LEFT JOIN teams as t
-- ON cte1.yearid = t.yearid
	
-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

-- 	SELECT
-- 		max(homerruns) AS hr,
-- 		COUNT(batting.HR) AS num_2016_HR
	
-- FROM people AS p
-- 	JOIN batting AS b
-- USING playerid
	
-- 		WHERE yearid =2016
-- 	AND (extract (YEAR FROM p.finalgame)- extract( YEAR FROM p.debut)) <=10
-- 	AND playerid IN (
-- 			SELECT 	playerid
-- 			FROM batting
-- 			WHERE HR >= 1 )
-- 	;



-- **Open-ended questions**

-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.
---who won in the 2000's
-- WITH team_wins AS
-- (
-- 	SELECT
-- 		teamid,
-- 		yearid,
-- 		w AS wins
-- 	FROM teams
-- 	where yearid >= 2000
-- ),
-- --who got paid in the 2000's
-- teamsalaries AS
-- (
-- 	SELECT 
-- 		teamid,
-- 		yearid,
-- 	sum(salary) AS total_salary
-- 	FROM
-- 		salaries
-- 	WHERE yearid >= 2000
-- 	GROUP BY teamid, yearid
-- )
-- --join who won and paid in 2000's and compair these rank these values

-- SELECT
-- 	ts.yearid,
-- 	ts.teamid,
-- 	ts.total_salary,
-- 	tw.wins,
-- 	RANK() OVER (PARTITION BY ts.yearid ORDER BY ts.total_salary) AS salary_rank,
-- RANK() OVER (PARTITION BY ts.yearid ORDER BY tw.wins DESC) AS wins_rank,
-- 	((RANK() OVER (PARTITION BY ts.yearid ORDER BY ts.total_salary) ) :: NUMERIC
-- 	-
-- (RANK() OVER (PARTITION BY ts.yearid ORDER BY tw.wins DESC)) :: NUMERIC) AS dif_in_salvwin_rank
	
-- FROM teamsalaries AS ts
-- JOIN team_wins AS tw
-- ON ts.teamid = tw.teamid AND ts.yearid = tw.yearid
-- ORDER BY 
--     dif_in_salvwin_rank DESC,ts.yearid, ts.teamid;

--I've wasted my time on this code. I need to look at whole leagues and average salaries and if average teams win averagely? because high wages should win more and low wages should lose more but ipso facto average wages should averagely win yeah? so take a sample of average teams per league and average the number of wins per that league and see how they match up? .... or by shere math the average team will have an average winning average... ugh..


-- 12. In this question, you will explore the connection between number of wins and attendance.
--     <ol type="a">
--       <li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
--       <li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.</li>
--     </ol>




-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?

  
