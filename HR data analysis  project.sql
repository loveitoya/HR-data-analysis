SELECT *
FROM hr_data_analysis.employee_training_record;

SELECT *
FROM hr_data_analysis.employee_engagement_record;


---Lets analze the data proprely
SELECT employee_id, CONCAT(first_name,'  ',last_name) AS full_name,
age,
gender,
marital_status,
race_description,
start_date,
state,
department,
business_unit,
job_title,
pay_zone,
employee_status,
employee_type,
employee_classification,
division,
performance_score,
engagement_score,
employee_rating
FROM 
hr_data_analysis.employee_engagement_record;


---Lets group employee into  age category 
SELECT employee_id, CONCAT(first_name,'  ',last_name) AS full_name,
CASE
 WHEN  AGE>=30 THEN 'Junior Staff'
 WHEN age BETWEEN 30 AND 50 THEN 'Middle_age Staff'
 ELSE
 'Senior staff'
 END AS age_category
 FROM 
hr_data_analysis.employee_engagement_record;

 ---Lets look at the oldest and youngest employee
 SELECT
 employee_id, CONCAT(first_name,'  ',last_name) AS full_name,
 age
 FROM 
hr_data_analysis.employee_engagement_record
WHERE age = (SELECT MIN(age)
FROM 
hr_data_analysis.employee_engagement_record)
OR
age = (SELECT MAX(age)
FROM 
hr_data_analysis.employee_engagement_record)


---Determine the number of employee for each department
SELECT
department,
COUNT(*) AS total_employee
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY department


----Determine marital status for employees in each department
SELECT department,marital_status,
COUNT(*) AS total_employee
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY
department,marital_status
ORDER BY
department,marital_status;

----How many male and female employees do we have across each department
SELECT
department,
gender,
COUNT(*) AS total_employee
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY 
department,gender
ORDER BY
department,gender;

---Active vs terminated employees in each department
SELECT 
department,employee_status,
COUNT(*) AS total_employees
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY department,employee_status
ORDER BY department,employee_status;

---Determine total employee type for each department
SELECT 
department,employee_type,
COUNT(*) AS total_employees
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY department,employee_type
ORDER BY
department,employee_type;


---Lets classify total employees for each department
SELECT
department, employee_classification,
COUNT(*) AS total_employees
FROM 
hr_data_analysis.employee_engagement_record 
GROUP BY 
department,employee_classification
ORDER BY
department,employee_classification;

---what are the payzone for employees in each department
SELECT 
department,pay_zone,
COUNT(*) AS total_employees
FROM hr_data_analysis.employee_engagement_record 
GROUP BY department,pay_zone
ORDER BY department,pay_zone;

---What are the total employees for each division
SELECT 
division,
COUNT(*) AS total_employees
FROM hr_data_analysis.employee_engagement_record 
GROUP BY division;


---Determine the employees performance score in each department
SELECT department,performance_score,
COUNT(*) AS total_employee
FROM hr_data_analysis.employee_engagement_record 
GROUP BY department,performance_score
ORDER BY department,performance_score;


---Lets rank employees with their training cost in each department 
SELECT
er.employee_id,
er.department,
CONCAT(er.first_name,'  ',er.last_name) AS full_name,
et.training_cost,
RANK() OVER (PARTITiON BY department ORDER BY et.training_cost DESC) AS training
FROM hr_data_analysis.employee_training_record et
JOIN hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id


---lets analyze the training record each employee
SELECT 
er.employee_id,
CONCAT(er.first_name,'  ',er.last_name) AS full_name,
et.training_date,
et.training_programe
et.training_type
et.training_outcome,
et.training_duration,
sum(et.training_cost) as total_training_cost
FROM hr_data_analysis.employee_training_record et
JOIN hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id
GROUP BY er.employee_id,
full_name,
et.training_date,
et.training_program,
et.training_outcome,
et.training_duration;


--lets analyze employee survey
SELECT
  er.employee_id,
   CONCAT(er.first_name,'  ',er.last_name) AS full_name,
   et.survey_date,
   et.satisfaction_score,
   et.work_life_balance_score
FROM 
hr_data_analysis.employee_training_record et
JOIN
hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id;


---Employeee with highest engagement per department
WITH ranked_engagement AS (
SELECT
employee_id,
CONCAT(first_name,'  ',last_name) AS full_name,
department,
engagement_score,
RANK() OVER (PARTITION BY department ORDER BY engagement_score DESC) AS rnk
FROM
hr_data_analysis.employee_engagement_record)
SELECT *
FROM ranked_engagement
WHERE rnk = 1

--Traing duration insight for each training program
SELECT 
training_program,
MAX(training_duration) AS max_duration,
MIN(training_duration) AS min_duration,
ROUND(AVG(training_duration)) AS avg_duration
FROM hr_data_analysis.employee_training_record 
GROUP BY training_program;


---Lets analyze the satisfaction level of employees
SELECT
er.employee_id,
CONCAT(er.first_name,'  ',er.last_name) AS full_name,
et.satisfaction_score,
CASE
WHEN et.satisfaction_score >=5 THEN 'High'
WHEN et.satisfaction_score >=3 THEN 'Moderate'
ELSE
'low'
END AS satisfaction_level
FROM 
hr_data_analysis.employee_training_record et
JOIN
hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id;



---Determine the top 5 most engaged employees
SELECT 
er.employee_id,
CONCAT(er.first_name,'  ',er.last_name) AS full_name,
MAX(engagement_score) AS max_engagement_score
FROM
hr_data_analysis.employee_training_record et
JOIN hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id
GROUP BY er.employee_id,full_name
ORDER BY max_engagement_score DESC
LIMIT 5;


---Top 5 employees with the highest rating
SELECT
employee_id,
CONCAT(first_name,'  ',last_name) AS full_name,
employee_rating
FROM
hr_data_analysis.employee_engagement_record
ORDER BY 
engagement_score DESC
LIMIT 5



---Determine total employees training outcome for each department
SELECT
er.department,
et.training_outcome,
COUNT(*) AS total_employees
FROM
hr_data_analysis.employee_training_record et
JOIN hr_data_analysis.employee_engagement_record er
ON et.employee_id = er.employee_id
GROUP BY er.department,et.training_outcome
ORDER BY er.department, total_employees DESC


---Analyze the training type for each department
SELECT
er.department,
et.training_type,
COUNT(*) AS total_employees
FROM
hr_data_analysis.employee_training_record et
ON et.employee_id = er.employee_id
GROUP BY er.department,et.training_type
ORDER BY er.department, total_employees  DESC




































































