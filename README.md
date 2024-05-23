![bellabeat-logo](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/bellabeat-logo.png)

## Introduction and Company Profile
Hello, my name is Kevin, and for the purposes of this case study I’m a Junior Data Analyst in the marketing department for Bellabeat.  Our company is a high-tech manufacturer of health-focused products for women that was founded in 2013 by Urska Srsen and Sando Mur.

## Table of Contents
[Summary of the Business Task and Stakeholders](https://github.com/k1bray/bellabeat_case_study?tab=readme-ov-file#summary-of-the-business-task-and-stakeholders)

[Examining the Data Profile](https://github.com/k1bray/bellabeat_case_study?tab=readme-ov-file#examining-the-data-profile)

[Cleaning and Manipulation of Data](https://github.com/k1bray/bellabeat_case_study?tab=readme-ov-file#cleaning-and-manipulation-of-data)

[Analysis and Discussion](https://github.com/k1bray/bellabeat_case_study?tab=readme-ov-file#analysis-and-discussion)

[Recommendations and Possible Further Actions Based on Analysis](https://github.com/k1bray/bellabeat_case_study?tab=readme-ov-file#recommendations-and-possible-further-actions-based-on-analysis)

## Summary of the Business Task and Stakeholders
### The Business Task
The aim of this case study is to analyze smart device usage data from a competitor to gain insight into how consumers use non-Bellabeat smart devices and how those insights could be applied to improve marketing strategies for comparable Bellabeat products.

Specifically, the questions being asked are:
1.	What are some trends in smart device usage?
2.	How could these trends be applied to Bellabeat customers?
3.	How could these trends help influence the Bellabeat marketing strategy?

### Key Stakeholders
  - Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer

  - Sando Mur: Mathematician and Bellabeat’s cofounder; key member of the Bellabeat executive team 

  - Bellabeat marketing analytics team


## Examining the Data Profile
### Data availability and License
The dataset made available for this study can be accessed [here](https://www.kaggle.com/datasets/arashnic/fitbit/download?datasetVersionNumber=1) under this [license](https://creativecommons.org/publicdomain/zero/1.0/) and appears to be comprised of mainly quantitative, structured data in 18 tables with varying degrees of granularity regarding the period length that is under examination.  The dataset is from Fitbit, who, according to this article from [CNET.com](https://creativecommons.org/publicdomain/zero/1.0/), had a 22% market share on unit shipments during the timeframe of the study in 2016, outselling Apple and Garmin devices combined.

### Overview Description of The Dataset
The available tables have data covering many aspects of health and activity.  Areas of focus consist of activity levels and duration including step counting, distance tracking, and calorie usage.  Also, there is data regarding heartrates, sleep tracking, and weight logging.  Further calculations were made in the dataset using metrics to determine levels of activity intensity.

The table that is the most readily usable in its raw form for the purposes of this project is the daily_activity table.  There are narrowly focused subsequent tables that contain identical data that were possibly coalesced to form the component columns of the daily_activity table.  All the data that is contained in the daily_calories, daily_intensities, and daily_steps tables is repeated from/to the daily_activites table.  The data includes metrics regarding ID, date, step counts, distances, activity intensity, and calories burned.  There are other tables measuring similar fitness and activity metrics based on varying time scales ranging from hours down to seconds.

### Limitations of The Dataset
One of the features of the Bellabeat Leaf (an activity tracking device) and its accompanying app is that it has guided breathing exercises to control stress levels.  After examining the provided dataset there is nothing in the data that can be used to analyze user stress.

At the time of this study’s publication, the LEAF doesn’t currently appear to make weight tracking a priority for the user experience.  With that in mind, as well as viewing how sparse the data in the table is, analyzation of the weight_log table for the sake of its fitness activity is of limited value, unless Bellabeat plans on adding a weight-focused feature at a later date.  However, given the sparsity of the provided weight_log table it would be wise to collect or acquire a more comprehensive dataset that provides a higher level of data value on that topic.

Another point to note is that in the weight_log table there is a column for 'Fat' which is mostly comprised of NULL values.  This appears to be an underutilized feature of the Fitbit tracker.  It’s unclear how this metric would be measured, and it is possible that it might require additional hardware beyond the Fitbit device to collect.  If this were to be true it could provide some insight into why the data in that column is so sparse, as well as to bolster a potential suspicion of why the weight_log table had such a low overall participation rate.  This would encourage the idea that perhaps a better perspective on the lack of utilization of the weight_log data by the participants is just that.  This is a blunt way to put it, but why do the participants by-and-large seem to find little-to-no value in that feature?  Why might it be so underutilized?  Unfortunately, there is insufficient data from which to gain insight on this matter utilizing this dataset alone.  However, one could surmise after viewing the uniformity of the automatically collected data in the daily_activity table that the requirement of the participants to take an additional step by either weighing themselves and/or manually entering the data creates a barrier to the task that is too great to overcome without the motivation to make it a priority.

The study period in the dataset is only one month.  A longer timeframe would be beneficial to see if participants’ trends and activity consistency hold up over time or show any signs of cyclicality that could be explained by changes such as seasonality or maintaining activity interest levels.  Additionally, the overall data pool is not very large with a sample size of roughly 30 participants for most tables.

Another issue is that we don’t have any information on the profiles of the individual participants being tracked.  Since Fitbit products and marketing strategies appear to be gender-neutral, it would be safest to assume that the Fitbit user pool is comprised of mixed genders which is potentially antithetical to the Bellabeat mission of providing health tracking devices specifically for women.  If there exist any trends that are more specific to female users, those insights cannot be highlighted by this data in its current form.  Therefore, the analyzation of the activity trends of the Fitbit participants will be of a more general manner, and a forward assumption was made to treat the data as genderless.

Keeping the gender assumption of the dataset in mind, one of the features of the LEAF is that it helps with tracking user menstruation and ovulation.  There is nothing in the provided dataset that can be used to mimic or validate the function of that feature in even a rudimentary sense.

An additional issue to consider with the participant profiles is that there is no assumption for age or level of physical conditioning.  It may or may not be safe to assume that a condition of inclusion in the participant test pool is that they are all at least of legal adult age.  Also, without some metric regarding individual participant level of physical conditioning, some potential desirable insights would lack context and therefore be of little or no value to this study.  For example, someone who is young and has a physical condition capable of running a marathon would have a different activity intensity reaction to walking up a flight of stairs in comparison to an elderly obese man that maintains a predominantly sedentary lifestyle.  With that in mind, there is no clear definition for how the intensity values were calculated throughout the various timeframes.  Additionally, at initial glance, the METs figures in the minute-related timeframe do not appear to corroborate the corresponding intensity values.

According to the database dictionary provided by Fitbit (Fitabase):

>  Intensity

  Description: Time spent in one of four intensity categories.

  Note: The cut points for intensity classifications and METs are not determined by Fitabase, but by proprietary algorithms from Fitbit.

Upon examination, the minute-related Intensity values are either “0” or “1” regardless of the METs value, giving only two intensity-level classification possibilities.
Given that information, it was determined that the Intensity or METs data will not be useful for the purposes of this study.

Another issue with ambiguity regarding how data was collected and populated seems to exist in the daily_activity table.  There is a column called ‘LoggedActivitiesDistance’ that shows a value of ‘0’ for 32 out of the total number of 940 rows.  We are left to assume from the data dictionary that these 32 records are from activity that was manually logged by the participants, or that the 4 distinct participant Id’s included in the results of this query are potentially using a tracking device with a different recording/reporting protocol than the rest.

## Cleaning and Manipulation of Data
### Overview of the Cleaning Process
The tools used during the cleaning process and data manipulation for analysis was VSCode accessing a locally installed Microsoft SQL Server Management Studio Express Server utilizing the SQL database language.

### Steps Taken During the Cleaning Process
- Renamed all tables to maintain consistency and standardization

- Explored database tables to determine which tables would be most useful

- Checked each table schema

  - Updated and converted column datatypes from default import as varchar(50)

- Created minute_activity table from joining all minute-timeframe tables

- Created hourly_activity table from joining all hour-timeframe tables

- Established metadata info

  - Count of users for each table

  - Earliest/latest date in each table
 
  - Utilized date math to calculate and verify difference in start/end dates
 
  - Counted each distinct date record for comparison with date math

- Checked for record completion/saturation using two tables to determine level of user participation across device functionality

- Checked for duplicate records in each table being used for the study

  - No duplicates found in minute_activity table
  
  - No duplicates found in hourly_activity table
  
  - No duplicates found in daily_activity table
  
  - 3 duplicates found in daily_sleep table
  
    - Created new table with DISTINCT info from daily_sleep
    
    - Deleted original daily_sleep table
   
    - Renamed new table to replace daily_sleep after deletion
  
  - No duplicates found in hourly_intensity table
  
  - 543 duplicates found in minute_sleep table
  
    - Created new table with DISTINCT info from minute_sleep table
    
    - Deleted original minute_sleep table
    
    - Renamed new table to replace minute_sleep after deletion
  
  - No duplicates found in weight_log table

- Checked for NULL values in all tables

- Checked the daily_activity table for various issues/inconsistencies

  - There were no NULL values found in the daily_activity table

- Checked the character length of the Id column in all tables to be used

  - Id column in all tables matched with 10 characters

- Checked for outliers in all tables

  - Both the MIN and the MAX for all tables appear to be legitimate or explainable

- Validated the dataset 

  - Double checked for accuracy due to any changes made
  
  - Double checked that all data was formatted correctly

- Renamed all tables to maintain consistency and standardization

- Explored database tables to determine which tables would be most useful

- Checked each table schema

  - Updated and converted column datatypes from default import as varchar(50)

- Created minute_activity table from joining all minute-timeframe tables

- Created hourly_activity table from joining all hour-timeframe tables

- Established metadata info

  - Count of users for each table

  - Earliest/latest date in each table

  - Utilized date math to calculate and verify difference in start/end dates

  - Counted each distinct date record for comparison with date math

- Checked for record completion/saturation using two tables to determine level of user participation across device functionality

- Checked for duplicate records in each table being used for the study

  - No duplicates found in minute_activity table

  - No duplicates found in hourly_activity table

  - No duplicates found in daily_activity table

  - 3 duplicates found in daily_sleep table

    - Created new table with DISTINCT info from daily_sleep

    - Deleted original daily_sleep table

    - Renamed new table to replace daily_sleep after deletion

  - No duplicates found in hourly_intensity table

  - 543 duplicates found in minute_sleep table

    - Created new table with DISTINCT info from minute_sleep table

    - Deleted original minute_sleep table

    - Renamed new table to replace minute_sleep after deletion

  - No duplicates found in weight_log table

- Checked for NULL values in all tables

- Checked the daily_activity table for various issues/inconsistencies

  - There were no NULL values found in the daily_activity table

- Checked the character length of the Id column in all tables to be used

  - Id column in all tables matched with 10 characters

- Checked for outliers in all tables

  - Both the MIN and the MAX for all tables appear to be legitimate or explainable

- Validated the dataset 

  - Double checked for accuracy due to any changes made

  - Double checked that all data was formatted correctly


## Analysis and Discussion
### Overview of the Analysis Process
The initial question posed regarding trends in smart device usage led to an examination of the measurable features available from the Fitbit data and how they appear to be used by the members of the test pool.  A series of metrics can be extrapolated from those features for the purposes of objective analyzation for marketing while keeping subjective metrics in mind for the customer experience and which available features might be most likely to have influence by leading to a potential change in activity or behavior by the individual user.

Generally, summary statistics were calculated using different options for each metric based on various available time frames.  

### Daily Active Users and Churn Rate

Out of the 33 total participants in the study, 21 of them (or 67%) wore their devices in some fashion every day over the study period.  Out of that group, only 3 wore their devices every night of the study while they slept.  And further still, 1 participant measured their weight for 30 days of the study with another participant coming in second place with 24 days.

Unfortunately, since we aren’t furnished with the dates that participants first started using their fitness trackers, as well as the duration of the study period being simply too short, it isn’t possible to determine whether the frequency of participants that did not wear their fitness trackers consistently is a marker of churn rate (a measure of the rate at which users stop using their devices).  A dataset of a longer duration and preferably one that included participant feedback would need to be acquired before a definitive answer on that topic was possible.

### Feature Usage and Device Interoperability

![count-of-participants-utilizing-each-feature](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/count-of-participants-utilizing-each-feature.png)

By and large, most of the data that was collected was done so in a passive manner for the participants, meaning all they had to do was to wear their fitness tracker and the data was collected automatically for them and then synced with the accompanying app.  Since we don’t have data pertaining to participant feedback, we can make some assumptions through analyzation as to which features the participants appear to prioritize.

It makes sense that the sections of the data that were automatically collected would be the most populated (such as most of the information in the daily_activity table), simply because it took no extra or concerted effort on the part of the participant.  It stands to reason why the weight_log table shows such a limited participation rate.  Participation required the users to either be motivated, or required to remember, to take some sort of additional step or action to record their weight in the app.  41 out of 67 total records in that table were collected by participants manually entering their weight into the app.  Additionally, 30 of those records represented a single participant.

According to the data dictionary, Fitbit users can manually input their sleep data into the app.  However, the dataset does not indicate which records were entered manually vs those collected automatically.  Furthermore, sleep data would only be automatically collected by supported device models.  So, we have no indication of whether a lack of records from a particular participant is specifically due to their fitness tracking device model lacking the capability or if they made the conscious choice to not wear their device while sleeping.  That being stated, it’s not a stretch to imagine that some participants in the study made the conscious choice to not wear their fitness trackers while sleeping due to comfort.  This is where the Bellabeat Leaf tracker shines because it allows the user to clip it to their pajamas which some users might find more comfortable or appealing.

A logical conclusion from analyzation of the weight_log information is that weight logging under their individual circumstances is not a priority for the vast majority of this group of participants.  This could offer an opportunity to make some modifications to both offered product lines as well as marketing strategies that could have the potential to generate additional revenue and an increase in engagement between the customers and the app.  Bellabeat could offer features regarding weight tracking, as well as design and market an accompanying scale that would allow a user to pair it with the app via a Bluetooth connection.  A marketing/educational campaign could be designed to inform users about the health benefits of weight management as well as setting and tracking fitness goals.  Additionally, the app could be modified to offer the ability to create custom reminders for users to set fitness goals and manage incremental steps to achieve them.

### Session Duration

![daily-avg-active-hours-per-id](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-avg-active-hours-per-id.png(

In the chart above, the results were ordered by the recorded daily average active hours per Id and ranked from highest to lowest.  These figures disregard the overall count of records per Id.  The highest average daily wear time of the participants was 24 hours, and the lowest was 15.2 hours.

![daily-count-of-hourly-wear-time](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-count-of-hourly-wear-time.png)

The chart above is looking at a distribution of daily count of hourly wear times.  Similarly to the previous chart, these results overlook variations in the number of daily records among users.  The way the figures were calculated was to add together all the minutes spent at the various activity levels (Very Active, Fairly Active, Lightly Active, and Sedentary), and then count the number in each specified time group.  As can be seen above, the largest portion of records represent days where participants wore their devices for the entire day.  The next two most populated time slots would represent days where participants most likely put their fitness trackers on in the morning and took them off in the evening before bed.

![avg-daily-steps-per-ids-avg-active-hours-per-id](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/avg-daily-steps-per-ids-avg-active-hours-per-id.png)

After analyzing the data with the available tools, it is unclear whether there is any correlation between the average hours a participant wore their device, the average number of steps they took each day, and the number of days that each of them wore their devices during the study.
As can be seen in the above chart, the values for average active hours per day per Id ranged from a high of 24 to a low of 15.2, and the average daily steps per Id ranged from a high of 16,040 to a low of 916.

![daily-activity-records-count-per-id](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-activity-records-count-per-id.png)

The total count of daily records per Id ranged from a high of 31 (the full length of the study period) and a low of only 4.  Out of the 33 total participants in the study group, 21 of them were active with their fitness trackers in some way for all 31 days of the study.

### Activity by Days of the Week

![count-of-daily-records-by-day-of-the-week](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/count-of-daily-records-by-day-of-the-week.png)

On average during the study period, Tuesday was the day of the week that the participants were most likely to wear their fitness trackers.  This can be seen by looking at a count of records grouped by the day of the week.  Monday was the day that participants were least likely to wear their fitness trackers.

### Device Usage During Sleep

![daily-activity-records-count-per-id](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-activity-records-count-per-id.png)

The chart above has been repeated from a previous section but is included again to show the contrast in participation rate between the daily_activity records per Id and the daily_sleep records per Id, which can be seen below.

![daily-sleep-records-count-per-id](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-sleep-records-count-per-id.png)

Taking a count of the records per Id in both the daily_activity and daily_sleep tables shows that 9 of the 33 total participants in the group did not log sleep data through manual or automatic collection methods at any point during the study period.  If you also include participants who only wore their devices five times or less, it’s roughly half of the group.  There is the possibility that those 9 participants use devices that don’t include sleep tracking capabilities, or they chose to not wear their devices while they slept as well as not reporting their sleep data manually.  Either way, there were participants in the group that wore their devices to bed or logged their sleep data with less consistency than others.

The contrast between the charts above could show that participants value tracking their daily activity more than tracking their sleep.  It’s impossible to say for sure what the driving force is based on the available dataset.  However, it could be safe to assume that comfort and convenience might be playing a role.
Another possibility that should at least be acknowledged is that some Fitbit users could be mostly concerned with the function of their devices as smartwatches that further the range of use and functionality for their cellphones.  The Bellabeat leaf does not have the same range of functions in this regard as a smartwatch.  This might mean that the level of engagement of those users might include fitness and sleep tracking as a supplementary function of lesser importance when compared to their ability to receive various cellphone notifications more conveniently.  This could further explain why some users chose not to wear their devices while sleeping or did so on a less consistent basis than others.

### Averages of Sleep Records by Day of the Week

![daily-sleep-records-by-day-of-the-week](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-sleep-records-by-day-of-the-week.png)

Looking at a count of the sleep records by day of the week shows that participants tended to wear their fitness trackers to bed the most in the middle of the week and less on the weekends, but especially on Mondays.

### Manual Data Logging vs. Paired Device and Automatic Collection
The dataset’s dictionary makes references to the ability for users to manually log their fitness data in connection with several different available features offered by Fitbit.  However, the weight_log table is the only one that offers a notation for the specific data collection method that was used.  This is done through a column called ‘IsManualReport’ and offers results in a binary form with values of either ‘True’ or ‘False’.  It is unfortunate the table for that feature is the one that shows the lowest participation rate among the population of the testing pool.

![weight-log-info-matrix](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/weight-log-info-matrix.png)

What we are able to see from viewing the weight_log table is that the split between participants that manually logged their weight versus participants that used a connected device wasn’t evenly distributed.  However, most of the occurrences were dominated by two distinct participants.  One of those participants logged their weight a total of 30 times and did so using a manual logging method in the app and the other automatically logged their weight 24 times using an unknown connected device.  Two other participants used a connected device, but both logged their weight only once during the study period.  All other participants used a manual logging method.  In total, there were 41 records collected manually and 26 that were collected automatically using a connected device.

### Weight Logging Data by Day of the Week

![daily-weight-records-by-day-of-the-week](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/daily-weight-records-by-day-of-the-week.png)

The eight participants out of the group that utilized the weight logging feature tended to weigh themselves most between Sunday and Thursday.  Friday and Saturday had the lowest number of records for the week with 6 and 7 weigh sessions, respectively.  Mondays and Wednesdays were tied for first place with 12 each.

### Weight Change Over Study Period

![weight-change-info-matrix](https://github.com/k1bray/bellabeat_case_study/blob/main/Images/weight-change-info-matrix.png)

Five of the eight participants saw no change in their weight over the course of the study period.  However, it should be noted that those participants only logged their weight 1 or 2 times in total.  The remaining three saw an increase in their weight over the study period.  This includes participants that logged their weight 30, 24, and 5 times, making up the bulk of the 67 total records.  The average weight increase in those users was 1-2kg over the course of the study period.

## Recommendations and Possible Further Actions Based on Analysis

1.	Add goal tracking functionality options to the Bellabeat app, such as weight, or some other fitness related metric (couch to 5k?).  The app could offer an option of “morning/evening briefing report” that showed the previous/current day’s stats to help with daily and long-term goal setting/tracking.  As previously stated in the analysis summary, weight logging doesn’t seem to be a high priority for the Fitbit participants in the test pool.  If this was a feature that Bellabeat would consider adding in the future, it would be prudent to acquire additional data beyond what is provided by this study due to the anemic representation of the weight_log table.  However, the fact that the members of the test pool displayed such limited participation in this study could indicate that the feature is not something that the Bellabeat users would embrace.  The ROI for the effort may not be worth the undertaking, but further study would be required to properly answer the question.   If Bellabeat were potentially interested in the answer, a follow-up question with a more limited scope might be how users would respond to the weight logging feature if they were issued a reminder through the device app.  Perhaps the participation numbers were so low because the other data is by-and-large collected automatically, and weight logging requires the participant to remember and take action.

2.	Create and market a new product as a connected smart scale so that users would be more likely to log their weight with a reminder prompt from the app, or partner with a company with an existing smart-enabled product that could be made compatible with the Bellabeat app.

3.	The Bellabeat app could have active reminders based on activity tracking, such as alarms or reminders for consistent sleep habits, or notifications after either a preset default or customizable duration of recoded sedentary activity.  This could be done in conjunction with launching an education campaign about health-related topics, such as the benefits of reaching daily step goals.


4.	Push the message with marketing that Bellabeat products have 6-month battery life and don’t require daily charging.  Also, that they are elegant style and fashion statements that can be worn for almost any occasion, and that Bellbeat products can potentially be worn more comfortably and conveniently than a smartwatch-style device, especially during sleep.
