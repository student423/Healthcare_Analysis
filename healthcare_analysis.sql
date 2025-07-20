-- create database
CREATE DATABASE health_db;
USE health_db;

-- create table and load data
CREATE TABLE patient_appointment(
PatientId BIGINT,
    AppointmentID BIGINT,
    Gender VARCHAR(10),
    ScheduledDay 	VARCHAR(50),
    AppointmentDay VARCHAR(50),
    Age INT,
    Neighbourhood VARCHAR(100),
    Scholarship TINYINT,
    Hipertension TINYINT,
    Diabetes TINYINT,
    Alcoholism TINYINT,
    Handcap TINYINT,
    SMS_received TINYINT,
    No_show VARCHAR(5)
);

-- check data
SELECT * FROM patient_appointment;

-- Check for Null/Blank/Empty Values
SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN PatientId = '' THEN 1 ELSE 0 END) AS missing_patient_id,
       SUM(CASE WHEN AppointmentID = '' THEN 1 ELSE 0 END) AS missing_appointment_id,
       SUM(CASE WHEN Gender = '' THEN 1 ELSE 0 END) AS missing_gender,
       SUM(CASE WHEN ScheduledDay  = '' THEN 1 ELSE 0 END) AS missing_scheduled_day,
       SUM(CASE WHEN AppointmentDay  = '' THEN 1 ELSE 0 END) AS missing_appointment_day,
       SUM(CASE WHEN Age = '' THEN 1 ELSE 0 END) AS missing_age,
       SUM(CASE WHEN Neighbourhood = '' THEN 1 ELSE 0 END) AS missing_neighbourhood,
       SUM(CASE WHEN Scholarship  = '' THEN 1 ELSE 0 END) AS missing_scholarship,
       SUM(CASE WHEN Hipertension = '' THEN 1 ELSE 0 END) AS missing_hipertension,
       SUM(CASE WHEN Diabetes  = '' THEN 1 ELSE 0 END) AS missing_diabetes,
       SUM(CASE WHEN Alcoholism = '' THEN 1 ELSE 0 END) AS missing_alcoholism,
       SUM(CASE WHEN Handcap = '' THEN 1 ELSE 0 END) AS missing_handcap,
       SUM(CASE WHEN SMS_received = '' THEN 1 ELSE 0 END) AS missing_sms,
       SUM(CASE WHEN `No_Show` = '' THEN 1 ELSE 0 END) AS missing_no_show
FROM patient_appointment;

-- replace blanl with zero values 
SET SQL_SAFE_UPDATES=0;

UPDATE patient_appointment
SET Age=0
WHERE Age='';

UPDATE patient_appointment
SET Scholarship=0
WHERE Scholarship='';

UPDATE patient_appointment
SET Hipertension=0
WHERE Hipertension='';

UPDATE patient_appointment
SET Diabetes=0
WHERE Diabetes='';

UPDATE patient_appointment
SET Alcoholism=0
WHERE Alcoholism='';

UPDATE patient_appointment
SET Handcap=0
WHERE Handcap='';

UPDATE patient_appointment
SET SMS_received=0
WHERE SMS_received='';

-- chnage data types of scheduleday and appointmentday colm

-- first add column bcz we have diff format of data 
ALTER TABLE patient_appointment
ADD COLUMN ScheduleDay_Clean DATETIME,
ADD COLUMN AppointmentDay_Clean DATETIME;

-- updates vales in new column
UPDATE patient_appointment
SET ScheduleDay_Clean = STR_TO_DATE(SUBSTRING_INDEX(ScheduledDay, 'T', 1), '%Y-%m-%d'),
    AppointmentDay_Clean = STR_TO_DATE(SUBSTRING_INDEX(ScheduledDay, 'T', 1), '%Y-%m-%d');
    
-- drop old colm
ALTER TABLE patient_appointment
DROP COLUMN  ScheduledDay,
DROP COLUMN AppointmentDay ; 

-- rename column name
ALTER TABLE patient_appointment
CHANGE COLUMN ScheduleDay_Clean ScheduleDay DATETIME,
CHANGE COLUMN AppointmentDay_Clean AppointmentDay DATETIME;


-- Exploratory Data Analysis(EDA) in SQL

-- Total Appointments & Show/No-show Count
SELECT COUNT(*) AS total_appointment,
SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS shows,
SUM(CASE WHEN No_show = 'No' THEN 1 ELSE 0 END) AS no_shows
FROM patient_appointment;

-- Gender-wise No-show Analysis
SELECT Gender,
COUNT(*) AS total,
SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
CONCAT(ROUND(SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*),2),'%') AS per_rate
FROM patient_appointment
GROUP BY Gender;

-- Age Distribution with Buckets
SELECT
CASE
   WHEN Age <18 THEN 'child'
   WHEN Age BETWEEN 18 AND 35 THEN 'young_aged'
   WHEN Age BETWEEN 36 AND 60 THEN 'middle_aged'
   ELSE 'senior'
END AS age_group,
COUNT(*) AS total_patient
FROM patient_appointment
GROUP BY age_group
ORDER BY total_patient DESC;

-- SMS Received vs No-show
SELECT 
SMS_received,
No_show,
COUNT(*) AS total_count
FROM patient_appointment
GROUP BY SMS_received,No_show;

--  Weekday Trends
SELECT 
  DAYNAME(ScheduleDay) AS schedule_day,
  COUNT(*) AS total_appointment,
  SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows
FROM patient_appointment
GROUP BY schedule_day
ORDER BY FIELD(schedule_day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- Feature Engineering in sql

-- create Appointment_Weekday colmn
ALTER TABLE patient_appointment
ADD COLUMN Appointment_Weekday VARCHAR(10);

-- extract weekday
UPDATE patient_appointment
SET Appointment_Weekday = DAYNAME(AppointmentDay);

-- create Age_Group colmn 
ALTER TABLE patient_appointment
ADD COLUMN Age_Group VARCHAR(20);

-- set values in diff age categorical
UPDATE patient_appointment
SET Age_Group =
  CASE
    WHEN Age BETWEEN 0 AND 12 THEN 'Child'
    WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
    WHEN Age BETWEEN 20 AND 35 THEN 'Young Adult'
    WHEN Age BETWEEN 36 AND 60 THEN 'Adult'
    ELSE 'Senior'
END; 

-- Show vs No-Show by Hypertension
SELECT
   Hipertension,
   COUNT(*) AS total_patients,
   SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
   CONCAT(ROUND(SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*),2),'%') AS no_shows_percentage
FROM patient_appointment
GROUP BY Hipertension
ORDER BY no_shows_percentage DESC;

-- Correlation Check
SELECT
  Scholarship, SMS_received, Hipertension, Diabetes, Alcoholism, Handcap,
  CONCAT(ROUND(AVG(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END), 2),'%') AS No_Show_Rate
FROM patient_appointment
GROUP BY Scholarship, SMS_received, Hipertension, Diabetes, Alcoholism, Handcap;


-- Show vs No-Show by Diabetes, Alcoholism, and Handcap
SELECT
   'Diabetes',
   Diabetes,
   COUNT(*) AS total_patient,
   SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
   CONCAT(ROUND(SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*),2),'%') AS no_shows_rate
FROM patient_appointment
GROUP BY Diabetes

UNION ALL

SELECT
  'Alcoholism',
   Alcoholism,
   COUNT(*) AS total_patient,
   SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
   CONCAT(ROUND(SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*),2),'%') AS no_shows_rate
FROM patient_appointment
GROUP BY Alcoholism

UNION ALL

SELECT
   'Handcap',
   Handcap,
   COUNT(*) AS total_patient,
   SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
   CONCAT(ROUND(SUM(CASE WHEN No_show = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*),2),'%') AS no_shows_rate
FROM patient_appointment
GROUP BY Handcap;

-- Rank Top 10 Diseases Based on No-Show Ratepatient_appointment
WITH condition_stats AS (
  SELECT 'Hipertension' AS condition_name, Hipertension AS Value,
         COUNT(*) AS Total, SUM(No_show = 'Yes') AS NoShows,
        CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%')AS No_Show_Rate
  FROM patient_appointment
  GROUP BY Hipertension

  UNION ALL

  SELECT 'Diabetes' AS condition_name, Diabetes AS value, COUNT(*), SUM(No_show = 'Yes'),
         CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate
  FROM patient_appointment
  GROUP BY Diabetes

  UNION ALL

  SELECT 'Alcoholism' AS condition_name, Alcoholism AS value, COUNT(*), SUM(No_show = 'Yes'),
        CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate
  FROM patient_appointment
  GROUP BY Alcoholism

  UNION ALL

  SELECT 'Handcap'AS condition_name, Handcap AS value, COUNT(*), SUM(No_show = 'Yes'),
         CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate
  FROM patient_appointment
  GROUP BY Handcap
)

SELECT *,
       RANK() OVER (PARTITION BY condition_name ORDER BY No_Show_Rate DESC) AS Rank_By_Condition
FROM condition_stats
ORDER BY No_Show_Rate DESC;

-- Age Group vs Appointment Weekday Behavior
SELECT 
  Age_Group,
  Appointment_Weekday,
  COUNT(*) AS Total,
  SUM(No_show = 'Yes') AS No_Shows,
  CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate
FROM patient_appointment
GROUP BY Age_Group, Appointment_Weekday
ORDER BY Age_Group, No_Show_Rate DESC;

-- Top 5 Neighborhoods by No-Show Rate
SELECT 
  Neighbourhood,
  COUNT(*) AS Total_Appointments,
  SUM(No_show = 'Yes') AS No_Shows,
  ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2) AS No_Show_Rate
FROM patient_appointment
GROUP BY Neighbourhood
HAVING COUNT(*) > 100
ORDER BY No_Show_Rate DESC
LIMIT 5;

--  Use DENSE_RANK() to find top 1 or top 3 problematic weekdays for each age group
WITH age_day_ranked AS (
  SELECT 
    Age_Group,
    Appointment_Weekday,
    COUNT(*) AS Total_Appointments,
    SUM(No_show = 'Yes') AS No_Shows,
    CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate,
    DENSE_RANK() OVER (PARTITION BY Age_Group ORDER BY SUM(No_show = 'Yes') * 100.0 / COUNT(*) DESC) AS Rank_Show_Rate
  FROM patient_appointment
  GROUP BY Age_Group, Appointment_Weekday
)

SELECT * 
FROM age_day_ranked
WHERE Rank_Show_Rate <= 3  
ORDER BY Age_Group, Rank_Show_Rate;

-- Top 3 Most Reliable Weekdays per Age Group
WITH age_day_reliable AS (
  SELECT 
    Age_Group,
    Appointment_Weekday,
    COUNT(*) AS Total_Appointments,
    SUM(No_show = 'Yes') AS No_Shows,
    CONCAT(ROUND(SUM(No_show = 'Yes') * 100.0 / COUNT(*), 2),'%') AS No_Show_Rate,

    DENSE_RANK() OVER (PARTITION BY Age_Group ORDER BY SUM(No_show = 'Yes') * 100.0 / COUNT(*) ASC ) AS Rank_Reliable_Day

  FROM patient_appointment
  GROUP BY Age_Group, Appointment_Weekday
)

SELECT * 
FROM age_day_reliable
WHERE Rank_Reliable_Day <= 3
ORDER BY Age_Group, Rank_Reliable_Day;

-- thank you
