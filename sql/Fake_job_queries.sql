CREATE DATABASE job_fraud_analysis;
USE job_fraud_analysis;

RENAME TABLE fake_real_job_postings TO jobs;

-- Fake Vs Real Jobs-- 
SELECT is_fake,COUNT(*) AS total_jobs
FROM jobs 
GROUP BY is_fake;

-- Fraud percentage--  
SELECT (SUM(is_fake)/COUNT(*))*100 AS fraud_percentage
FROM jobs;

-- Top locations with fake jobs--
SELECT 
    location,
    COUNT(*) AS total_jobs,
    SUM(is_fake) AS fake_jobs,
    (SUM(is_fake) / COUNT(*)) * 100 AS fraud_rate
FROM jobs
GROUP BY location
HAVING total_jobs > 10
ORDER BY fraud_rate DESC
LIMIT 10;

-- Fraud rate by industry
SELECT 
industry,
COUNT(*) AS total_jobs,
SUM(is_fake) AS fake_jobs,
(SUM(is_fake)/COUNT(*))*100 AS fraud_rate
FROM jobs
GROUP BY industry
ORDER BY fraud_rate DESC;


Keyword Impact-- 
SELECT keyword_flag, COUNT(*) AS total
FROM jobs
GROUP BY keyword_flag
ORDER BY keyword_flag DESC;

-- High Suspicious Score Jobs--
SELECT job_title,company_name,suspicious_score
FROM jobs
ORDER BY suspicious_score DESC
LIMIT 10;

-- Fake Jobs by Employment Type--  
SELECT employment_type,COUNT(*) AS fake_jobs
FROM jobs
WHERE is_fake=1
GROUP BY employment_type 
ORDER BY fake_jobs DESC;

-- Deadline pattern-- 
SELECT
AVG(DATEDIFF(application_deadline,posting_date))AS avg_days
FROM jobs
WHERE is_fake=1;

-- Multi-condition Fraud Detection-- 
SELECT COUNT(*) AS highly_suspicious
FROM jobs 
WHERE has_website=0
AND desc_length <200
AND keyword_flag >0;

-- Suspicious Score vs Actual Fraud
SELECT suspicious_score ,
COUNT(*) AS total_jobs,
SUM(is_fake) AS fake_jobs
FROM jobs
GROUP BY suspicious_score 
ORDER BY suspicious_score DESC;

-- Remote Jobs vs Fraud
SELECT telecommuting,
COUNT(*) AS fake_jobs,
SUM(is_fake) AS fake_jobs
FROM jobs
GROUP BY telecommuting;

-- Experience Level vs Fraud
SELECT required_experience_years,
COUNT(*) AS total_jobs,
SUM(is_fake) AS fake_jobs
FROM jobs 
GROUP BY required_experience_years
ORDER BY fake_jobs DESC;



