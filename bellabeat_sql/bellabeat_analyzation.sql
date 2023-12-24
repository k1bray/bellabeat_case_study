USE [CaseStudy2-Bellabeat];

-------------------------------------Analyzing the Data--------------------------------------

/*
The questions being posed by the stakeholders are:

1. What are some trends in smart device usage?
2. How could these trends be applied to Bellabeat customers?
3. How could these trends help influence the Bellabeat marketing strategy?
*/

/*
Getting a list of all of the participant Id's.
While profiling the data, it appears that the daily_activity table is the most comprehensive table in the dataset.
This would make some sense when you consider that the data in the daily_activity table is made up 
of data that would be the most likely to be automatically collected, as long as the users are wearing their
tracking devices.
*/

SELECT
	DISTINCT(Id)
FROM	
	daily_activity;

/*
List of distinct user Id's and the total number of days that each user wore 
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
	'Full Day' DESC;

/*
List of all the user Id's and their average daily steps.
*/

DROP TABLE IF EXISTS #avg_steps_daily
SELECT
	DISTINCT(Id),
	ROUND(AVG(TotalSteps), 0)  AS avg_daily_steps
INTO #avg_steps_daily
FROM	
	daily_activity
GROUP BY
	Id;
GO
SELECT 
	*
FROM 
	#avg_steps_daily
ORDER BY avg_daily_steps DESC;

/*
Joining the two previous queries to show the list of Id's, # of full days, # of partial days,
and their average daily steps over the case study period.

Looking over the distribution, there does not appear to be a strong correlation between high average daily step 
counts and all day device wearing.  However, viewing the results sorted by average daily steps in descending order,
there id a cluster of records between index position 6 and 14 that all show moderately high average daily steps
above the index median.
*/

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
	avg_daily_steps DESC;

/*
Using a single Id record to double check the figures from the previous query.
*/

SELECT 
	Id
	,AVG(TotalSteps) AS avg_TotalSteps
FROM 
	daily_activity
WHERE 
	Id = '8877689391' -- used '' because the datatype is set to varchar(50)
GROUP BY
	Id;

/*
Exploring which users are wearing their devices "all day"
and which users are NOT wearing their devices "all day".
*/

--DROP TABLE IF EXISTS #count_days_wearing
SELECT
	DISTINCT Id
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes = 1440 
		THEN 1 ELSE NULL END) as count_full_day
	,COUNT(CASE WHEN VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes != 1440 
		THEN 0 ELSE NULL END) as count_partial_day
--INTO #count_days_wearing
FROM	
	daily_activity
GROUP BY
	Id
ORDER BY
	count_full_day DESC;
--GO
--SELECT * FROM #count_days_wearing;

/*
We are left to assume from the data dictionary that these 32 records are from activity that was 
manually logged by the user
*/

SELECT * FROM daily_activity WHERE LoggedActivitiesDistance > 0;

-- Creating #daily_active_hours temp table

DROP TABLE IF EXISTS #daily_active_hours
SELECT 
-- TOP 100
	Id
	,ActivityDate
	,TotalSteps
	,TotalDistance
	,TrackerDistance
	,Calories
	,ROUND((VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) / 60, 2) 
		AS total_active_hours
INTO #daily_active_hours
FROM 
	daily_activity;
GO
SELECT * 	-- Checking the contents of the temp table
FROM #daily_active_hours
ORDER BY 
--	TotalSteps DESC
	total_active_hours DESC;

--Finding an average daily wear time per user Id based on #daily_active_hours.

SELECT
	Id
	,ROUND(AVG(total_active_hours), 1) AS avg_active_hours_per_Id
FROM
	#daily_active_hours
GROUP BY
	Id
ORDER BY
	avg_active_hours_per_Id DESC;

--Finding an average daily wear time per user Id against average daily steps based on #daily_active_hours.

SELECT
	Id
	,ROUND(AVG(total_active_hours), 1) AS avg_active_hours_per_Id
	,ROUND(AVG(TotalSteps), 1) AS avg_daily_steps_per_Id
FROM
	#daily_active_hours
GROUP BY
	Id
ORDER BY
	avg_active_hours_per_Id DESC;

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
	,COUNT(CASE WHEN total_active_hours between 22 AND 23.9 THEN total_active_hours ELSE NULL END) AS '22-24 hr'
	,COUNT(CASE WHEN total_active_hours = 24 THEN total_active_hours ELSE NULL END) AS '24 hr'
	
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
	COUNT(CASE WHEN total_active_hours between 22 AND 24 THEN total_active_hours ELSE NULL END)) 
		AS total_count_records
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
21 out of the 33 total users show 31 days of activity (which is the full length of the study).
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
What day of the week do users wear their devices most? Least?
Finding averages of the various activity levels of steps, calories, and distance per day of the week.

Originally, I was not going to include these figures because I felt that the number of steps, calories burned, 
and the activity time duration was more applicable.  However, I decided to run the numbers anyway just to double check.
I'm glad that I did because now I can be more sure that they are not going to be applicable to the goals of this study.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
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
What hour of the day are users most active based on average steps per hour?
*/

SELECT
	DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,ROUND(AVG(StepTotal), 0) AS 'AVG Steps Per Hour'
FROM 
	hourly_steps
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	DATEPART(HOUR, ActivityHour);

/*
Exploring how users are wearing their devices while they sleep.
Finding a count of sleep records per user Id.  To get a complete list of all Id's in the study
I JOINed the daily_sleep table with the daily_activity table.  This shows which Id's have no
records in the daily_sleep table.
*/

SELECT
	daily_activity.Id
	,COUNT(SleepDay) AS count_of_daily_sleep_records
FROM	
	daily_activity
	LEFT JOIN daily_sleep 
		ON daily_sleep.Id = daily_activity.Id 
		AND daily_sleep.SleepDay = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY
	count_of_daily_sleep_records DESC;

/*
Finding the AVG hours asleep and time spent awake in bed per user Id for the users.

By changing the JOIN type from FULL to INNER the query eliminates or excludes any users from the 
daily_activity table that would contain a NULL in any of the sleep-related columns.
*/

SELECT
	daily_activity.Id
	,COUNT(SleepDay) AS count_of_daily_sleep_records
	,ROUND((AVG(totalMinutesAsleep) / 60), 1) AS 'AVG Hours Asleep'
	,ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 1) AS 'AVG Mins Awake In Bed'
 	,ROUND(AVG(daily_activity.TotalSteps),0) AS 'AVG Daily Steps'
FROM	
	daily_activity
	INNER JOIN daily_sleep 
		ON daily_sleep.Id = daily_activity.Id 
		AND daily_sleep.SleepDay = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY 
	count_of_daily_sleep_records DESC;

/*
Finding the AVG hours asleep and AVG time spent awake in bed per day of the week.
Sunday has both the highest value for AVG Hours Asleep and the highest value for AVG Mins Awake In Bed.
Thursday inches in behind for the least AVG Hours Asleep for the week.  Except for Sunday and Wednesday
The AVG values are all so close that I had to expand the ROUND() out to 2 deciaml places for a higher
degree of acuracy.  Thursday also has the lowest value of the week for the AVG Mins Awake In Bed
*/

SELECT 
	DATEPART(WEEKDAY, SleepDay) AS 'Day # of Week'
	,DATENAME(WEEKDAY, SleepDay) AS 'Day of Week'
	,COUNT(*) AS 'Daily Sleep Records'
	,ROUND((AVG(totalMinutesAsleep) / 60), 2) AS 'AVG Hours Asleep'
	,ROUND(((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep))/60), 2) AS 'AVG Hrs Awake In Bed'
	,ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 2) AS 'AVG Mins Awake In Bed'
FROM
	daily_sleep
GROUP BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay)
ORDER BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay);

/*
What is the overall AVG Hours Asleep for the user group (6.99 hours)?
What is the overall AVG Mins Awake for the user group (39.31 mins)?
*/

SELECT 
	ROUND((AVG(totalMinutesAsleep) / 60), 2) AS 'AVG Hours Asleep' -- 6.99 Hours
	,ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 2) AS 'AVG Mins Awake In Bed' -- 39.31 Mins
FROM
	daily_sleep;

/*
Finding a count of records per user Id in the weight_log table.
The density of records is quite sparse.
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
Observation:
Users were least likely to log their weight on Friday and Saturday.
*/

SELECT 
	DATEPART(WEEKDAY, Date) AS 'Day # of Week'
	,DATENAME(WEEKDAY, DATE) AS 'Day of Week'
	,COUNT(*) AS 'Daily Weight Records'
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
	,ROUND(AVG(WeightPounds), 1) AS 'AVG Weight(lbs) per User'
	,MAX(WeightKg) AS max_wt
	,MIN(WeightKg) AS min_weight
FROM
	weight_log
GROUP BY
	Id
ORDER BY
	'AVG Weight(kg) per User' DESC;

/*
Pulling out the records for the two users that most utilized the weight_log feature.
*/

SELECT
	Id
	,ROUND(AVG(WeightKg), 1) AS 'AVG Weight(kg) per User'
	,ROUND((AVG(WeightKg) * 2.20462), 1) AS 'AVG Weight(lbs) per User'
	,MAX(WeightKg) AS max_wt
	,MIN(WeightKg) AS min_weight
FROM
	weight_log
WHERE
	Id = '6962181067'
	OR
	Id = '8877689391'
GROUP BY
	Id
ORDER BY
	'AVG Weight(kg) per User' DESC;

/*
For the two users that had the most records in the weight_log table, how did their weight values 
change over the course of the study period?

Id = '6962181067' at 63kg on 2016-04-12 and ended at 62kg on 2016-05-12  61 kg was their min 
weight for the study period.

Id = '8877689391' at 86kg on 2016-04-12 and ended at 84kg on 2016-05-12. 84kg was their min 
weight for the study period
*/

SELECT TOP 1
	*
FROM
	weight_log
WHERE
	Id = '6962181067'
ORDER BY
	Date;
GO
SELECT TOP 1
	*
FROM
	weight_log
WHERE
	Id = '6962181067'
ORDER BY
	Date DESC;
GO
SELECT TOP 1
	*
FROM
	weight_log
WHERE
	Id = '8877689391'
ORDER BY
	Date;
GO
SELECT TOP 1
	*
FROM
	weight_log
WHERE
	Id = '8877689391'
ORDER BY
	Date DESC;

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
	,COUNT(CASE WHEN IsManualReport = 'True' THEN IsManualReport ELSE NULL END) 
		AS 'Manual Record'
	,COUNT(CASE WHEN IsManualReport = 'False' THEN IsManualReport ELSE NULL END) 
		AS 'Automatic Record'
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
	,COUNT(CASE WHEN IsManualReport = 'True' THEN IsManualReport ELSE NULL END) 
		AS 'Manual Record' -- 41 records
	,COUNT(CASE WHEN IsManualReport = 'False' THEN IsManualReport ELSE NULL END) 
		AS 'Automatic Record' -- 26 records
FROM
	weight_log;

/*
The following query shows a table with distinct Id's and counts of records for daily steps, sleep, 
and weight.
*/

SELECT
	DISTINCT(daily_activity.Id)
	,COUNT(daily_activity.TotalSteps) AS count_daily_step_records_per_id
	,COUNT(SleepDay) AS count_daily_sleep_records_per_id
	,COUNT(WeightKg) AS count_daily_weight_records_per_id
FROM	
	daily_activity
	LEFT JOIN daily_sleep 
		ON daily_sleep.Id = daily_activity.Id 
		AND daily_sleep.SleepDay = daily_activity.ActivityDate
	LEFT JOIN weight_log
		ON daily_activity.Id = weight_log.Id
		AND daily_activity.ActivityDate = weight_log.Date
GROUP BY
	daily_activity.Id
ORDER BY
	count_daily_sleep_records_per_id DESC;

/*
The following query begins a section where I hope to explore any relationship between activity levels
and participation in other features.  In this case I am looking at the weight_log table.
*/

--scratchpad
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

Created a temp table to be able to JOIN the results with the other record counts from previous.
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
they log.  In fact, the two users with the highest and most consistent weight log records, not utilized 
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
	,avg.avg_daily_steps DESC;

/*
Is there a connection/correlation between daily activity and sleep quality/habits?

Specifically, do higher daily step counts correlate with longer duration/more restful sleep?
*/

Select TOP 5
	Id
	,ActivityDate
	,TotalSteps
	,Calories
FROM 
	daily_activity;
GO
Select TOP 5 
	*
FROM 
	daily_sleep;
GO
SELECT TOP 20
	*
FROM
	minute_sleep;

/*
I need a query that compares daily total step counts with sleep quality.  The daily_sleep table has columns
for TotalMinutesAsleep and TotalTimeInBed.  It also has a column for TotalSleepRecords for that day.  The
minute_sleep table has a column for value which respresents a measure for the users state of rest at 
that minute.  If I extract the 'date' from the minute_sleep.date column, the minute_sleep.value column, 
when taken in daily aggregation, would most likely represent more than one 'daily sleep record',
due to the nature of time math, and that the 'date' column rolls over in the middle of the night
when it would be likely that most users where sleeping.


daily_activity.TotalSteps
daily_activity.Calories

daily_sleep.TotalMinutesAsleep
daily_sleep.TotalMinutesInBed

minute_sleep.value
*/


SELECT *	--0 records
FROM minute_sleep
WHERE
	Id IS NULL;


SELECT *	--0 records
FROM minute_sleep
WHERE
	date IS NULL;


SELECT *	--0 records
FROM minute_sleep
WHERE
	value IS NULL;

SELECT *	--0 records
FROM minute_sleep
WHERE
	logId IS NULL;

/*
Trying to figure out if there is potential to use the minuteSleep table to gain insight on sleep patterns.

From the fitabase Database dictionary:
	1 = asleep
	2 = restless
	3 = awake
*/

SELECT
	DATEPART(WEEKDAY, date) AS '# Day of Week'
	,DATENAME(WEEKDAY, date) AS 'Day of Week'
	,(COUNT(CASE WHEN value = 1 THEN 'Asleep' ELSE NULL END))/33 AS 'AVG Mins Asleep'
	,(COUNT(CASE WHEN value = 2 THEN 'Restless' ELSE NULL END))/33 AS 'AVG Mins Restless'
	,(COUNT(CASE WHEN value = 3 THEN 'Awake' ELSE NULL END))/33 AS 'AVG Mins Awake'
	--,ROUND((CAST((AVG(TotalMinutesAsleep)) AS FLOAT)/60), 2) AS 'AVG Hours Asleep'
	--,AVG(TotalTimeInBed) AS 'AVG Mins in Bed'
	--,ROUND((CAST((AVG(TotalTimeInBed)) AS FLOAT)/60), 2) AS 'AVG Hours in Bed'
	--,ROUND((((CAST(AVG(TotalMinutesAsleep) AS FLOAT) / CAST(AVG(TotalTimeInBed) AS FLOAT)) * 100)), 0) AS 'Sleep Time % in Bed'
FROM
	minute_sleep
WHERE
	date IS NOT NULL
GROUP BY
	DATEPART(WEEKDAY, date)
	,DATENAME(WEEKDAY, date)
ORDER BY
	DATEPART(WEEKDAY, date);

/*
***********************************************


I don't like this query.  The fact that it's being divided by 33 doesn't sit right.
It doesn't actually show an "average".
*/

SELECT
	DATEPART(WEEKDAY, date) AS '# Day of Week'
	,DATENAME(WEEKDAY, date) AS 'Day of Week'
	,(COUNT(CASE WHEN value = 1 THEN 'Asleep' ELSE NULL END))/33 AS 'AVG Mins Asleep'
	,(COUNT(CASE WHEN value = 2 THEN 'Restless' ELSE NULL END))/33 AS 'AVG Mins Restless'
	,(COUNT(CASE WHEN value = 3 THEN 'Awake' ELSE NULL END))/33 AS 'AVG Mins Awake'
	,ROUND(AVG(TotalSteps), 0) AS avg_daily_steps
	--,ROUND((CAST((AVG(TotalMinutesAsleep)) AS FLOAT)/60), 2) AS 'AVG Hours Asleep'
	--,AVG(TotalTimeInBed) AS 'AVG Mins in Bed'
	--,ROUND((CAST((AVG(TotalTimeInBed)) AS FLOAT)/60), 2) AS 'AVG Hours in Bed'
	--,ROUND((((CAST(AVG(TotalMinutesAsleep) AS FLOAT) / CAST(AVG(TotalTimeInBed) AS FLOAT)) * 100)), 0) AS 'Sleep Time % in Bed'
FROM
	minute_sleep
JOIN
	daily_activity
	ON minute_sleep.Id = daily_activity.Id
WHERE
	date IS NOT NULL
GROUP BY
	DATEPART(WEEKDAY, date)
	,DATENAME(WEEKDAY, date)
ORDER BY
	DATEPART(WEEKDAY, date);

/*
Finding the percentage of time that people are sleeping vs the total time they spend in bed.
*/

SELECT
	Id
	,ROUND((((CAST(AVG(TotalMinutesAsleep) AS FLOAT) / CAST(AVG(TotalTimeInBed) AS FLOAT)) * 100)), 0) 
		AS 'Sleep Time % in Bed'
FROM
	daily_sleep
GROUP BY
	Id
ORDER BY
	'Sleep Time % in Bed';

/*
Comparison of AVG time spent sleeping vs AVG time spent in bed by day of the week.
*/

SELECT
	DATEPART(WEEKDAY, SleepDay) AS 'Day of Week'
	,DATENAME(WEEKDAY, SleepDay) AS 'Name Day of Week'
	,ROUND(AVG(TotalMinutesAsleep), 1) AS 'AVG Mins Asleep'
	,ROUND((CAST((AVG(TotalMinutesAsleep)) AS FLOAT)/60), 2) AS 'AVG Hours Asleep'
	,ROUND(AVG(TotalTimeInBed), 1) AS 'AVG Mins in Bed'
	,ROUND((CAST((AVG(TotalTimeInBed)) AS FLOAT)/60), 2) AS 'AVG Hours in Bed'
	,ROUND((((CAST(AVG(TotalMinutesAsleep) AS FLOAT) / CAST(AVG(TotalTimeInBed) AS FLOAT)) * 100)), 0) 
		AS 'Sleep Time % in Bed'
FROM
	daily_sleep
GROUP BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay)
ORDER BY
	DATEPART(WEEKDAY, SleepDay);








SELECT
	DATEPART(WEEKDAY, date) AS 'Day # of Week'
	,DATENAME(WEEKDAY, date) AS 'Day of Week'
	,COUNT(CASE WHEN value = 1 THEN Id ELSE NULL END) AS asleep
	,COUNT(CASE WHEN value = 2 THEN Id ELSE NULL END) AS restless
	,COUNT(CASE WHEN value = 3 THEN Id ELSE NULL END) AS awake
FROM
	minute_sleep
GROUP BY
	DATEPART(WEEKDAY, date)
	,DATENAME(WEEKDAY, date)
ORDER BY
	DATEPART(WEEKDAY, date)
	,DATENAME(WEEKDAY, date);















SELECT
	daily_activity.Id
	,TotalSteps
	,Calories
FROM
	daily_activity;


SELECT 
	Id
	,COUNT(date) AS records_per_id
FROM
	minute_sleep
GROUP BY
	Id
ORDER BY
	records_per_id DESC;






SELECT
	daily_activity.Id
	,COUNT(daily_activity.TotalSteps) AS count_daily_step_records_per_id
	,COUNT(minute_sleep.date) AS count_minute_sleep_records_per_id
FROM	
	daily_activity
	FULL OUTER JOIN minute_sleep 
		ON minute_sleep.Id = daily_activity.Id 
	--	AND minute_sleep.date = daily_activity.ActivityDate
GROUP BY
	daily_activity.Id
ORDER BY
	count_minute_sleep_records_per_id DESC;










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
	avg_daily_steps DESC;









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
One thing to keep in mind is that in the wight_log table there is a column for 'Fat' which is mostly
comprised of NULL values.  This is another underutilized feature of the Fitbit tracker.
*/


/*
I found an article that was talking about optimal heart rate during exercise.  I was trying to find a count of the minutes that 
users were spending in their "optimal" heart rate.  Of course, this is all age and fitness level dependent.
However, I thought it was a good idea.

This is the error message I got:
Msg 130, Level 15, State 1, Line 47
Cannot perform an aggregate function on an expression containing an aggregate or a subquery.
*/

SELECT
	Id
	,COUNT (*) AS 'Records Per User'
	,COUNT(CASE WHEN Value BETWEEN (MAX(Value) * 0.5) AND (MAX(Value) * 0.7) Then Id ELSE NULL END)
	,AVG(Value) AS 'AVG Heart Rate'
	,MIN(Value) AS 'MIN Heart Rate'
	,MAX(Value) AS 'MAX Heart Rate'
	,MAX(Value) - MIN(Value) AS 'Range Of Heart Rate'
FROM
	seconds_heartrate
GROUP BY
	Id;

/*
In the following query I created a temp table that used the records from the secondsHeartrate table and added columns
for the range of "optimal" workout heart rate.  I was thinking that maybe I could do a count based on the MAX heart rate
grouped by Id which would show how much time users are spending in the "zone". 
*/

DROP TABLE IF EXISTS #heart_rate_range
SELECT
	Id
	,Time 
	,Value
	,Value * 0.5 AS '0.5 Value'
	,Value * 0.7 AS '0.7 Value'
INTO #heart_rate_range
FROM 
	seconds_heartrate
;

SELECT * FROM #heart_rate_range;








/*
AVG daily total dailyActivity by day of the week.
*/

SELECT
	DATEPART(WEEKDAY, ActivityDate) AS 'day of week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,AVG(TotalSteps) AS 'AVG Tot Steps/Day'
	--,ROUND(AVG(TotalDistance), 1) AS 'AVG Tot Dist km/Day'
	--,ROUND(AVG(TrackerDistance), 1) AS 'AVG Tracked Dist km/Day'
	--,ROUND(AVG(VeryActiveDistance), 1) AS 'AVG Very Active Dist km/Day'
	--,ROUND(AVG(ModeratelyActiveDistance), 1) AS 'AVG Mod Active Dist km/Day'
	--,ROUND(AVG(LightActiveDistance), 1) AS 'AVG Lt Active Dist km/Day'
	--,ROUND(AVG(SedentaryActiveDistance), 3) AS 'AVG Sed Active Dist km/Day'
	,AVG(VeryActiveMinutes) AS 'AVG Very Active Mins/Day'
	,AVG(FairlyActiveMinutes) AS 'AVG Mod Active Mins/Day'
	,AVG(LightlyActiveMinutes) AS 'AVG Lt Active Mins/Day'
	,AVG(SedentaryMinutes) AS 'AVG Sed Active Mins/Day'
	,AVG(Calories) AS 'AVG Cals/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	'day of week';





/*
AVG daily total distance in km per user overall
The following query shows that there is a sizable variance between the highest (13.21) average and the lowest (0.63)
This query is useful to show the variance in average daily distance between the most active user to the least active user.
*/

SELECT
	 Id
	,ROUND(AVG(TotalDistance), 1) AS 'AVG total Dist in km/Day'
FROM
	daily_activity
GROUP BY
	Id
ORDER BY
	'AVG total Dist in km/Day' DESC;

/*
AVG daily total distance in km overall for the test pool per day.
This query shows that the test pool daily average is 5.5km/day.
However, that is total distance and does not group by activity intensity.
*/

SELECT
	ROUND(AVG(TotalDistance), 1) AS 'AVG total Dist in km/Day' -- 5.5
FROM
	daily_activity;	

/*
AVG Active minutes per day of the week when corresponding activity minutes are > 0.

The two linked queries below show some interesting differences, but also some interesting
similarities.  The column for 'AVG Sed Active Mins/Day' is almost identical with only a slight
difference on Thursday.  'AVG Lt Active Mins/Day' shows some moderate differences.
'AVG Mod Active Mins/Day' and 'AVG Very Active Mins/Day' both show significant differences.
These differences occur when days with '0' minutes of activity in a certain level is logged.

The question is whether days with a '0' should be treated as an outlier, or included in the 
calculated results.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,AVG(CASE WHEN VeryActiveMinutes > 0 THEN VeryActiveMinutes ELSE NULL END) AS 'AVG Very Active Mins/Day'
	,AVG(CASE WHEN FairlyActiveMinutes > 0 THEN FairlyActiveMinutes ELSE NULL END) AS 'AVG Mod Active Mins/Day'
	,AVG(CASE WHEN LightlyActiveMinutes > 0 THEN LightlyActiveMinutes ELSE NULL END) AS 'AVG Lt Active Mins/Day'
	,AVG(CASE WHEN SedentaryMinutes > 0 THEN SedentaryMinutes ELSE NULL END) AS 'AVG Sed Active Mins/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate);
GO
SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,AVG(CASE WHEN VeryActiveMinutes >= 0 THEN VeryActiveMinutes ELSE NULL END) AS 'AVG Very Active Mins/Day'
	,AVG(CASE WHEN FairlyActiveMinutes >= 0 THEN FairlyActiveMinutes ELSE NULL END) AS 'AVG Mod Active Mins/Day'
	,AVG(CASE WHEN LightlyActiveMinutes >= 0 THEN LightlyActiveMinutes ELSE NULL END) AS 'AVG Lt Active Mins/Day'
	,AVG(CASE WHEN SedentaryMinutes >= 0 THEN SedentaryMinutes ELSE NULL END) AS 'AVG Sed Active Mins/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate);





/*
AVG active distance in km by (corresponding) active minutes per day of the week
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,ROUND(AVG(CASE WHEN VeryActiveMinutes > 0 THEN VeryActiveDistance ELSE NULL END), 1) AS 'AVG Very Active Dist km/Day'
	,ROUND(AVG(CASE WHEN FairlyActiveMinutes > 0 THEN ModeratelyActiveDistance ELSE NULL END), 1) AS 'AVG Mod Active Dist km/Day'
	,ROUND(AVG(CASE WHEN LightlyActiveMinutes > 0 THEN LightActiveDistance ELSE NULL END), 1) AS 'AVG Lt Active Dist km/Day'
	,ROUND(AVG(CASE WHEN SedentaryMinutes > 0 THEN SedentaryActiveDistance ELSE NULL END), 3) AS 'AVG Sed Active Dist km/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate);




/*
AVG Active distance in km per day of the week when cooresponding distances are > 0.

The results of this query are similar to the results from the previous one.
However, there are slight differences, especially in the AVG SedentaryActiveMinutes Column.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,ROUND(AVG(CASE WHEN VeryActiveDistance > 0 THEN VeryActiveDistance ELSE NULL END), 1) AS 'AVG Very Active Dist km/Day'
	,ROUND(AVG(CASE WHEN ModeratelyActiveDistance > 0 THEN ModeratelyActiveDistance ELSE NULL END), 1) AS 'AVG Mod Active Dist km/Day'
	,ROUND(AVG(CASE WHEN LightActiveDistance > 0 THEN LightActiveDistance ELSE NULL END), 1) AS 'AVG Lt Active Dist km/Day'
	,ROUND(AVG(CASE WHEN SedentaryActiveDistance > 0 THEN SedentaryActiveDistance ELSE NULL END), 3) AS 'AVG Sed Active Dist km/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate);


/*
This was a query from a table that I created that combined all of the hourly data into one table.
The next several queries use this table.




Overall averages of the hourly table per day of the week

*NOTE*
According to the data dictionary, TotalIntensity is the value calculated by adding all the minute-level 
intensity values that occurred within the hour
and the AverageIntensity is the average intensity state exhibited during that hour (TotalIntensity 
for that ActivityHour divided by 60).
*/

SELECT
	DATEPART(WEEKDAY, ActivityHour) AS 'day of week'
	,DATENAME(WEEKDAY, ActivityHour) AS 'Name Day of Week'
	,AVG(StepTotal) AS 'AVG Total Steps Per hour'
	,AVG(TotalIntensity) AS 'AVG Total Intensity Per Hour'
	,ROUND(AVG(AverageIntensity), 3) AS 'AVG Hourly Intensity Average Per Hour'
	,AVG(Calories) AS 'AVG Calories Per Hour'
FROM
	hourly_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityHour)
	,DATENAME(WEEKDAY, ActivityHour)
ORDER BY
	'day of week';

/*
What time of day had the highest AVG step count?
*/

SELECT TOP 1
	 DATEPART(HOUR, ActivityHour) AS 'Hour of Day'	-- 18:00
	,AVG(StepTotal) AS 'AVG Steps/Hour'
FROM
	hourly_activity
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	'AVG Steps/Hour' DESC;

/*
What time of day had the lowest AVG step count?
*/

SELECT TOP 1
	 DATEPART(HOUR, ActivityHour) AS 'Hour of Day'	-- 03:00
	,AVG(StepTotal) AS 'AVG Steps/Hour'
FROM
	hourly_activity
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	'AVG Steps/Hour';

/*
Showing a full day distribution of AVG step count per hour
*/

SELECT
	 DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,AVG(StepTotal) AS 'AVG Steps/Hour'
FROM
	hourly_activity
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	'Hour of Day';

/*
Distribution of AVG calories burned per hour of the day
*/

SELECT
	 DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,AVG(Calories) AS 'AVG Cals/Hour'
FROM
	hourly_activity
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	'Hour of Day';

/*
Steps to calorie comparison

As could be expected, there appears to be a correlation between average daily steps and average calories burned.
The higher the average steps taken corresponds with higher average calories burned.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,ROUND(AVG(CASE WHEN TotalSteps > 0 THEN Calories ELSE NULL END), 2) AS 'AVG Calories/Day'
	,ROUND(AVG(CASE WHEN Calories > 0 THEN TotalSteps ELSE NULL END), 2) AS 'AVG Total Steps/Day'
	
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate);

/*
Comparison of total minutes asleep and total time in bed using the sleepDay table
*/

SELECT
	AVG(TotalMinutesAsleep) AS 'AVG Mins Asleep'
	,ROUND((CAST((AVG(TotalMinutesAsleep)) AS FLOAT)/60), 2) AS 'AVG Hours Asleep'
	,AVG(TotalTimeInBed) AS 'AVG Mins in Bed'
	,ROUND((CAST((AVG(TotalTimeInBed)) AS FLOAT)/60), 2) AS 'AVG Hours in Bed'
	,ROUND((((CAST(AVG(TotalMinutesAsleep) AS FLOAT) / CAST(AVG(TotalTimeInBed) AS FLOAT)) * 100)), 0) AS 'Sleep Time % in Bed'
FROM
	daily_sleep;

/*
Set up bins for different levels of step counts based on CDC recommendations

https://www.cdc.gov/media/releases/2020/p0324-daily-step-count.html

https://www.healthline.com/health/how-many-steps-a-day#How-many-steps-should-you-take-a-day?
Inactive: less than 5,000 steps per day
Average (somewhat active): ranges from 7,500 to 9,999 steps per day
Very active: more than 12,500 steps per day
*/

SELECT
	 Id
	,ActivityDate
	,TotalSteps
	,CASE 
		WHEN TotalSteps <= 4999 THEN 'Less Than 5000'
		WHEN TotalSteps BETWEEN 5000 AND 7499 THEN '5000-7499'
		WHEN TotalSteps BETWEEN 7500 AND 9999 THEN '7500-9999'
		WHEN TotalSteps BETWEEN 10000 AND 12500 THEN '10000-12500'
		ELSE '12500 +'
	END AS activity_level
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0;

/*
Taking a count of the different levels of step activity according to the CDC and Health.gov

*NOTE*
This is counting days and not Id's.  
*/

SELECT
	COUNT(CASE WHEN TotalSteps <= 4999 THEN TotalSteps ELSE NULL END) AS 'Count Inactive'
	,COUNT(CASE WHEN TotalSteps BETWEEN 5000 AND 7499 THEN TotalSteps ELSE NULL END) AS 'Count Slightly Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 7500 AND 9999 THEN TotalSteps ELSE NULL END) AS 'Count Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 10000 AND 12500 THEN TotalSteps ELSE NULL END) AS 'Count Very Active'
	,COUNT(CASE WHEN TotalSteps > 12500 THEN TotalSteps ELSE NULL END) AS 'Count Highly Active'
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0;

/*
AVG daily total dailyActivity by day of the week.
*/

SELECT
	DATEPART(WEEKDAY, ActivityDate) AS 'day of week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,AVG(TotalSteps) AS 'AVG Tot Steps/Day'
	,ROUND(AVG(TotalDistance), 1) AS 'AVG Tot Dist km/Day'
	,ROUND(AVG(TrackerDistance), 1) AS 'AVG Tracked Dist km/Day'
	,ROUND(AVG(VeryActiveDistance), 1) AS 'AVG Very Active Dist km/Day'
	,ROUND(AVG(ModeratelyActiveDistance), 1) AS 'AVG Mod Active Dist km/Day'
	,ROUND(AVG(LightActiveDistance), 1) AS 'AVG Lt Active Dist km/Day'
	,ROUND(AVG(SedentaryActiveDistance), 3) AS 'AVG Sed Active Dist km/Day'
	,AVG(VeryActiveMinutes) AS 'AVG Very Active Mins/Day'
	,AVG(FairlyActiveMinutes) AS 'AVG Mod Active Mins/Day'
	,AVG(LightlyActiveMinutes) AS 'AVG Lt Active Mins/Day'
	,AVG(SedentaryMinutes) AS 'AVG Sed Active Mins/Day'
	,AVG(Calories) AS 'AVG Cals/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	'day of week';

/*
AVG daily steps grouped by user activity type
*/


/*
Set up bins for different levels of step counts based on CDC recommendations

https://www.cdc.gov/media/releases/2020/p0324-daily-step-count.html

https://www.healthline.com/health/how-many-steps-a-day#How-many-steps-should-you-take-a-day?
Inactive: less than 5,000 steps per day
Average (somewhat active): ranges from 7,500 to 9,999 steps per day
Very active: more than 12,500 steps per day
*/

SELECT
	 Id
	,ActivityDate
	,TotalSteps
	,CASE 
		WHEN TotalSteps <= 4999 THEN 'Less Than 5000'
		WHEN TotalSteps BETWEEN 5000 AND 7499 THEN '5000-7499'
		WHEN TotalSteps BETWEEN 7500 AND 9999 THEN '7500-9999'
		WHEN TotalSteps BETWEEN 10000 AND 12500 THEN '10000-12500'
		ELSE '12500 +'
	END AS activity_level
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0;




/*
Taking a count of the different levels of step activity according to the CDC and Health.gov

*NOTE*
This is counting days and not Id's.  
*/

SELECT
	COUNT(CASE WHEN TotalSteps <= 4999 THEN TotalSteps ELSE NULL END) AS 'Count Inactive'
	,COUNT(CASE WHEN TotalSteps BETWEEN 5000 AND 7499 THEN TotalSteps ELSE NULL END) AS 'Count Slightly Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 7500 AND 9999 THEN TotalSteps ELSE NULL END) AS 'Count Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 10000 AND 12500 THEN TotalSteps ELSE NULL END) AS 'Count Very Active'
	,COUNT(CASE WHEN TotalSteps > 12500 THEN TotalSteps ELSE NULL END) AS 'Count Highly Active'
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0;

/*
AVG daily active minutes grouped by user activity type for CDC recommended daily activity time
*/

SELECT
	Id
	,COUNT(CASE WHEN VeryActiveMinutes >= 20 THEN Id ELSE NULL END) AS 'Count Very Active'
	,COUNT(CASE WHEN FairlyActiveMinutes >= 30 THEN Id ELSE NULL END) AS 'Count Fairly Active'
	--,COUNT(CASE WHEN TotalSteps BETWEEN 7500 AND 9999 THEN TotalSteps ELSE NULL END) AS 'Count Active'
	--,COUNT(CASE WHEN TotalSteps BETWEEN 10000 AND 12500 THEN TotalSteps ELSE NULL END) AS 'Count Very Active'
	--,COUNT(CASE WHEN TotalSteps > 12500 THEN TotalSteps ELSE NULL END) AS 'Count Highly Active'
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0
GROUP BY
	Id
ORDER BY
	'Count Fairly Active' DESC;

/*
Truncated AVG dailyActivity table without distances
*/

SELECT
	DATEPART(WEEKDAY, ActivityDate) AS 'day of week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Name Day of Week'
	,AVG(TotalSteps) AS 'AVG Tot Steps/Day'
	,AVG(VeryActiveMinutes) AS 'AVG Very Active Mins/Day'
	,AVG(FairlyActiveMinutes) AS 'AVG Mod Active Mins/Day'
	,AVG(LightlyActiveMinutes) AS 'AVG Lt Active Mins/Day'
	,AVG(SedentaryMinutes) AS 'AVG Sed Active Mins/Day'
	,AVG(Calories) AS 'AVG Cals/Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	'day of week';

/*
Count of user's activity minutes
*/

SELECT TOP 100 
	Id
	,ActivityDate
	,TotalSteps
	,VeryActiveMinutes
	,FairlyActiveMinutes
	,LightlyActiveMinutes
	,SedentaryMinutes
FROM daily_activity;

SELECT
	COUNT(CASE WHEN TotalSteps <= 4999 THEN TotalSteps ELSE NULL END) AS 'Count Inactive'
	,COUNT(CASE WHEN TotalSteps BETWEEN 5000 AND 7499 THEN TotalSteps ELSE NULL END) AS 'Count Slightly Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 7500 AND 9999 THEN TotalSteps ELSE NULL END) AS 'Count Active'
	,COUNT(CASE WHEN TotalSteps BETWEEN 10000 AND 12500 THEN TotalSteps ELSE NULL END) AS 'Count Very Active'
	,COUNT(CASE WHEN TotalSteps > 12500 THEN TotalSteps ELSE NULL END) AS 'Count Highly Active'
FROM
	daily_activity
WHERE
	TotalSteps IS NOT NULL
	OR TotalSteps != 0;

/*
AVG dailyActivity for steps, time and calories grouped by Id
*/

SELECT
	Id
	,AVG(TotalSteps) AS 'AVG Tot Steps/Day'
	,AVG(VeryActiveMinutes) AS 'AVG Very Active Mins/Day'
	,AVG(FairlyActiveMinutes) AS 'AVG Mod Active Mins/Day'
	,AVG(LightlyActiveMinutes) AS 'AVG Lt Active Mins/Day'
	,AVG(SedentaryMinutes) AS 'AVG Sed Active Mins/Day'
	,AVG(Calories) AS 'AVG Cals/Day'
FROM
	daily_activity
GROUP BY
	Id
ORDER BY
	'AVG Tot Steps/Day' DESC;