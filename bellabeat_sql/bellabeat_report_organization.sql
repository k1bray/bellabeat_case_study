USE [CaseStudy2-Bellabeat];

SELECT * FROM daily_calories;

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

-- Complete averages of the daily_activity table grouped by user Id
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
**Daily Active Users (DAU)**: Determine the number of unique users who interact with their devices on a daily basis. 
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

/*
**Feature Usage**: Analyze which features of the wearable devices are most frequently used by users. This can include step 
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
of clothing, which some users may find more comfortable than wearing a smartwatch while they sleep.
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
**Session Duration**: Measure the average duration of each session users spend interacting with their devices. This metric 
provides insights into user engagement levels.

Although most of the user group wore their devices each day of the study period, many of them wore their trackers
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

SELECT 
    id
    ,COUNT(DISTINCT ActivityMinute) AS minutes
FROM minute_activity
GROUP BY id
ORDER BY minutes DESC
;

/*
**Device Interoperability**: Investigate whether users are integrating their wearable devices with other smart devices or 
platforms (e.g., fitness apps, smart scales, smartwatches).

The majority of the data is collected passively by the Fitbit wearable tracking device.
The weight_log table is the only one that would require use of a seperate device whether it is linked and collects the data 
automatically, or the data is then entered manually by the user.  
*/

SELECT  
    COUNT(logId) AS total_records                                                                  -- 67 total records
    ,COUNT(CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_manual_report       -- 41 True records
    ,COUNT(CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_manual_report     -- 26 false records
FROM weight_log;

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
No insight can confidently be gained from this data other than the majority of the users that did utilize weight logging
manually reported their records.  Also, that the vast majority of the sample user pool did not utilize the weight logging feature at all.
*/

SELECT
    Id
    ,COUNT(DISTINCT LogId) AS sessions
    ,COUNT(CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_report
    ,COUNT(CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_report
FROM weight_log
GROUP BY Id
ORDER BY sessions DESC
;

/*
Calorie burn to intensity comparison
*/

SELECT * FROM daily_activity;

SELECT * FROM daily_intensity;

SELECT 
    di.*
    ,da.Calories
FROM daily_intensity di
    LEFT JOIN daily_activity da 
        ON di.Id = da.Id
        AND di.ActivityDay = da.ActivityDate
ORDER BY SedentaryMinutes
;







/*
Average calorie burn by day of the week
*/

SELECT 
	DATEPART(WEEKDAY, ActivityDate) AS 'Day # of Week'
	,DATENAME(WEEKDAY, ActivityDate) AS 'Day of Week'
	,COUNT(*) AS 'Daily Records'
	,CAST((ROUND(AVG(TotalSteps), 0)) AS FLOAT) AS 'AVG Steps Per Day'
	,CAST((ROUND(AVG(Calories), 0)) AS FLOAT) AS 'AVG Calories Per Day'
	,CAST((ROUND(AVG(TotalDistance), 1)) AS FLOAT) AS 'AVG Total Distance Per Day'
	,CAST((ROUND(AVG(VeryActiveMinutes), 0)) AS FLOAT) AS 'AVG Very Active Minutes Per Day'
	,CAST((ROUND(AVG(FairlyActiveMinutes), 0)) AS FLOAT) AS 'AVG Fairly Active Minutes Per Day'
	,CAST((ROUND(AVG(LightlyActiveMinutes), 0)) AS FLOAT) AS 'AVG Lightly Active Minutes Per Day'
	,CAST((ROUND(AVG(SedentaryMinutes), 0)) AS FLOAT) AS 'AVG Sedentary Distance Per Day'
	,CAST((ROUND(AVG(VeryActiveDistance), 0)) AS FLOAT) AS 'AVG Very Active Distance Per Day'
	,CAST((ROUND(AVG(ModeratelyActiveDistance), 0)) AS FLOAT) AS 'AVG Fairly Active Distance Per Day'
	,CAST((ROUND(AVG(LightActiveDistance), 0)) AS FLOAT) AS 'AVG Lightly Active Distance Per Day'
	,CAST((ROUND(AVG(SedentaryActiveDistance), 0)) AS FLOAT) AS 'AVG Sedentary Distance Per Day'
FROM
	daily_activity
GROUP BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate)
ORDER BY
	DATEPART(WEEKDAY, ActivityDate)
	,DATENAME(WEEKDAY, ActivityDate);

/*
Day of the week users are most active
*/

/*
Hour of the day that users are most active
*/

SELECT
	DATEPART(HOUR, ActivityHour) AS 'Hour of Day'
	,CAST((ROUND(AVG(StepTotal), 0)) AS FLOAT) AS 'AVG Steps Per Hour'
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
	,CAST((ROUND((AVG(totalMinutesAsleep) / 60), 1)) AS FLOAT) AS 'AVG Hours Asleep'
	,CAST((ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 1)) AS FLOAT) AS 'AVG Mins Awake In Bed'
 	,CAST((ROUND(AVG(daily_activity.TotalSteps),0)) AS FLOAT) AS 'AVG Daily Steps'
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
	,CAST((ROUND((AVG(totalMinutesAsleep) / 60), 2)) AS FLOAT) AS 'AVG Hours Asleep'
	,CAST((ROUND(((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep))/60), 2)) AS FLOAT) AS 'AVG Hrs Awake In Bed'
	,CAST((ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 2)) AS FLOAT) AS 'AVG Mins Awake In Bed'
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
	CAST((ROUND((AVG(totalMinutesAsleep) / 60), 2)) AS FLOAT) AS 'AVG Hours Asleep' -- 6.99 Hours
	,CAST((ROUND((AVG(TotalTimeInBed) - AVG(totalMinutesAsleep)), 2)) AS FLOAT) AS 'AVG Mins Awake In Bed' -- 39.31 Mins
FROM
	daily_sleep
;

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
Finding the AVG weight per user in kg and converted to pounds
*/

SELECT * FROM weight_log;

SELECT 
    MIN(Date)          -- '2016-04-12'
    ,MAX(Date)           -- '2016-05-12'
FROM weight_log;

/*
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
	    ,CAST((ROUND(AVG(WeightKg), 1)) AS FLOAT) AS avg_kg_per_user
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
