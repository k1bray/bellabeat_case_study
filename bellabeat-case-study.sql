USE [CaseStudy2-Bellabeat];

SELECT *
FROM dailyActivity;

SELECT
	ActivityDate
	,DATEPART(WEEKDAY, ActivityDate) AS DayOfWeekNum
	,DATENAME(WEEKDAY, ActivityDate) AS DayOfWeekName
FROM
	DailyActivity;


SELECT
	COUNT(*)
FROM
	dailyActivity;

SELECT
	Id
	,COUNT(Id)
FROM
	dailyActivity
GROUP BY
	Id;

SELECT *
FROM dailyCalories;

SELECT COUNT (*)
FROM minuteCaloriesWide;

SELECT TOP 200 *
FROM minuteCaloriesNarrow;

SELECT COUNT (*)
FROM minuteCaloriesNarrow;

SELECT TOP 200 *
FROM minuteMETsNarrow;

SELECT TOP 200 *
FROM weightLogInfo;

SELECT
	COUNT (*)
FROM
	weightLogInfo
WHERE
	Fat IS NULL;