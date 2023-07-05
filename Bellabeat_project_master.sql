USE [CaseStudy2-Bellabeat];

-------------------------Data Cleaning and Profiling-------------------------------


-- Renaming tables to standardize table names and maintain schema consistency

exec sp_rename 'dailyActivity_merged', 'daily_activity';
GO
exec sp_rename 'dailyCalories_merged', 'daily_calories';
GO
exec sp_rename 'dailyIntensities_merged', 'daily_intensity';
GO
exec sp_rename 'dailySteps_merged', 'daily_steps';
GO
exec sp_rename 'secondsHeartrate_merged','seconds_heartrate';
GO
exec sp_rename 'hourlyCalories_merged', 'hourly_calories';
GO
exec sp_rename 'hourlyIntensities_merged', 'hourly_intensity';
GO
exec sp_rename 'hourlySteps_merged', 'hourly_steps';
GO
exec sp_rename 'minuteCaloriesNarrow_merged', 'minute_calories_narrow';
GO
exec sp_rename 'minuteCaloriesWide_merged', 'minute_calories_wide';
GO
exec sp_rename 'minuteIntensitiesNarrow_merged', 'minute_intensity_narrow';
GO
exec sp_rename 'minuteIntensitiesWide_merged', 'minute_intensity_wide';
GO
exec sp_rename 'minuteMETsNarrow_merged', 'minute_mets_narrow';
GO
exec sp_rename 'minuteSleep_merged', 'minute_sleep';
GO
exec sp_rename 'minuteStepsNarrow_merged', 'minute_steps_narrow';
GO
exec sp_rename 'minuteStepsWide_merged', 'minute_steps_wide';
GO
exec sp_rename 'sleepDay_merged', 'daily_sleep';
GO
exec sp_rename 'weightLogInfo_merged', 'weight_log';


-- Scratchpad area

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_intensity';


-- Exploring the minute_calories_narrow table

SELECT * FROM minute_calories_narrow;


-- Exploring the daily_activity table

SELECT * FROM daily_activity;   -- 940 rows


-- Checking the daily_activity table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_activity';

/*
During importation, all columns were designated as varchar(50).

Decided to alter some of the column datatypes.
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

-- Updating the daily_activity table

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_activity';

-- ActivityDate
-- TotalSteps
-- TotalDistance
-- TrackerDistance
-- LoggedActivitiesDistance
-- VeryActiveDistance
-- ModeratelyActiveDistance
-- LightActiveDistance
-- SedentaryActiveDistance
-- VeryActiveMinutes
-- FairlyActiveMinutes
-- LightlyActiveMinutes
-- SedentaryMinutes
-- Calories

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

/*
Inspecting the seconds_heartrate table schema
*/

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='seconds_heartrate';

/*
Inspecting the weight_log table schema
*/

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='weight_log';

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

-- Finding the count of users in the daily_activity table, the earliest and latest days in the study, as well as the calendar math from start to finish

SELECT
    COUNT(DISTINCT Id) AS user_count -- 33 users
    ,MIN(ActivityDate) AS earliest_date  -- 2016/04/12
    ,MAX(ActivityDate) AS latest_date   -- 2016/05/12
    ,DATEDIFF(D, MIN(ActivityDate), MAX(ActivityDate)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT ActivityDate) AS date_count     -- 31 days
FROM
    daily_activity;

-- Bringing up a quick list to manually inspect the date range

SELECT
    ActivityDate
FROM
    daily_activity
GROUP BY
    ActivityDate
ORDER BY
    ActivityDate;

-- Exploring the daily_sleep table

SELECT * FROM daily_sleep;   -- 413 rows

-- Checking the table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='daily_sleep';

-- Finding the count of users in the daily_sleep table, the earliest and latest days in the study, as well as the calendar math from start to finish

SELECT
    COUNT(DISTINCT Id) AS user_count -- 24 users
    ,MIN(SleepDay) AS earliest_date  -- 2016/04/12
    ,MAX(SleepDay) AS latest_date   -- 2016/05/12
    ,DATEDIFF(D, MIN(SleepDay), MAX(SleepDay)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT SleepDay) AS date_count     -- 31 days
FROM
    daily_sleep;

-- Exploring the hourly_intensity table

SELECT * FROM hourly_intensity;   -- 22099 rows

-- Checking the table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='hourly_intensity';

-- Finding the count of users in the hourly_intensity table, the earliest and latest days in the study, as well as the calendar math from start to finish

SELECT
    COUNT(DISTINCT Id) AS user_count -- 33 users
    ,MIN(ActivityHour) AS earliest_date  -- 2016-04-12 00:00:00.000
    ,MAX(ActivityHour) AS latest_date   -- 2016-05-12 15:00:00.000
    ,DATEDIFF(D, MIN(ActivityHour), MAX(ActivityHour)) +1 AS Difference  -- 31 days
    ,COUNT(DISTINCT ActivityHour) AS hour_count     -- 736 hours
    ,(COUNT(DISTINCT ActivityHour)/24) +1 AS day_count  -- 31 days
FROM
    hourly_intensity;


-- Exploring the minute_sleep table

SELECT * FROM minute_sleep;   -- 188521 rows

-- Checking the table schema

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='minute_sleep';

-- Finding the count of users in the minute_sleep table, the earliest and latest days in the study, as well as the calendar math from start to finish

SELECT
    COUNT(DISTINCT Id) AS user_count -- 24 users
    ,MIN(date) AS earliest_date  -- 2016-04-11 20:48:00.000
    ,MAX(date) AS latest_date   -- 2016-05-12 09:56:00.000
    ,DATEDIFF(D, MIN(date), MAX(date)) +1 AS Difference  -- 32 days
    ,COUNT(DISTINCT date) AS minute_count     -- 49773 minutes
    ,(COUNT(DISTINCT date)/1440) +1 AS day_count  -- 35 days
FROM
    minute_sleep;

-- Finding the count of users in the weight_log table, the earliest and latest days in the study, as well as the calendar math from start to finish

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
    sleep_records_per_id;

/*
Check for duplicate rows in daily_activity table.
https://stackoverflow.com/questions/37868495/how-find-duplicates-in-a-table-with-no-primary-key-or-id-field

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

/*
Dropping old sleepDay table
*/

DROP TABLE	-- Executed
	daily_sleep;

/*
Renaming sleepDay2 to sleepDay and completing the replacement of the table with no dupilicates.
*/

USE [CaseStudy2-Bellabeat];
GO
exec sp_rename 'sleepDay2', 'daily_sleep';

/*
Checking the table contents of the "new" daily_sleep table
*/

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
Renaming minute_sleep2 to minute_sleep and completing the replacement of the table with no dupilicates.
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

The fact that they are there could be an opportunity to pose a question about the population of the user group that 
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

-- Looking at how many records show users wearing their devices for a 24 hour period, thus giving a complete daily usage record.

SELECT	
	COUNT(*)	-- 478 records
FROM	
	daily_activity
WHERE
	VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440;

/*
Looking a list of Id's and how many full days they wore their fitness tracker.

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

Also, something to consider is that severall of the records have wicked low step counts.
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
The following query show 11 records where there is a discrepancy between the TotalDistance and the 
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
	*
FROM
	daily_activity
ORDER BY
	TotalSteps DESC;

/*
Checking the MIN() for total Steps

703 Steps and 1km
*/

SELECT
	*
FROM
	daily_activity
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

select * from daily_sleep;

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

SELECT *
FROM hourly_intensity
ORDER BY TotalIntensity DESC;

SELECT *
FROM hourly_intensity
ORDER BY TotalIntensity;

SELECT *
FROM minute_intensity_narrow
WHERE Id = 5577150313
	AND Intensity > 0;

-- Checking the minute_sleep table for outliers
/*
The only figures that could be present in the value field of the minute_sleep table are dictated 
by the device detected sleep state.
1 = asleep
2 = restless
3 = awake

All values fall within those parameters and no outliers appear to be present.
*/

select * from minute_sleep;

SELECT *
FROM minute_sleep
ORDER BY value DESC;

SELECT *
FROM minute_sleep
ORDER BY value;

-- Checking the weight_log table for outliers

SELECT * FROM weight_log;


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



-------------------------------------Analyzing the Data--------------------------------------

/*
The questions being posed by the stakeholders are 

1. What are some trends in smart device usage?

2. How could these trends be applied to Bellabeat customers?

3. How could these trends help influence the Bellabeat marketing strategy?
*/

/*
The focus for this study will be looking mainly at various ways in which participants use their fitness trackers.
Those are:
    - Daily activity vs device length of wear time
	- Daily activity vs higher/lower feature use (weight logging, overnight sleep tracking)
    - Automatic vs manually logged activiy
    - Which tracked features are being most/least utilized by looking at user-pool participation rates

An attempt will be made to determine if any relationships exists between these measures mostly using the daily timeframe
information, but may be corroborated with other time frames of tighter granularity.

The primary tables that I will be using are 
    daily_activity
    daily_sleep
	weight_log

Some tables that MAY offer some additional value are:
    hourly_intensity - what time of day to users tend to excercise?
    minute_sleep - There is a 'value' column that shows is a user was 1 = asleep, 2 = restless, 3 = awake
	seconds_heartrate
*/

SELECT TOP 10 * FROM daily_activity;

/*
This query shows a list of all of the participant Id's
*/

SELECT
	DISTINCT(Id)
FROM	
	daily_activity;

/*
This query shows a list of distinct user Id's and the total number of days that each user wore 
their device all day vs partial days.
*/

SELECT
	DISTINCT Id
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440 
		THEN 1 ELSE NULL END) as 'Full Day'
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes != 1440 
		THEN 0 ELSE NULL END) as 'Partial Day'
--	,AVG(TotalSteps) AS avg_daily_steps
FROM	
	daily_activity
GROUP BY
	Id
--	,ActivityDate
ORDER BY
	'Full Day' DESC
;

/*
The following query shows a list of all the user Id's and their average daily steps.
*/

DROP TABLE IF EXISTS #avg_steps_daily
SELECT
	DISTINCT(Id),
	ROUND(AVG(TotalSteps), 0)  AS avg_daily_steps
INTO #avg_steps_daily
FROM	
	daily_activity
GROUP BY
	Id
ORDER BY
	Id;
GO
SELECT * FROM #avg_steps_daily;

/*
The following query JOIN's the two previous queries to show the list of Id's, # of full days, # of partial days,
and their average daily steps over the case study period.

Looking over the distribution, there does not appear to be a direct correlation between high average daily step 
counts and all day device wearing.
*/

DROP TABLE IF EXISTS #avg_steps_daily
SELECT
	DISTINCT(Id),
	AVG(TotalSteps) AS avg_daily_steps
INTO #avg_steps_daily
FROM	
	daily_activity
GROUP BY
	Id
ORDER BY
	Id;

GO

SELECT
	DISTINCT act.Id
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440 
		THEN 1 ELSE NULL END) as 'Full Day'
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes != 1440 
		THEN 0 ELSE NULL END) as 'Partial Day'
	,avg_daily_steps
FROM	
	daily_activity AS act
LEFT JOIN
	#avg_steps_daily AS avg
		ON act.Id = avg.Id
GROUP BY
	act.Id
	,avg_daily_steps
--	,ActivityDate
ORDER BY
	avg_daily_steps DESC
;

/*
The following query uses a single Id record to double check the figures from the previous query.
*/

SELECT 
	Id
	,AVG(TotalSteps)
FROM 
	daily_activity
WHERE 
	Id = '8877689391' -- used '' because the datatype is set to varchar(50)
GROUP BY
	Id
;

/*
Exploring which users are wearing their devices "all day"
and which users are NOT wearing their devices "all day".
*/

DROP TABLE IF EXISTS #count_days_wearing
SELECT
	DISTINCT Id
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440 
		THEN 1 ELSE NULL END) as full_day
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes != 1440 
		THEN 0 ELSE NULL END) as partial_day
INTO #count_days_wearing
FROM	
	daily_activity
GROUP BY
	Id;

GO

SELECT 
	Id
	,full_day
	,partial_day
	,ROUND((partial_day / full_day), 2) AS days_wear_ratio
	,(partial_day / 31) * 100 AS partial_day_wear_pct
	,(full_day / 31) * 100 AS full_day_wear_pct
FROM
	#count_days_wearing
ORDER BY 
	full_day DESC;


SELECT * FROM #count_days_wearing;

/*
What does an average hourly user device wear-time distribution look like?

I can use the daily_activity table to find the number of hours per day that users 
were wearing their devices by adding all of the activity minutes and then dividing by 60.
The users that self report their activity levels might not be included.  However, that simply shows that
they are, in fact, not wearing their devices.
*/

SELECT TOP 100 
* 
FROM daily_activity;


DROP TABLE IF EXISTS #daily_active_hours
SELECT 
-- TOP 100
	Id
	,ActivityDate
	,TotalSteps
	,TotalDistance
	,TrackerDistance
	,Calories
	,ROUND((VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) / 60, 2) AS total_active_hours
INTO	
	#daily_active_hours
FROM 
	daily_activity;
GO
SELECT * 
FROM #daily_active_hours;

/*
Looking at a distribution of daily count of hourly wear times with a total count of records.

This query does not take into account that not all users have the same number of daily records.
*/


SELECT
	--Id
	COUNT(CASE WHEN total_active_hours BETWEEN 0 AND 0.99 THEN total_active_hours ELSE NULL END) AS 'Less than 1 hr'
	,COUNT(CASE WHEN total_active_hours between 1 AND 1.99 THEN total_active_hours ELSE NULL END) AS '1-2 hr'
	,COUNT(CASE WHEN total_active_hours between 2 AND 3.99 THEN total_active_hours ELSE NULL END) AS '2-4 hr'
	,COUNT(CASE WHEN total_active_hours between 4 AND 5.99 THEN total_active_hours ELSE NULL END) AS '4-6 hr'
	,COUNT(CASE WHEN total_active_hours between 6 AND 7.99 THEN total_active_hours ELSE NULL END) AS '6-8 hr'
	,COUNT(CASE WHEN total_active_hours between 8 AND 9.99 THEN total_active_hours ELSE NULL END) AS '8-10 hr'
	,COUNT(CASE WHEN total_active_hours between 10 AND 11.99 THEN total_active_hours ELSE NULL END) AS '10-12 hr'
	,COUNT(CASE WHEN total_active_hours between 12 AND 13.99 THEN total_active_hours ELSE NULL END) AS '12-14 hr'
	,COUNT(CASE WHEN total_active_hours between 14 AND 15.99 THEN total_active_hours ELSE NULL END) AS '14-16 hr'
	,COUNT(CASE WHEN total_active_hours between 16 AND 17.99 THEN total_active_hours ELSE NULL END) AS '16-18 hr'
	,COUNT(CASE WHEN total_active_hours between 18 AND 19.99 THEN total_active_hours ELSE NULL END) AS '18-20 hr'
	,COUNT(CASE WHEN total_active_hours between 20 AND 21.99 THEN total_active_hours ELSE NULL END) AS '20-22 hr'
	,COUNT(CASE WHEN total_active_hours between 22 AND 24 THEN total_active_hours ELSE NULL END) AS '22-24 hr'
	
	,(COUNT(CASE WHEN total_active_hours BETWEEN 0 AND 0.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 1 AND 1.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 2 AND 3.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 4 AND 5.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 6 AND 7.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 8 AND 9.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 10 AND 11.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 12 AND 13.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 14 AND 15.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 16 AND 17.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 18 AND 19.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 20 AND 21.99 THEN total_active_hours ELSE NULL END) +
	COUNT(CASE WHEN total_active_hours between 22 AND 24 THEN total_active_hours ELSE NULL END)) AS total_count_records
FROM 
	#daily_active_hours
--GROUP BY
--	Id
	;

/*
Taking a count of records per Id in the daily_activity table

The results from the previous query show a tally of records for each time-block.  The results from the
following query show a tally of records in the table grouped by Id.  Not all users have the same number 
of records.
21 out of the 33 total users show 31 days of activity.
*/


SELECT
	Id
	,COUNT(*) AS count_of_daily_records
FROM
	daily_activity
GROUP BY
	Id
ORDER BY
	count_of_daily_records DESC;

/*
What day of the week do users wear their devices most?  Least?
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);

/*
Using the previous query,
What is the average number of steps per day of the week.
What is the average number of calories burned per day of the week.
*/

SELECT TOP 100 
* 
FROM daily_activity;

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,ROUND(AVG(TotalSteps), 0) AS 'AVG Steps Per Day'
	,ROUND(AVG(Calories), 1) AS 'AVG Calories Per Day'
	,ROUND(AVG(TotalDistance), 1) AS 'AVG Total Distance Per Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);

/*
Using the previous query and adding averages of the various activity levels of minutes per day of the week.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,ROUND(AVG(TotalSteps), 0) AS 'AVG Steps Per Day'
	,ROUND(AVG(Calories), 1) AS 'AVG Calories Per Day'
	,ROUND(AVG(TotalDistance), 1) AS 'AVG Total Distance Per Day'
	,ROUND(AVG(VeryActiveMinutes), 0) AS 'AVG Very Active Minutes Per Day'
	,ROUND(AVG(FairlyActiveMinutes), 0) AS 'AVG Fairly Active Minutes Per Day'
	,ROUND(AVG(LightlyActiveMinutes), 0) AS 'AVG Lightly Active Minutes Per Day'
	,ROUND(AVG(SedentaryMinutes), 0) AS 'AVG Sedentary Minutes Per Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);


/*
Using the previous query and adding averages of the various activity levels of distance per day of the week.

Originally, I was not going to include these figures because I felt that the number of steps, calories burned, 
and the activity time duration was more applicable.  However, I decided to run the numbers anyway just to double check.
I'm glad that I did because now I can be more sure that they are not going to be applicable to the goals of this study.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,ROUND(AVG(TotalSteps), 0) AS 'AVG Steps Per Day'
	,ROUND(AVG(Calories), 1) AS 'AVG Calories Per Day'
	,ROUND(AVG(TotalDistance), 1) AS 'AVG Total Distance Per Day'
	,ROUND(AVG(VeryActiveMinutes), 0) AS 'AVG Very Active Minutes Per Day'
	,ROUND(AVG(FairlyActiveMinutes), 0) AS 'AVG Fairly Active Minutes Per Day'
	,ROUND(AVG(LightlyActiveMinutes), 0) AS 'AVG Lightly Active Minutes Per Day'
	,ROUND(AVG(SedentaryMinutes), 0) AS 'AVG Sedentary Distance Per Day'
	,ROUND(AVG(VeryActiveDistance), 0) AS 'AVG Very Active Distance Per Day'
	,ROUND(AVG(ModeratelyActiveDistance), 0) AS 'AVG Fairly Active Distance Per Day'
	,ROUND(AVG(LightActiveDistance), 0) AS 'AVG Lightly Active Distance Per Day'
	,ROUND(AVG(SedentaryActiveDistance), 0) AS 'AVG Sedentary Distance Per Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);


/*
What hour of the day on average are users most active?
*/

SELECT TOP 100 * FROM hourly_steps;


SELECT
	DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,ROUND(AVG(StepTotal), 0) AS 'AVG Steps Per Hour'
FROM 
	hourly_steps
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	DATEPART(HOUR, ActivityHour)
;

/*
Exploring how users are wearing their devices while they sleep.
*/

SELECT *
FROM daily_sleep;

/*
Finding a count of records per user Id.
*/

SELECT
	daily_activity.Id
	,COUNT(SleepDay) AS count_of_daily_sleep_records
FROM	
	daily_activity
	LEFT JOIN daily_sleep 
		ON dailY_sleep.Id = daily_activity.Id 
		AND daily_sleep.SleepDay = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY
	count_of_daily_sleep_records DESC;

/*
Finding the AVG hours asleep and time spent awake in bed per user Id.
*/

SELECT
	daily_activity.Id
	,ROUND((AVG(totalMinutesAsleep) / 60), 1) AS 'AVG Hours Asleep'
	,ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 1) AS 'AVG Time Awake In Bed'
 	,ROUND(AVG(daily_activity.TotalSteps),0) AS 'AVG Daily Steps'
FROM	
	daily_activity
	LEFT JOIN daily_sleep 
		ON dailY_sleep.Id = daily_activity.Id 
		AND dailY_sleep.SleepDay = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY 
	'AVG Hours Asleep' DESC;

/*
Finding the number of records for each day of the week.
*/

SELECT 
	DATEPART(WEEKDAY, SleepDay) AS 'Day # of Week'
	,DATENAME(WEEKDAY, SleepDay) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
FROM
	daily_sleep
GROUP BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay)
ORDER BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay);

/*
Finding the AVG hours asleep and AVG time spent awake in bed per day of the week.
*/

SELECT 
	DATEPART(WEEKDAY, SleepDay) AS 'Day # of Week'
	,DATENAME(WEEKDAY, SleepDay) AS 'Day of Week'
	,ROUND((AVG(totalMinutesAsleep) / 60), 1) AS 'AVG Hours Asleep'
	,ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 1) AS 'AVG Time Awake In Bed'
FROM
	daily_sleep
GROUP BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay)
ORDER BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay);

/*
Exploration of how users are logging their weight.
*/

SELECT *
FROM weight_log;

/*
Finding a count of records per user Id in the weight_log table.

The denisty of records is quite sparse.
*/

SELECT
	daily_activity.Id
	,COUNT(weight_log.date) AS count_of_daily_weight_records
FROM	
	daily_activity
	LEFT JOIN weight_log 
		ON weight_log.Id = daily_activity.Id 
		AND weight_log.date = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY
	count_of_daily_weight_records DESC;

/*
Finding the number of records for each day of the week of the weight_log table.

Given how sparse this table is, These results are mainly focused on the activity of a very
small group of people.
*/

SELECT 
	DATEPART(WEEKDAY, Date) AS 'Day # of Week'
	,DATENAME(WEEKDAY, DATE) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
FROM
	weight_log
GROUP BY
	DATEPART(WEEKDAY, Date)
	,DATENAME(WEEKDAY, Date)
ORDER BY
	DATEPART(WEEKDAY, Date)
	,DATENAME(WEEKDAY, Date);

/*
Finding the AVG weight per user in kg and converted to pounds.
*/

SELECT
	Id
	,ROUND(AVG(WeightKg), 1) AS 'AVG Weight(kg) per User'
	,ROUND((AVG(WeightKg) * 2.20462), 1) AS 'AVG Weight(lbs) per User'
FROM
	weight_log
GROUP BY
	Id
ORDER BY
	'AVG Weight(kg) per User' DESC;

/*
Exploration of USERS logging their weight automatically vs manually reporting.

Exploration of weight logs automatically vs manually reported.
*/

SELECT *
FROM weight_log;

/*
This query shows a list of user Id's and a count of their weight_log records separated by
manual and automatic recording of entries.

No one used both methods.  They either used one or the other.

The two users with the highest and most consistent weight log records each used different 
methods of data recording.
*/

SELECT
	COUNT(*) AS 'Total Record Count Per User'
	,Id
	,COUNT(CASE WHEN IsManualReport = 'True' THEN IsManualReport ELSE NULL END) AS 'Manual Record'
	,COUNT(CASE WHEN IsManualReport = 'False' THEN IsManualReport ELSE NULL END) AS 'Automatic Record'
FROM
	weight_log
GROUP BY
	Id;

/*
The following query returns a table with the total number of records for each category of 
manual or automatic recording of weight info.
*/

SELECT
	COUNT(*) AS 'Total Record Count' -- 67 records
	,COUNT(CASE WHEN IsManualReport = 'True' THEN IsManualReport ELSE NULL END) AS 'Manual Record' -- 41 records
	,COUNT(CASE WHEN IsManualReport = 'False' THEN IsManualReport ELSE NULL END) AS 'Automatic Record' -- 26 records
FROM
	weight_log

/*
What are the participation rates for the user pool for different trackable functions?

	-weight logging
	-sleep tracking
	-step counting
*/

-- scratchpad area
SELECT TOP 1
	*
FROM daily_activity;

SELECT TOP 1
	*
FROM daily_sleep;

SELECT TOP 1
	*
FROM weight_log;

/*
The following query shows a table with distinct Id's and counts of records for daily steps, sleep, and weight.
*/

SELECT
	DISTINCT(daily_activity.Id)
	,COUNT(daily_activity.TotalSteps) AS count_daily_step_records_per_id
	,COUNT(SleepDay) AS count_daily_sleep_records_per_id
	,COUNT(WeightKg) AS count_daily_weight_records_per_id
FROM	
	daily_activity
	LEFT JOIN daily_sleep 
		ON dailY_sleep.Id = daily_activity.Id 
		AND daily_sleep.SleepDay = daily_activity.ActivityDate
	LEFT JOIN weight_log
		ON daily_sleep.Id = weight_log.Id
		AND daily_sleep.SleepDay = weight_log.Date
GROUP BY
	daily_activity.Id
ORDER BY
	count_daily_sleep_records_per_id DESC;

/*
The following query begins a section where I hope to explore any relationship between activity levels
and participation in other features.  In this case I am looking at the weight_log table.
*/

SELECT * FROM weight_log;

-- This query brings up a list of the user Id's in the weight_log table.
-- There are 8 user Id's.
SELECT
	DISTINCT(Id)
FROM
	weight_log;

-- Confirmation of 8 users
SELECT
	COUNT(DISTINCT(Id)) AS 'Num Users'  -- 8 users
FROM
	weight_log;

/*
Taking a count of records per Id.

The results aren't very impressive.
Out of 8 Ids, 6 have single digits, one has 24, and one has 30.

Created a temp table to be able to JOIN the results with the other records counts from previous.
*/

DROP TABLE IF EXISTS #weight_records_count
SELECT
	Id
	,COUNT(Id) AS records_per_id
INTO #weight_records_count
FROM
	weight_log
GROUP BY
	Id
ORDER BY
	records_per_id DESC;

GO

SELECT * FROM #weight_records_count;

/*
The following query JOINs the temp table from the weight_log records with the previous queries finding the 
counts of records per Id for wearing the device all day, as well as the average steps per day for each user.

The results are sparse, at best.
There does not appear to be any significant correlation between either how long someone wears their
fitness tracker, or the average of how many steps they take in a day, against the number of weight records
they log.  In fact, the two users with the highest and most consistent weight log records, not only had 
opposite data collection methods, but also have opposite habits regarding all-day/partial-day wear of their
devices.
*/

DROP TABLE IF EXISTS #weight_records_count
SELECT
	Id
	,COUNT(Id) AS weight_records_per_id
INTO #weight_records_count
FROM
	weight_log
GROUP BY
	Id
ORDER BY
	weight_records_per_id DESC;

GO

DROP TABLE IF EXISTS #avg_steps_daily
SELECT
	DISTINCT(Id),
	ROUND(AVG(TotalSteps), 0) AS avg_daily_steps
INTO #avg_steps_daily
FROM	
	daily_activity
GROUP BY
	Id
ORDER BY
	Id;

GO

SELECT
	DISTINCT act.Id
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440 
		THEN 1 ELSE NULL END) as 'Full Day'
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes != 1440 
		THEN 0 ELSE NULL END) as 'Partial Day'
	,avg.avg_daily_steps
	,weight.weight_records_per_id
FROM	
	daily_activity AS act
LEFT JOIN
	#avg_steps_daily AS avg
		ON act.Id = avg.Id
FULL JOIN
	#weight_records_count AS weight
		ON act.Id = weight.Id
GROUP BY
	act.Id
	,avg.avg_daily_steps
	,weight.weight_records_per_id
ORDER BY
	weight.weight_records_per_id DESC
	,avg.avg_daily_steps DESC
;