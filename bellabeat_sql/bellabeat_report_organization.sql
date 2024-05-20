USE [CaseStudy2-Bellabeat];

-- Finding the average calories burned by day of the week
SELECT
    wkday_num,
    weekday,
    CAST(AVG(Calories) AS DECIMAL (10,0)) AS avg_calories
FROM
(
    SELECT 
        Id
        ,ActivityDay
        ,DATEPART(WEEKDAY, ActivityDay) AS wkday_num
        ,DATENAME(WEEKDAY, ActivityDay) AS weekday
        ,Calories
    FROM daily_calories
) AS cal_w_weekday
GROUP BY wkday_num
    ,weekday
ORDER BY wkday_num
;

-- Finding the average calories burned by day of the week
-- Cleaner way of achieving the same results as the previous query
SELECT
    DATEPART(WEEKDAY, ActivityDay) AS wkday_num
    ,DATENAME(WEEKDAY, ActivityDay) AS weekday
    ,CAST(AVG(Calories) AS DECIMAL (10,0)) AS avg_calories
FROM daily_calories
GROUP BY DATEPART(WEEKDAY, ActivityDay)
    ,DATENAME(WEEKDAY, ActivityDay)
ORDER BY 
    wkday_num
;

-- Complete averages of the daily_activity table over the length of the study grouped by user Id
SELECT 
    id
    ,CAST(AVG(TotalSteps) AS DECIMAL(10,0)) AS avg_steps
    ,CAST(AVG(TotalDistance) AS DECIMAL(10,1)) AS avg_total_distance
    ,CAST(AVG(TrackerDistance) AS DECIMAL(10,1)) AS avg_tracker_distance
    ,CAST(AVG(LoggedActivitiesDistance) AS DECIMAL(10,1)) AS avg_log_act_dist
    ,CAST(AVG(VeryActiveDistance) AS DECIMAL(10,1)) AS avg_very_act_dist
    ,CAST(AVG(ModeratelyActiveDistance) AS DECIMAL(10,1)) AS avg_mod_act_dist
    ,CAST(AVG(LightActiveDistance) AS DECIMAL(10,1)) AS avg_lt_act_dist
    ,CAST(AVG(SedentaryActiveDistance) AS DECIMAL(10,1)) AS avg_sed_act_dist
    ,CAST(AVG(VeryActiveMinutes) AS DECIMAL(10,0)) AS avg_very_act_min
    ,CAST(AVG(FairlyActiveMinutes) AS DECIMAL(10,0)) AS avg_fairly_act_min
    ,CAST(AVG(LightlyActiveMinutes) AS DECIMAL(10,0)) AS avg_lt_act_min
    ,CAST(AVG(SedentaryMinutes) AS DECIMAL(10,0)) AS avg_sed_min
    ,CAST(AVG(Calories) AS DECIMAL(10,0)) AS avg_calories
FROM daily_activity
GROUP BY Id 
;

/*
Daily Active Users (DAU) - Trying to determine the number of unique users who interact with their devices on a daily basis. 
DAU reflects the frequency of device usage.

21 out of 33 distinct users were active with their devices all 31 days of the study
3 out of 33 distinct users were active with their devices 30 days of the study
2 out of 33 distinct users were active with their devices 29 days of the study
1 out of 33 distinct users were active with their devices 28 days of the study
2 out of 33 distinct users were active with their devices 26 days of the study
1 out of 33 distinct users were active with their devices 20 days of the study
1 out of 33 distinct users were active with their devices 19 days of the study
1 out of 33 distinct users were active with their devices 18 days of the study
1 out of 33 distinct users were active with their devices 4 days of the study

***Takeaways:
The vast majority of users were active for most of the study.
There were no users that were inactive for the entire length of the study.
*/

SELECT COUNT(DISTINCT Id) FROM daily_activity;      -- 33 distinct users

SELECT
    Id
    ,COUNT(DISTINCT ActivityDate) AS days_active
FROM daily_activity
GROUP BY ID 
ORDER BY days_active DESC
;

SELECT * FROM daily_activity WHERE Id = 4057192912;

/*
Feature Usage - Which features of the wearable devices are most frequently used by users? This can include step 
tracking, heart rate monitoring, sleep tracking, etc.

We aren't furnished with information regarding the devices that each user has, or whether all users had access to the same suite
of functionality.
Hypothetically, and for the sake of the study, if we assume that all users had access to the same suite of feature functionality, 
what is apparent from the data is that not all features available from their fitness trackers were utilized.  Most likely, 
much of the data was collected passively and required no intervention from the user.  Features such as weight logging would 
require the user to (remember or be motivated to) mannualy enter the data and/or to purchase a separate device that was 
compatible with their fitness trackers to collect the data and report it to the app on their behalf.
The discrepancy in feature usage levels between the daily_activity and daily_sleep tables could be explained by users that 
decide not to wear their tracker while sleeping.  One advantage of the Bellabeat leaf is that it can clipped to an article 
of clothing, which some users may find more comfortable than wearing a smartwatch while they sleep.  Also, the Leaf weable 
has a significantly longer battery life than a smartwatch and doesn't require frequent intermittent recharging.
*/

SELECT  
    COUNT(DISTINCT da.Id) AS daily_activity_users      -- 33 users
    ,COUNT(DISTINCT ds.Id) AS daily_sleep_users         -- 24 users
    ,COUNT(DISTINCT wl.id) AS weight_log_users           -- 8 users
FROM daily_activity da
    FULL JOIN daily_sleep ds
        ON da.id = ds.id
    FULL JOIN weight_log wl 
        ON ds.id = wl.id
;

/*
Session Duration - What's the average duration of each session users spend interacting with their devices? This metric 
provides insights into user engagement levels.

Although most in the group wore their devices each day of the study period, many of them wore their trackers
for partial days.
*/

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
(
    SELECT
	    DISTINCT(Id)
	    ,CAST((ROUND(AVG(TotalSteps), 0)) AS FLOAT) AS avg_daily_steps
    FROM	
	    daily_activity
    GROUP BY
	    Id
) AS avg
		ON act.Id = avg.Id
GROUP BY
	act.Id
	,avg_daily_steps
--	,ActivityDate
ORDER BY
	'Full Day' DESC;

-- Total activity minutes per user during the study
SELECT 
    id
    ,COUNT(ActivityMinute) AS minutes
FROM minute_activity
GROUP BY id
ORDER BY minutes DESC
;


SELECT TOP 1000 * FROM hourly_activity;

SELECT COUNT(*) FROM hourly_activity;

SELECT
    Id,
    COUNT(ActivityHour) AS ActivityCount,
    DATEPART(MONTH, ActivityHour) AS month,
    DATEPART(DAY, ActivityHour) AS day
FROM hourly_activity
GROUP BY 
    Id,
    DATEPART(MONTH, ActivityHour),
    DATEPART(DAY, ActivityHour)
ORDER BY 
    DATEPART(MONTH, ActivityHour),
    DATEPART(DAY, ActivityHour)
;

-- Finding how many hours each user wore their device during the study period
SELECT 
    Id
    ,COUNT(*) AS total_sessions_per_user 
FROM hourly_activity
GROUP BY 
    Id
ORDER BY 
    total_sessions_per_user DESC;

/*
Device Interoperability - Are users integrating their wearable devices with other smart devices or 
platforms (e.g., fitness apps, smart scales, smartwatches)?

The majority of the data is collected passively by the Fitbit wearable tracking device.
The weight_log table is the only one that would require use of a seperate device whether it is linked and collects the data 
automatically, or the data is then entered manually by the user.  
*/

-- Comparing total number of records with frequency of automatic vs manual reporting of weight
SELECT  
    COUNT(logId) AS total_records                                                                  -- 67 total records
    ,COUNT(CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_manual_report       -- 41 True records
    ,COUNT(CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_manual_report     -- 26 false records
FROM weight_log;

-- Comparing the total number of users in the table and how many users used manual and automatic reporting of weight
SELECT  
    COUNT(DISTINCT Id) AS total_users                                                                    -- 8 total users
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'True' THEN Id ELSE NULL END) AS true_manual_report       -- 5 True records
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'False' THEN Id ELSE NULL END) AS false_manual_report     -- 3 false records
FROM weight_log;

/*
There are no users that used both manual and automatic reporting of their weight.
This means that each user was consistent in their reporting method and that no one
added or integrated their wearble device with another device such as a smart scale
during the study period.

Of the two users (out of a total of eight) with the highest number of records for weight logging, one reported their weight manually
and the other used some sort of an integrated device.
The insight with the most value that can be gained from this dataset regarding weight logging comes more from the data that isn't available.  
Even though the overall dataset is lacking in terms of userpool size and time duration, the participation rates shown here are 
very low.  A relatively safe assumption is that the majority of users didn't find the idea of weight logging to be valuable.  
Whether the sampling in this userpool is a good overall representation of people who wear fitness tracking devices si still unclear.


No insight of value can confidently be gained from this data other than the majority of the users that did utilize weight logging
manually reported their records.  Also, that the vast majority of the sample user pool did not utilize the weight logging feature at all.
*/

SELECT
    Id
    ,COUNT(DISTINCT LogId) AS sessions
    ,COUNT(CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_report
    ,COUNT(CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_report
    ,COUNT(DISTINCT Date) AS distinct_date_count
FROM weight_log
GROUP BY Id
ORDER BY sessions DESC
;

/*
What day of the week do users wear their devices most? Least?
Finding averages of the various activity levels of steps, calories, and distance per day of the week.
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
	,CAST(AVG(TotalSteps) AS DECIMAL (10,0)) AS 'AVG Steps Per Day'
	,CAST(AVG(Calories) AS DECIMAL (10,0)) AS 'AVG Calories Per Day'
	,CAST(AVG(TotalDistance) AS DECIMAL (10,1)) AS 'AVG Total Distance Per Day'
	,CAST(AVG(VeryActiveMinutes) AS DECIMAL (10,0)) AS 'AVG Very Active Minutes Per Day'
	,CAST(AVG(FairlyActiveMinutes) AS DECIMAL (10,0)) AS 'AVG Fairly Active Minutes Per Day'
	,CAST(AVG(LightlyActiveMinutes) AS DECIMAL (10,0)) AS 'AVG Lightly Active Minutes Per Day'
	,CAST(AVG(SedentaryMinutes) AS DECIMAL (10,0)) AS 'AVG Sedentary Distance Per Day'
	,CAST(AVG(VeryActiveDistance) AS DECIMAL (10,1)) AS 'AVG Very Active Distance Per Day'
	,CAST(AVG(ModeratelyActiveDistance) AS DECIMAL (10,1)) AS 'AVG Fairly Active Distance Per Day'
	,CAST(AVG(LightActiveDistance) AS DECIMAL (10,1)) AS 'AVG Lightly Active Distance Per Day'
	,CAST(AVG(SedentaryActiveDistance) AS DECIMAL (10,1)) AS 'AVG Sedentary Distance Per Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);

/*
Hour of the day that users are most active based on average steps per hour and grouped by the hour of the day
*/

SELECT
	DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,CAST(AVG(StepTotal) AS DECIMAL (10,0)) AS 'AVG Steps Per Hour'
FROM 
	hourly_steps
GROUP BY
	DATEPART(HOUR, ActivityHour)
ORDER BY
	DATEPART(HOUR, ActivityHour);

/*
Finding the AVG hours asleep and time spent awake in bed per user Id for the users
*/

SELECT
	daily_activity.Id
	,COUNT(SleepDay) AS count_of_daily_sleep_records
	,CAST((AVG(totalMinutesAsleep) / 60) AS DECIMAL (10,2)) AS 'AVG Hours Asleep'
	,CAST((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)) AS DECIMAL (10,0)) AS 'AVG Mins Awake In Bed'
 	,CAST(AVG(daily_activity.TotalSteps) AS DECIMAL (10,0)) AS 'AVG Daily Steps'
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
the AVG Hours Asleep values are all so close that I had to expand the ROUND() out to 2 decimal places for a higher
degree of accuracy.  Thursday also has the lowest value of the week for the AVG Mins Awake In Bed
*/

SELECT 
	DATEPART(WEEKDAY, SleepDay) AS 'Day # of Week'
	,DATENAME(WEEKDAY, SleepDay) AS 'Day of Week'
	,COUNT(*) AS 'Daily Sleep Records'
	,CAST((AVG(totalMinutesAsleep) / 60) AS DECIMAL (10,1)) AS 'AVG Hours Asleep'
	,CAST(((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep))/60) AS DECIMAL (10,2)) AS 'AVG Hrs Awake In Bed'
	,CAST((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)) AS DECIMAL (10,0)) AS 'AVG Mins Awake In Bed'
FROM
	daily_sleep
GROUP BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay)
ORDER BY
	DATEPART(WEEKDAY, SleepDay)
	,DATENAME(WEEKDAY, SleepDay);

SELECT * FROM daily_sleep;

/*
What is the overall AVG Hours Asleep for the user group (6.99 hours)?
What is the overall AVG Mins Awake for the user group (39.31 mins)?
*/

SELECT 
	CAST((AVG(totalMinutesAsleep) / 60) AS DECIMAL (10,2)) AS 'AVG Hours Asleep' -- 6.99 Hours
	,CAST((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)) AS DECIMAL (10,0)) AS 'AVG Mins Awake In Bed' -- 39.31 Mins
FROM
	daily_sleep
;

/*
What is the average bedtime for participants?
What is the average wake up time for participants?

**NOTE**
There are some instances of participants having more than one sleep session in a day
Also, there is no indication that all participants are located within the same timezone.
This could have a dramatic affect on trying to compare bedtimes and waketimes, which would
make finding an average potentially problematic.

Step 1 - Calculate both the bedtime and waketime for each LogId.
Step 2 - Extract the hour and minute components from both bedtime and waketime.
Step 3 - Calculate the average bedtime and waketime overall.
Step 4 - Calculate the average bedtime and waketime for each day of the week.

The results of this query show what *could* be considered as plausible aveage waketimes.
HOWEVER, the results for average bedtimes seems WAY off.
*/


WITH SleepTimes AS (
--Calculates both the minimum date (i.e., bedtime) and maximum date (i.e., waketime) for each LogId
    SELECT 
        LogId,
        MIN(date) AS bedtime,
        MAX(date) AS waketime
    FROM 
        minute_sleep
    GROUP BY 
        LogId
),
SleepDetails AS (
-- Extracts the hour and minute components from both bedtime and waketime to calculate the total 
-- minutes past midnight for each. It also extracts the day of the week
    SELECT
        bedtime,
        waketime,
        DATEPART(HOUR, bedtime) * 60 + DATEPART(MINUTE, bedtime) AS bedtime_minutes,
        DATEPART(HOUR, waketime) * 60 + DATEPART(MINUTE, waketime) AS waketime_minutes,
        DATEPART(WEEKDAY, bedtime) AS weekday
    FROM 
        SleepTimes
),
AverageSleepTimesOverall AS (
-- Calculate average bedtime and waketime overall
    SELECT 
        'Overall' AS Category,
        CONVERT(TIME, DATEADD(MINUTE, AVG(bedtime_minutes), 0)) AS AverageBedtime,
        CONVERT(TIME, DATEADD(MINUTE, AVG(waketime_minutes), 0)) AS AverageWaketime,
        NULL AS weekday
    FROM 
        SleepDetails
),
AverageSleepTimesByDay AS (
    -- Calculate average bedtime and waketime for each day of the week
    SELECT 
        CASE 
            WHEN weekday = 1 THEN 'Sunday'
            WHEN weekday = 2 THEN 'Monday'
            WHEN weekday = 3 THEN 'Tuesday'
            WHEN weekday = 4 THEN 'Wednesday'
            WHEN weekday = 5 THEN 'Thursday'
            WHEN weekday = 6 THEN 'Friday'
            WHEN weekday = 7 THEN 'Saturday'
        END AS Category,
        CONVERT(TIME, DATEADD(MINUTE, AVG(bedtime_minutes), 0)) AS AverageBedtime,
        CONVERT(TIME, DATEADD(MINUTE, AVG(waketime_minutes), 0)) AS AverageWaketime,
        weekday
    FROM 
        SleepDetails
    GROUP BY 
        weekday
)
-- Combines the overall averages with the daily averages, adding a SortOrder column to ensure correct ordering
SELECT 
    Category,
    AverageBedtime,
    AverageWaketime
FROM (
    SELECT 
        Category,
        AverageBedtime,
        AverageWaketime,
        0 AS SortOrder
    FROM 
        AverageSleepTimesOverall

    UNION ALL

    SELECT 
        Category,
        AverageBedtime,
        AverageWaketime,
        CASE 
            WHEN Category = 'Sunday' THEN 1
            WHEN Category = 'Monday' THEN 2
            WHEN Category = 'Tuesday' THEN 3
            WHEN Category = 'Wednesday' THEN 4
            WHEN Category = 'Thursday' THEN 5
            WHEN Category = 'Friday' THEN 6
            WHEN Category = 'Saturday' THEN 7
        END AS SortOrder
    FROM 
        AverageSleepTimesByDay
) AS CombinedResults
ORDER BY 
    SortOrder;


/*
Finding the number of records for each day of the week of the weight_log table.
Given how sparse this table is, These results are mainly focused on the activity of a very
small group of people.
Observation:
Users were least likely to log their weight on Friday and Saturday.
*/

SELECT 
	DATEPART(WEEKDAY, Date) AS 'Day # of Week'
	,DATENAME(WEEKDAY, Date) AS 'Day of Week'
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
Finding the AVG weight per user in kg and converted to pounds

The following query coincidentally correctly answers which users gained/lost/stagnated in their weight over the study period.
A later query confirms the results more accurately.
*/
SELECT
    Id,
    avg_kg_per_user AS 'AVG Weight(kg) per User',
    avg_lbs_per_user AS 'AVG Weight(lbs) per User',
    avg_bmi_per_user AS 'AVG BMI per User',
    max_wt,
    min_wt,
    CASE
        WHEN max_wt > min_wt THEN 'up'
        WHEN min_wt = max_wt THEN 'no_change'
        ELSE 'down'
    END AS wt_change
FROM
(
    SELECT
	    Id
	    ,CAST((AVG(WeightKg)) AS DECIMAL (10,1)) AS avg_kg_per_user
	    ,CAST((ROUND(AVG(WeightPounds), 1)) AS FLOAT) AS avg_lbs_per_user
     ,CAST((ROUND(AVG(BMI), 1)) AS FLOAT) AS avg_bmi_per_user
	    ,MAX(WeightKg) AS max_wt
	    ,MIN(WeightKg) AS min_wt
    FROM
	    weight_log
    GROUP BY
	    Id
) AS weights
GROUP BY 
    Id,
    avg_kg_per_user,
    avg_lbs_per_user,
    avg_bmi_per_user,
    max_wt,
    min_wt
ORDER BY wt_change
;

/*
Did anyone lose/gain weight during the study period?

Users either gained or stayed the same weight during the study period.  However, it should be reiterated that the study 
period was only about a month long.
Also of note, a previous query reached similar results but did so rather by accident. This query is more accurate because 
it correlates the actual weights with the beginning and end dates.  This eliminates the possibility that a users weight that
may have fluctuated during the study was accounted for.
*/
-- Identifying users weight change over the study period
SELECT
    Id,
    CASE 
        WHEN begin_wt > end_wt THEN 'down'
        WHEN begin_wt = end_wt THEN 'no_change'
        ELSE 'up'
    END AS wt_change,
    begin_wt,
    end_wt,
    records_count
FROM
(
    SELECT
        start_wt.Id AS Id,
        MIN(start_wt.Date) AS begin_date,
        MIN(start_wt.WeightKg) AS begin_wt,
        MAX(end_wt.Date) AS end_date,
        MAX(end_wt.WeightKg) AS end_wt,
        COUNT(DISTINCT start_wt.Date) AS records_count
    FROM
        weight_log start_wt
    LEFT JOIN 
        weight_log end_wt 
            ON start_wt.Id = end_wt.Id
    GROUP BY 
        start_wt.Id
) AS max_min_dates
ORDER BY 
    wt_change;

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
	Id
ORDER BY 1 DESC;

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