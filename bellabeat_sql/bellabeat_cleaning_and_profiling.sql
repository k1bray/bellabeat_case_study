USE [CaseStudy2-Bellabeat];

-------------------------Data Cleaning and Profiling-------------------------------

-- Renaming tables to standardize table names and maintain schema consistency

exec sp_rename 'dailyActivity_merged', 'daily_activity';						--<><><><>
GO
exec sp_rename 'dailyCalories_merged', 'daily_calories';
GO
exec sp_rename 'dailyIntensities_merged', 'daily_intensity';
GO
exec sp_rename 'dailySteps_merged', 'daily_steps';
GO
exec sp_rename 'secondsHeartrate_merged','seconds_heartrate';					--<><><><>
GO
exec sp_rename 'hourlyCalories_merged', 'hourly_calories';						--<><><><>
GO
exec sp_rename 'hourlyIntensities_merged', 'hourly_intensity';					--<><><><>
GO
exec sp_rename 'hourlySteps_merged', 'hourly_steps';							--<><><><>
GO
exec sp_rename 'minuteCaloriesNarrow_merged', 'minute_calories_narrow';
GO
exec sp_rename 'minuteCaloriesWide_merged', 'minute_calories_wide';
GO
exec sp_rename 'minuteIntensitiesNarrow_merged', 'minute_intensity';		--<><><><>
GO
exec sp_rename 'minuteIntensitiesWide_merged', 'minute_intensity_wide';
GO
exec sp_rename 'minuteMETsNarrow_merged', 'minute_mets';					--<><><><>
GO
exec sp_rename 'minuteSleep_merged', 'minute_sleep';							--<><><><>
GO
exec sp_rename 'minuteStepsNarrow_merged', 'minute_steps_narrow';
GO
exec sp_rename 'minuteStepsWide_merged', 'minute_steps_wide';
GO
exec sp_rename 'sleepDay_merged', 'daily_sleep';								--<><><><>
GO
exec sp_rename 'weightLogInfo_merged', 'weight_log';							--<><><><>

-- Checking the daily_activity table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_activity';

-- Checking the seconds_heartrate table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='seconds_heartrate';

-- Checking the hourly_calories table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='hourly_calories';

-- Checking the hourly_intensity table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='hourly_intensity';

-- Checking the hourly_steps table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='hourly_steps';

-- Checking the minute_intensity_narrow table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_intensity';

-- Checking the minute_mets_narrow table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_mets';

-- Checking the minute_sleep table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_sleep';

/*
During importation, all columns were designated as varchar(50).
Updating column datatypes.
*/

-- Updating the hourly_intensity table

ALTER TABLE hourly_intensity
ALTER COLUMN ActivityHour DATETIME;
GO
ALTER TABLE hourly_intensity
ALTER COLUMN TotalIntensity NUMERIC;
GO
ALTER TABLE hourly_intensity
ALTER COLUMN AverageIntensity DECIMAL;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='hourly_intensity';

-- Updating the daily_sleep

ALTER TABLE daily_sleep
ALTER COLUMN SleepDay DATETIME;
GO
ALTER TABLE daily_sleep
ALTER COLUMN TotalSleepRecords NUMERIC;
GO
ALTER TABLE daily_sleep
ALTER COLUMN TotalMinutesAsleep NUMERIC;
GO
ALTER TABLE daily_sleep
ALTER COLUMN TotalTimeInBed NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_sleep';

-- Updating the minute_sleep table

ALTER TABLE minute_sleep
ALTER COLUMN date DATETIME;
GO
ALTER TABLE minute_sleep
ALTER COLUMN value NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_sleep';

SELECT TOP 100 * From minute_sleep;

-- Updating the daily_activity table

ALTER TABLE daily_activity
ALTER COLUMN ActivityDate DATE;
GO
ALTER TABLE daily_activity
ALTER COLUMN TotalSteps NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN TotalDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN TrackerDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN LoggedActivitiesDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN VeryActiveDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN ModeratelyActiveDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN LightActiveDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN SedentaryActiveDistance NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN VeryActiveMinutes NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN FairlyActiveMinutes NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN LightlyActiveMinutes NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN SedentaryMinutes NUMERIC;
GO
ALTER TABLE daily_activity
ALTER COLUMN Calories NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_activity';


-- Updating the weight_log table

ALTER TABLE weight_log
ALTER COLUMN Date DATE;
GO
ALTER TABLE weight_log
ALTER COLUMN WeightKg NUMERIC;
GO
ALTER TABLE weight_log
ALTER COLUMN WeightPounds NUMERIC;
GO
ALTER TABLE weight_log
ALTER COLUMN BMI NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='weight_log';

--Updating the minute_intensity_narrow table

ALTER TABLE minute_intensity_narrow
ALTER COLUMN ActivityMinute DATETIME;
GO
ALTER TABLE minite_intensity_narrow
ALTER COLUMN Intensity NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_intensity';

--Updating the minute_mets_narrow table

ALTER TABLE minute_mets_narrow
ALTER COLUMN ActivityMinute DATETIME;
GO
ALTER TABLE minute_mets_narrow
ALTER COLUMN METs NUMERIC;
GO
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_mets';

-- Creating a minute_activity table

DROP TABLE IF EXISTS minute_activity
GO
SELECT
	i.Id AS Id
	,i.ActivityMinute AS ActivityMinute
	,Intensity AS ActivityIntensity
	,METs AS METs
	,value AS SleepState
INTO minute_activity
FROM	
	minute_intensity AS i
JOIN minute_mets AS m
	ON i.Id = m.Id AND
	i.ActivityMinute = m.ActivityMinute
JOIN minute_sleep AS s
	ON i.Id = s.Id AND
	i.ActivityMinute = s.date
;
GO
SELECT * FROM minute_activity;

--Creating and hourly_activity table

DROP TABLE IF EXISTS hourly_activity
GO
SELECT
	c.Id AS Id 
	,c.ActivityHour AS ActivityHour
	,Calories AS Calories
	,TotalIntensity AS TotalIntensity
	,AverageIntensity AS AverageIntensity
	,StepTotal AS StepTotal
INTO hourly_activity
FROM	
	hourly_calories AS c
JOIN hourly_intensity AS i 
	ON c.Id = i.Id AND
	c.ActivityHour = i.ActivityHour
JOIN hourly_steps AS s 
	ON c.Id = s.Id AND
	c.ActivityHour = s.ActivityHour
;
GO
SELECT * FROM hourly_activity;

/*
Finding the count of users in the minute_activity table, the earliest and latest days 
in the study, as well as the calendar math from start to finish
*/

SELECT TOP 100 * FROM minute_activity;

SELECT
    COUNT(DISTINCT Id) AS user_count -- 22 users
    ,MIN(ActivityMinute) AS earliest_date  -- 2016-04-12 00:00:00.000
    ,MAX(ActivityMinute) AS latest_date   -- 2016-05-12 09:56:00.000
    ,DATEDIFF(D, MIN(ActivityMinute), MAX(ActivityMinute)) +1 AS Difference  -- 31 days
FROM
    minute_activity;

/*
Finding the count of users in the hourly_activity table, the earliest and latest days 
in the study, as well as the calendar math from start to finish
*/

SELECT TOP 100 * FROM hourly_activity;

SELECT
    COUNT(DISTINCT Id) AS user_count -- 33 users
    ,MIN(ActivityHour) AS earliest_date  -- 2016-04-12 00:00:00.000
    ,MAX(ActivityHour) AS latest_date   -- 2016-05-12 15:00:00.000
    ,DATEDIFF(D, MIN(ActivityHour), MAX(ActivityHour)) +1 AS Difference  -- 31 days
FROM
    hourly_activity;

/*
Finding the count of users in the daily_activity table, the earliest and latest days 
in the study, as well as the calendar math from start to finish
*/

SELECT
    COUNT(DISTINCT Id) AS user_count -- 33 users
    ,MIN(ActivityDate) AS earliest_date  -- 2016/04/12
    ,MAX(ActivityDate) AS latest_date   -- 2016/05/12
    ,DATEDIFF(D, MIN(ActivityDate), MAX(ActivityDate)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT ActivityDate) AS date_count     -- 31 days
FROM
    daily_activity;

/*
Finding the count of users in the daily_sleep table, the earliest and latest days in the study, 
as well as the calendar math from start to finish
*/

SELECT
    COUNT(DISTINCT Id) AS user_count -- 24 users
    ,MIN(SleepDay) AS earliest_date  -- 2016/04/12
    ,MAX(SleepDay) AS latest_date   -- 2016/05/12
    ,DATEDIFF(D, MIN(SleepDay), MAX(SleepDay)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT SleepDay) AS date_count     -- 31 days
FROM
    daily_sleep;

/*
Finding the count of users in the hourly_intensity table, the earliest and latest days in the study, 
as well as the calendar math from start to finish
*/

SELECT
    COUNT(DISTINCT Id) AS user_count -- 33 users
    ,MIN(ActivityHour) AS earliest_date  -- 2016-04-12 00:00:00.000
    ,MAX(ActivityHour) AS latest_date   -- 2016-05-12 15:00:00.000
    ,DATEDIFF(D, MIN(ActivityHour), MAX(ActivityHour)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT ActivityHour) AS hour_count     -- 736 hours
    ,(COUNT(DISTINCT ActivityHour)/24) +1 AS day_count  -- 31 days
FROM
    hourly_intensity;

/*
Finding the count of users in the minute_sleep table, the earliest and latest days in the study, 
as well as the calendar math from start to finish
*/

SELECT
    COUNT(DISTINCT Id) AS user_count -- 24 users
    ,MIN(date) AS earliest_date  -- 2016-04-11 20:48:00.000
    ,MAX(date) AS latest_date   -- 2016-05-12 09:56:00.000
    ,DATEDIFF(D, MIN(date), MAX(date)) +1 AS Difference  -- 32 days
    ,COUNT(DISTINCT date) AS minute_count     -- 49773 minutes
    ,(COUNT(DISTINCT date)/1440) +1 AS day_count  -- 35 days
FROM
    minute_sleep;

/*
Finding the count of users in the weight_log table, the earliest and latest days in the study, 
as well as the calendar math from start to finish
*/

SELECT
    COUNT(DISTINCT Id) AS user_count -- 8 users
    ,MIN(Date) AS earliest_date  -- 2016-04-12
    ,MAX(Date) AS latest_date   -- 2016-05-12
    ,DATEDIFF(D, MIN(Date), MAX(Date)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT Date) AS day_count     -- 31 days
FROM
    weight_log;

/*
Testing to see how saturated the records are per user Id.
The records for some users appear to be incomplete.
The following query shows that there was not full participation across the board for all features.
Ordering by the sleep_records_per_id ascending shows that there are 9 users where calorie records were taken, but 
not sleep records.

It makes sense that features that use an automatic data collection process are going to have a higher 
participation rate than features that require the user to manually interact with.
*/

DROP TABLE IF EXISTS #sleep_count
GO
SELECT 
	Id,
	COUNT(TotalSleepRecords) AS sleep_records_per_id
INTO	
	#sleep_count
FROM 
	daily_sleep
GROUP BY 
	Id
GO
DROP TABLE IF EXISTS #calorie_count
GO
SELECT	
	Id,
	COUNT(Calories) AS Calorie_records_per_id
INTO
	#calorie_count
FROM	
	daily_activity
GROUP BY	
	Id
GO
SELECT 
	#calorie_count.id,
	sleep_records_per_id,
	calorie_records_per_id
FROM
	#calorie_count
	FULL JOIN #sleep_count
	ON #calorie_count.Id = #sleep_count.Id
ORDER BY
    sleep_records_per_id DESC;

/*
Check for duplicate rows in minute_activity table.

The following query shows no results of duplicate rows.
*/

SELECT
	Id
	,ActivityMinute
	,ActivityIntensity
	,METs
	,SleepState
	,COUNT(*) AS num_records
FROM
	minute_activity
GROUP BY
	Id
	,ActivityMinute
	,ActivityIntensity
	,METs
	,SleepState
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Check for duplicate rows in hourly_activity table.

The following query shows no results of duplicate rows.
*/

SELECT
	Id
	,ActivityHour
	,Calories
	,TotalIntensity
	,AverageIntensity
	,StepTotal
	,COUNT(*) AS num_records
FROM
	hourly_activity
GROUP BY
	Id
	,ActivityHour
	,Calories
	,TotalIntensity
	,AverageIntensity
	,StepTotal
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Check for duplicate rows in daily_activity table.

The following query shows no results of duplicate rows.
*/

SELECT
	Id
	,ActivityDate
	,COUNT(*) AS num_records
FROM
	daily_activity
GROUP BY
	Id
	,ActivityDate
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Check for duplicate rows in daily_sleep table.

It appears that there are 3 duplicate records.

**** Later Edit ****
The duplicates were removed.
*/

SELECT
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
	,COUNT(*) AS num_records
FROM
	daily_sleep
GROUP BY
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Creating new sleepDay2 table and populating it with all distinct values from daily_sleep
*/

SELECT 
	DISTINCT *
INTO
	sleepDay2
FROM 
	daily_sleep;

/*
Checking the new sleepDay2 table to see if there are any dupilcate rows

Success!
*/

SELECT
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
	,COUNT(*) AS num_records
FROM
	sleepDay2
GROUP BY
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;


--Dropping old sleepDay table


DROP TABLE	-- Executed
	daily_sleep;

--Renaming sleepDay2 to sleepDay and completing the replacement of the table with no dupilicates.

USE [CaseStudy2-Bellabeat];
GO
exec sp_rename 'sleepDay2', 'daily_sleep';

--Checking the table contents of the "new" daily_sleep table

SELECT * FROM daily_sleep;

/*
Verifying that the new daily_sleep table does not have any of the duplicates

Seems to be all set.
*/

SELECT
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
	,COUNT(*) AS num_records
FROM
	daily_sleep
GROUP BY
	Id
	,SleepDay
	,TotalSleepRecords
	,TotalMinutesAsleep
	,TotalTimeInBed
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Checking the hourly_intensity table for duplicate records.

There appear to be none.
*/

SELECT
	Id
	,ActivityHour
	,COUNT(*) AS num_records
FROM
	hourly_intensity
GROUP BY
	Id
	,ActivityHour
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Checking the minute_sleep table for duplicate records.

There appear to be 543 duplicate records.
*/

SELECT
	Id
	,date
	,value
	,logId
	,COUNT(*) AS num_records
FROM
	minute_sleep
GROUP BY
	Id
	,date
	,value
	,logId
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

-- Checking a specific record - This query shows two identical records.

SELECT
	* 
FROM
	minute_sleep
WHERE
	Id = 4702921684
	AND date = '2016-05-07 01:08:00.000';

/*
Creating new minute_sleep2 table and populating it with all distinct values from minute_sleep
*/

SELECT 
	DISTINCT *
INTO
	minute_sleep2
FROM 
	minute_sleep;

/*
Checking the new minute_sleep2 table to see if there are any dupilcate rows

It appears to be successful.
*/

SELECT
	Id
	,date
	,value
	,logId
	,COUNT(*) AS num_records
FROM
	minute_sleep2
GROUP BY
	Id
	,date
	,value
	,logId
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Dropping old minute_sleep table
*/

DROP TABLE	-- Executed
	minute_sleep;

/*
Renaming minute_sleep2 to minute_sleep and completed the replacement of the table with no dupilicates.
*/

USE [CaseStudy2-Bellabeat];
GO
exec sp_rename 'minute_sleep2', 'minute_sleep';

/*
Checking the table contents of the "new" minute_sleep table
*/

SELECT * FROM minute_sleep;

/*
Verifying that the new minute_sleep table does not have any of the duplicates

Seems to be all set.
*/

SELECT
	Id
	,date
	,value
	,logId
	,COUNT(*) AS num_records
FROM
	minute_sleep
GROUP BY
	Id
	,date
	,value
	,logId
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Check for duplicate rows in hourly_intensity table.

It appears that there are 0 duplicate records.
*/

SELECT
	Id
	,ActivityHour
	,TotalIntensity
	,AverageIntensity
	,COUNT(*) AS num_records
FROM
	hourly_intensity
GROUP BY
	Id
	,ActivityHour
	,TotalIntensity
	,AverageIntensity
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Check for duplicate rows in weight_log table.

It appears that there are 0 duplicate records.
*/

SELECT
	Id
	,Date
	,WeightKg
	,WeightPounds
	,Fat
	,BMI
	,IsManualReport
	,LogId
	,COUNT(*) AS num_records
FROM
	weight_log
GROUP BY
	Id
	,Date
	,WeightKg
	,WeightPounds
	,Fat
	,BMI
	,IsManualReport
	,LogId
HAVING
	COUNT(*) > 1
ORDER BY
	num_records DESC;

/*
Checking the daily_activity table for NULL's and key 0's that could throw off any aggregations or calculations
*/

SELECT * FROM daily_activity;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_activity';

-- There do not appear to be any NULL's in the table

SELECT
	*
FROM daily_activity
WHERE
	Id IS NULL
	OR ActivityDate IS NULL
	OR TotalSteps IS NULL
	OR TotalDistance IS NULL
	OR TrackerDistance IS NULL
	OR LoggedActivitiesDistance IS NULL
	OR VeryActiveDistance IS NULL
	OR ModeratelyActiveDistance IS NULL
	OR LightActiveDistance IS NULL
	OR SedentaryActiveDistance IS NULL
	OR VeryActiveMinutes IS NULL
	OR FairlyActiveMinutes IS NULL
	OR LightlyActiveMinutes IS NULL
	OR SedentaryMinutes IS NULL
	OR Calories IS NULL;

-- Checking the daily_sleep table for NULLs
-- 0 records found

SELECT *
FROM daily_sleep
WHERE
	Id IS NULL
	OR SleepDay IS NULL
	OR TotalSleepRecords IS NULL
	OR TotalMinutesAsleep IS NULL
	OR TotalTimeInBed IS NULL;

-- Checking the hourly_intensity table for NULLs
-- 0 records found

SELECT *
FROM hourly_intensity
WHERE
	Id IS NULL
	OR ActivityHour IS NULL
	OR TotalIntensity IS NULL
	OR AverageIntensity IS NULL;

-- Checking the minute_sleep table for NULLs
-- 0 records found

SELECT *
FROM minute_sleep
WHERE
	Id IS NULL
	OR date IS NULL
	OR value IS NULL
	OR logId IS NULL;

-- Checking the weight_log table for NULLs
-- 0 records found

SELECT *
FROM weight_log
WHERE
	Id IS NULL
	OR Date IS NULL
	OR WeightKg IS NULL
	OR WeightPounds IS  NULL
	OR Fat IS NULL
	OR BMI IS NULL
	OR IsManualReport IS NULL
	OR LogId IS NULL;

/*
The following query shows 79 records that were sedentary for a 24 hour period.

Most of the records in the result of this query show 0's across the board for all activity levels.  However,
there are a few that show significant daily step counts and total distances that would be unachievable while
being sedentary for an entire day.  According to the data dictionary, steps can either be tracked by the device
or manually entered by the user for the given period.  These records could be representative of inaccuracies
in the dataset, or could be legitimate as manual entries.  Either way, there are so few of them that they may not 
cause any anomaly in the analysis of any significance that would warrant their removal.

The fact they are there could be an opportunity to pose a question about the population of the user group that 
manually enters their step data instead of having it be automatically collected by their fitness tracker.  Unfortunately,
The dataset does not provide information in the daily_activity table in regard to data collection method - i.e. manual
vs. automatic.
*/

SELECT 24 * 60; 	-- There are 1440 minutes in a day

SELECT
	*
FROM
	daily_activity
WHERE
	SedentaryMinutes = 1440
ORDER BY
	TotalSteps DESC;

-- Simply another way to write the query above and get the same results.

SELECT
	*
FROM
	daily_activity
WHERE
	SedentaryMinutes IN 
	(
	SELECT
		MAX(SedentaryMinutes)
	FROM
		daily_activity
	)
ORDER BY	
	TotalSteps DESC
	;

/*
Check to see if there are any records in the daily_activity table that show no device usage or App interaction
at all in a 24 hour period.  The results show that there are 4 records that fit.

4 out of 940 is insignificant and not likely to influence any results in a material way.
*/

SELECT
	*	-- 4 records
FROM
	daily_activity
WHERE
	TotalSteps = 0 AND
	TotalDistance = 0 AND
	TrackerDistance = 0 AND
 	LoggedActivitiesDistance = 0 AND
	VeryActiveDistance = 0 AND
	ModeratelyActiveDistance = 0 AND
	LightActiveDistance = 0 AND
	SedentaryActiveDistance = 0 AND
	VeryActiveMinutes = 0 AND
	FairlyActiveMinutes = 0 AND
	LightlyActiveMinutes = 0 AND
	Calories = 0 AND
	SedentaryMinutes = 1440
ORDER BY
	TotalSteps DESC;

-- Taking a look at the daily_activity table in DESC order by the SedentaryMinutes column.

SELECT 
	* 
FROM 
	daily_activity
ORDER BY
	SedentaryMinutes DESC;

/*
Looking at how many records show users wearing their devices for a 24 hour period, thus giving a 
complete daily usage record.
*/

SELECT	
	COUNT(*)	-- 478 records
FROM	
	daily_activity
WHERE
	VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440;

/*
Looking at a list of Id's and how many full days they wore their fitness tracker.

The resulting list is for 28 users.  Since there are 33 users in the study, that means that 5 users
 never wore their device for a full day during the study.  Also, 5 out of the 28 (or 33 total) wore
 their devices for 30 days.  15 users wore theirs at least 20 days.  10 of the users (not including the
 ones not represented by this list) wore their devices less than 8 days during the study.
*/

SELECT
	DISTINCT Id,
	COUNT (*) AS count_full_day
FROM	
	daily_activity
WHERE
	VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440
GROUP BY
	Id
ORDER BY
	count_full_day DESC;

/*
The following query shows 25 records where the TotalSteps > 0, but showing no distance values at any activity level.

Again, this could be caused by the manual entry feature and may not be "bad data".

Also, something to consider is that several of the records have wicked low step counts.
*/

SELECT
	*
FROM
	daily_activity
WHERE
	TotalSteps > 0
	AND totalDistance = 0
	AND VeryActiveDistance = 0
	AND ModeratelyActiveDistance = 0
	AND LightActiveDistance = 0
	AND SedentaryActiveDistance = 0
ORDER BY
	Id
	,TotalSteps DESC
	,SedentaryMinutes DESC;

/*
The following query shows a grouped list of the 10 Id's from the previous query and how many records per Id
where the distances don't appear to match the step counts.
*/

SELECT
	Id,
	COUNT(*) AS count_per_id
FROM
	daily_activity
WHERE
	TotalSteps > 0
	AND totalDistance = 0
	AND VeryActiveDistance = 0
	AND ModeratelyActiveDistance = 0
	AND LightActiveDistance = 0
	AND SedentaryActiveDistance = 0
GROUP BY
	Id
ORDER BY
	count_per_id DESC;

/*
The following query is similar to a previous query in that it shows 7 records where the step count
is > 0, but all active minutes categories are = 0.

These records could be indicative of manual logging for steps and/or distance figures.
However, these records show the TotalDistance = TrackerDistance.  According to the data dictionary,
the TrackerDistance figure is  the "Total kilometers tracked by Fitbit device."  Along with the calorie
figures > 0, this could point to corrupted data.  However, it's only 7 records out of 940.

I'll need to evaluate whether they should be altered or removed.
*/

SELECT	-- 7 rows affected
	*
FROM
	daily_activity
WHERE
	TotalSteps > 0
	AND VeryActiveMinutes = 0
	AND FairlyActiveMinutes = 0
	AND LightlyActiveMinutes = 0
ORDER BY
	TotalSteps DESC
	,SedentaryMinutes DESC;

/*
The following query shows 77 records where there were 0 steps taken in a day.

This is similar to a previous query that just looked at records (79 in total) that were sedentary 
for a 24 hour period.
*/

SELECT
	*
FROM
	daily_activity
WHERE
	TotalSteps = 0
	AND VeryActiveDistance = 0
	AND ModeratelyActiveDistance = 0
	AND LightActiveDistance = 0
	AND SedentaryActiveDistance = 0;

/*
The following query builds on the previous query and shows a list of the 15 Id's where the total daily 
steps as well as all the active distances = 0.  The list is grouped by Id and shows a count per Id 
of how many days of 0 activity.

4 out of the 15 have at least 10 days of 0 activity.
*/

SELECT
	Id,
	COUNT(*) AS count_per_id
FROM
	daily_activity
WHERE
	TotalSteps = 0
	AND totalDistance = 0
	AND VeryActiveDistance = 0
	AND ModeratelyActiveDistance = 0
	AND LightActiveDistance = 0
	AND SedentaryActiveDistance = 0
GROUP BY
	Id
ORDER BY
	count_per_id DESC;

/*
The following query shows 4 records where the daily calories burned was 0.
*/

SELECT
	*
FROM
	daily_activity
WHERE
	Calories = 0;

/*
The following query shows 11 records where there is a discrepancy between the TotalDistance and the 
TrackerDistance columns.

This discrepancy could be explained by the manual entry feature of the Fitbit fitness trackers.
*/

SELECT
	*
FROM
	daily_activity
WHERE
	TotalDistance != TrackerDistance;

/*
The results of the following queries both return zero rows.  Since the data dictionary is vague
on their definitions, the information is, at best, of limited value.
*/

SELECT *
FROM 
	daily_activity
WHERE
	LoggedActivitiesDistance = TrackerDistance
	AND
	LoggedActivitiesDistance != 0;

Go

SELECT *
FROM 
	daily_activity
WHERE
	LoggedActivitiesDistance = TotalDistance
	AND
	LoggedActivitiesDistance != 0;

/*
The following query shows 32 records where the LoggedActivitiesDistance does NOT equal 0.

The data dictionary is not quite clear as to what constitutes a "LoggedActivityDistance".
There is some mention to another table or field that contains LogType as a column.
I don't believe at this time that the LoggedActivitiesDistance column can either help or hurt the results.
*/

SELECT
	*
FROM
	daily_activity
WHERE
	LoggedActivitiesDistance != 0;

/*
Checking the character length of daily_activity.Id
*/

SELECT 
	LEN(Id) AS char_length  --10 characters
FROM 
	daily_activity
GROUP BY
	LEN(Id)
ORDER BY
	char_length DESC;

/*
Checkiing the character length of daily_sleep.Id
*/

SELECT 
	LEN(Id) AS char_length  --10 characters
FROM 
	daily_sleep
GROUP BY
	LEN(Id)
ORDER BY
	char_length DESC;

/*
Checkiing the character length of hourly_intensity.Id
*/

SELECT 
	LEN(Id) AS char_length  --10 characters
FROM 
	hourly_intensity
GROUP BY
	LEN(Id)
ORDER BY
	char_length DESC;

/*
Checkiing the character length of minute_sleep.Id
*/

SELECT 
	LEN(Id) AS char_length  --10 characters
FROM 
	minute_sleep
GROUP BY
	LEN(Id)
ORDER BY
	char_length DESC;

/*
Checkiing the character length of weight_log.Id
*/

SELECT 
	LEN(Id) AS char_length  --10 characters
FROM 
	weight_log
GROUP BY
	LEN(Id)
ORDER BY
	char_length DESC;

-- Checking for outliers

/*
Checking the MAX() for total Steps

36019 Steps and 28km
*/

SELECT
TOP 1
	*
FROM
	daily_activity
ORDER BY
	TotalSteps DESC;

/*
Checking the MIN() for total Steps

0 steps and 0km (which was to be expected)
*/

SELECT
TOP 1
	*
FROM
	daily_activity
-- WHERE TotalSteps > 0	-- 4 steps and 0km if this criteria is added
ORDER BY
	TotalSteps;

-- Both the MIN and the MAX for TotalSteps in daily_activity appear to be legitimate

-- Checking for outliers in daily_sleep
/*
When sorting by the TotalSleepRecords in DESC order, there are 46 records where users logged more than one sleep
record in a day - three of which logged 3 sleep records.  It is not my intention to include this variable
in the results/report. Also, there could be conditions that would explain having multiple sleep records in a day.
Therefore the determination was made to dismiss the possibility that they could become problematic.
*/

SELECT *
FROM daily_sleep
ORDER BY TotalSleepRecords DESC;

-- Checking the hourly_intensity table for outliers

/*
According to the data dictionary, the TotalIntensity field of the hourly_intensity table is calculated as the 
sum of the minute_intensity values for that hour.  0 = sedentary, 1 = light, 2 = moderate, and 3 = very active.  
The MAX() is 180 for the hourly TotalIntensity, which is a reasonable value for someone who might be running for
an hour.
Likewise, a TotalIntensity value of 0 would be equally reasonable for someone who is sedentary for an hour.
*/

SELECT 
TOP 1
*
FROM hourly_intensity
ORDER BY TotalIntensity DESC;
GO
SELECT 
TOP 1
*
FROM hourly_intensity
ORDER BY TotalIntensity;

-- Checking the minute_sleep table for outliers
/*
The only figures that could be present in the value field of the minute_sleep table are dictated 
by the device detected sleep state.
1 = asleep
2 = restless
3 = awake

All values fall within those parameters and no outliers appear to be present.
*/

SELECT 
TOP 1
*
FROM minute_sleep
ORDER BY value DESC;
GO
SELECT 
TOP 1
*
FROM minute_sleep
ORDER BY value;

-- Checking the weight_log table for outliers

SELECT
	DISTINCT(IsManualReport)  -- The only results are 'True' and 'False'
FROM
	weight_log;

/*
A quick visual scan is possible for these results because the dataset is so small.  It shows
that the figures in Kg, pounds, and BMI are all in line with each other with no discernable 
anomalies.
*/

SELECT
	*
FROM	
	weight_log
ORDER BY	
	WeightKg;

/*
Data Validation
I went back and double checked that the data is as accurate as I can make it.

Irrelevent data has either been removed or disregarded
Duplicate records were removed
Checked for any structural errors in the data
Adjusted data types when necessary
Checked for missing data
Checked for any outliers that need to be accounted for
Standardized the data for consistency by renaming tables
Validated the data by rechecking all of the above points
*/