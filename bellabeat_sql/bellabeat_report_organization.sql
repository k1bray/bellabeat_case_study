USE [CaseStudy2-Bellabeat];

SELECT * FROM daily_calories;

SELECT
    wkday_num
    ,weekday
    ,ROUND(AVG(Calories), 0) AS avg_calories
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


SELECT
    DATEPART(WEEKDAY, ActivityDay) AS wkday_num
    ,DATENAME(WEEKDAY, ActivityDay) AS weekday
    ,ROUND(AVG(Calories), 0)
FROM daily_calories
GROUP BY DATEPART(WEEKDAY, ActivityDay)
    ,DATENAME(WEEKDAY, ActivityDay)
ORDER BY 
    wkday_num
;

-- Complete averages of the daily_activity table grouped by user Id
SELECT 
    id,
    CAST(AVG(TotalSteps) AS DECIMAL(10,0)) AS avg_steps,
    CAST(AVG(TotalDistance) AS DECIMAL(10,1)) AS avg_total_distance,
    CAST(AVG(TrackerDistance) AS DECIMAL(10,1)) AS avg_tracker_distance,
    CAST(AVG(LoggedActivitiesDistance) AS DECIMAL(10,1)) AS avg_log_act_dist,
    CAST(AVG(VeryActiveDistance) AS DECIMAL(10,1)) AS avg_very_act_dist,
    CAST(AVG(ModeratelyActiveDistance) AS DECIMAL(10,1)) AS avg_mod_act_dist,
    CAST(AVG(LightActiveDistance) AS DECIMAL(10,1)) AS avg_lt_act_dist,
    CAST(AVG(SedentaryActiveDistance) AS DECIMAL(10,1)) AS avg_sed_act_dist,
    CAST(AVG(VeryActiveMinutes) AS DECIMAL(10,0)) AS avg_very_act_min,
    CAST(AVG(FairlyActiveMinutes) AS DECIMAL(10,0)) AS avg_fairly_act_min,
    CAST(AVG(LightlyActiveMinutes) AS DECIMAL(10,0)) AS avg_lt_act_min,
    CAST(AVG(SedentaryMinutes) AS DECIMAL(10,0)) AS avg_sed_min,
    CAST(AVG(Calories) AS DECIMAL(10,0)) AS avg_calories
FROM daily_activity
GROUP BY Id 
;

/*
**Device Adoption Rate**: Track the number of users adopting wearable fitness tracking devices over time. This metric can 
provide insights into the overall growth of the wearable market.

Duration of study is too short
*/

/*
**Retention Rate**: Measure the percentage of users who continue to use their devices over a specific period. This metric 
indicates user satisfaction and engagement levels.

Duration of study is too short
*/

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

SELECT * FROM daily_activity;

SELECT COUNT(DISTINCT Id) FROM daily_activity;      -- 33 distinct users

SELECT
    Id,
    COUNT(DISTINCT ActivityDate) AS days_active
FROM daily_activity
GROUP BY ID 
ORDER BY days_active DESC
;

/*
**Feature Usage**: Analyze which features of the wearable devices are most frequently used by users. This can include step 
tracking, heart rate monitoring, sleep tracking, etc.

We aren't furnished with information regarding the devices that each user has, or whether all users have access to the same suite
of functionality.
What is apparent from the data is that not all features available from their fitness trackers were utilized.  Most likely,
much of the data was collected passively and required no intervention from the user.  Features such as weight logging would 
require the user to (remember or be motivated to) mannualy enter the data and/or to purchase a separate device that was 
compatible with their fitness trackers to collect the data.
The discrepancy in feature usage levels between the daily_activity and daily_sleep tables could be explained by users that 
decide not to wear their tracker while sleeping.  One advantage of the Bellabeat leaf is that it can clipped to an article 
of clothing, which some users may find more comfortable than wearing a smartwatch while they sleep.
*/

SELECT  
    COUNT(DISTINCT da.Id) AS daily_activity_users,      -- 33 users
    COUNT(DISTINCT ds.Id) AS daily_sleep_users,         -- 24 users
    COUNT(DISTINCT wl.id) AS weight_log_users           -- 8 users
FROM daily_activity da
    FULL JOIN daily_sleep ds
        ON da.id = ds.id
    FULL JOIN weight_log wl 
        ON ds.id = wl.id
;

SELECT  COUNT(DISTINCT id)
FROM seconds_heartrate;

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
     id,
     COUNT(DISTINCT ActivityMinute) AS minutes
FROM minute_activity
GROUP BY id
ORDER BY minutes DESC
;

SELECT COUNT(DISTINCT id) FROM minute_activity;         -- 22 users

/*
**Geographical Distribution**: Explore the geographical distribution of wearable device users. This can help identify 
regional trends and preferences.

Geographic data was not included in the collection process
*/

/*
**Device Interoperability**: Investigate whether users are integrating their wearable devices with other smart devices or 
platforms (e.g., fitness apps, smart scales, smartwatches).
*/

SELECT * FROM weight_log;

SELECT  
    COUNT(DISTINCT logId) AS total_records                                                                  -- 56 total records
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_manual_report       -- 30 True records
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_manual_report     -- 26 false records
FROM weight_log;

SELECT  
    COUNT(DISTINCT logId) AS total_records                                                                  -- 56 total records
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'True' THEN Id ELSE NULL END) AS true_manual_report       -- 30 True records
    ,COUNT(DISTINCT CASE WHEN IsManualReport = 'False' THEN Id ELSE NULL END) AS false_manual_report     -- 26 false records
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
    Id,
    COUNT(DISTINCT LogId) AS sessions,
    COUNT(DISTINCT CASE WHEN IsManualReport = 'True' THEN LogId ELSE NULL END) AS true_report,
    COUNT(DISTINCT CASE WHEN IsManualReport = 'False' THEN LogId ELSE NULL END) AS false_report
FROM weight_log
GROUP BY Id
ORDER BY sessions DESC
;

SELECT *
FROM weight_log
WHERE Id = 6962181067
ORDER BY IsManualReport ASC;

/*
**Upgrade Frequency**: Track how often users upgrade to newer models or versions of wearable devices. This indicates user 
loyalty and interest in technological advancements.

Data not collected during study period.
*/

/*
**User Demographics**: Analyze the demographic characteristics of wearable device users, such as age, gender, occupation, etc. 
This can help identify target markets and tailor marketing strategies accordingly.

Data not collected during study period.  As Bellabeat is a company that designs and markets their products specifically to women,
It would have been useful to know the age and gender of the users.  That way it could be determined if any gender-specific trends
exist in the dataset.
*/

/*
**Social Sharing and Engagement**: Look into whether users are sharing their fitness data or achievements on social media 
platforms and the level of engagement generated from such sharing.

Data not collected during study period.
*/

/*
**Churn Rate**: Measure the rate at which users stop using their devices. High churn rates may indicate dissatisfaction or 
issues with the device.

All users were active in some form every day of the study.  There is not enough data from the study to determine satisfaction rates.
*/

/*
**App Usage Metrics**: If there's a companion app associated with the wearable device, analyze metrics such as app downloads, 
active users, and in-app engagement.

Data not collected during study period.
*/

/*
**Battery Life**: Investigate how battery life affects user engagement and satisfaction. Longer battery life may correlate with 
higher usage rates.

Data not collected during study period.
*/

/*
**Customer Reviews and Feedback**: Analyze customer reviews and feedback to identify common issues, feature requests, and 
overall sentiment towards wearable devices.

Data not collected during study period.
*/
