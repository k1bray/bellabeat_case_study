USE [CaseStudy2-Bellabeat];

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
	COUNT(*) AS 'Count of Users wearing their devices for 24 hours'	-- 478 records
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