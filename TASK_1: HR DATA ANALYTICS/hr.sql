-- SQL HR DATA ASSESSMENT QUESTIONS - PSYLIQ

SHOW DATABASES;
USE hranalytics;
SHOW TABLES;
SELECT * from hr_table;

/* 1. Retrieve the total number of employees in the dataset. */
SELECT COUNT(*) AS Total_Employees FROM hr_table;

/* 2. List all unique job roles in the dataset */
SELECT DISTINCT JobRole AS Job_Role FROM hr_table;

/* 3. Find the average age of employees. */
SELECT AVG(Age) AS Average_Age FROM hr_table;

/* 4. Retrieve the names and ages of employees who have worked at the company for more than 5 years */
SELECT EmpName, Age 
FROM hr_table 
WHERE YearsAtCompany > 5;

/* 5. Get a count of employees grouped by their department. */
SELECT Department, COUNT(*) AS employee_count
FROM hr_table
GROUP BY Department;

/* 6. List employees who have 'High' Job Satisfaction. */
SELECT EmpName AS EMP_NAME_HIGH FROM hr_table WHERE JobLevel = 3;

/* 7. Find the highest Monthly Income in the dataset. */
SELECT MAX(MonthlyIncome) AS highest_income FROM hr_table;

/* 8. List employees who have 'Travel_Rarely' as their BusinessTravel type. */
SELECT EMPLOYEEID, EmpName
FROM hr_table
WHERE BusinessTravel = 'Travel_Rarely';

/* 9. Retrieve the distinct MaritalStatus categories in the dataset. */
SELECT DISTINCT MaritalStatus
FROM hr_table;

/* 10. Get a list of employees with more than 2 years of work experience but less than 4 years in
their current role. */
SELECT EmployeeID, EmpName FROM hr_table WHERE TotalWorkingYears > 2 AND YEARSATCOMPANY > 2 AND YearsWithCurrManager < 4 AND YearsSinceLastPromotion < 4;

/* 11. List employees who have changed their job roles within the company (JobLevel and
JobRole differ from their previous job). */
SELECT
EmployeeID,
EmpName,
CurrentJobRole,
PreviousJobRole,
CurrentJobLevel,
PreviousJobLevel
FROM (
SELECT
EmployeeID,
EmpName,
JobRole AS CurrentJobRole,
JobLevel AS CurrentJobLevel,
LAG(JobRole) OVER (PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobRole,
LAG(JobLevel) OVER (PARTITION BY EmployeeID ORDER BY YearsAtCompany) AS PreviousJobLevel
FROM hr_table
) AS JobChanges
WHERE (CurrentJobRole <> PreviousJobRole)
OR (CurrentJobLevel <> PreviousJobLevel);

/* 12. Find the average distance from home for employees in each department. */
SELECT Department, AVG(DistanceFromHome) AS avg_distance
FROM hr_table
GROUP BY Department;

/* 13. Retrieve the top 5 employees with the highest MonthlyIncome. */
SELECT EmployeeID, EmpName, MonthlyIncome
FROM hr_table
ORDER BY MonthlyIncome DESC
LIMIT 5;

/* 14. Calculate the percentage of employees who have had a promotion in the last year. */
SELECT (COUNT(CASE WHEN YearsSinceLastPromotion <= 1 THEN 1 END) / COUNT(*)) * 100 AS Promotion_Percentage FROM hr_table;

/* 15. List the employees with the highest and lowest EnvironmentSatisfaction. */
SELECT a.EmpName, b.EnvironmentSatisfaction
FROM hr_table a 
INNER JOIN employee_survey_table b ON a.EmployeeID = b.EmployeeID 
WHERE b.EnvironmentSatisfaction = (
    SELECT MAX(EnvironmentSatisfaction) FROM employee_survey_table
)
OR b.EnvironmentSatisfaction = (
    SELECT MIN(EnvironmentSatisfaction) FROM employee_survey_table
);

/* 16. Find the employees who have the same JobRole and MaritalStatus. */
SELECT EmployeeID, EmpName, JobRole, MaritalStatus FROM hr_table e1
WHERE EXISTS (
SELECT 1
FROM hr_table e2
WHERE e1.EmployeeID <> e2.EmployeeID
AND e1.JobRole = e2.JobRole
AND e1.MaritalStatus = e2.MaritalStatus
)
ORDER BY JobRole, MaritalStatus, EmployeeID;

/* 17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4. */
SELECT a.EmployeeID, a.EmpName, a.TotalWorkingYears, b.PerformanceRating
FROM hr_table a
JOIN manager_survey_table b ON a.EmployeeID = b.EmployeeID WHERE b.PerformanceRating = 4
AND a.TotalWorkingYears = (
SELECT MAX(TotalWorkingYears)
FROM hr_table
WHERE EmployeeID IN (
SELECT EmployeeID
FROM manager_survey_table
WHERE PerformanceRating = 4
)
);

/* 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type. */
SELECT a.EmployeeID, a.BusinessTravel, AVG(a.Age) AS AverageAge, b.EmployeeID, b.JobSatisfaction
FROM hr_table a LEFT JOIN employee_survey_table b ON a.EmployeeID = b.EmployeeID
GROUP BY a.BusinessTravel;


/* 19. Retrieve the most common EducationField among employees. */
SELECT EducationField, COUNT(*) AS Frequency
FROM hr_table
GROUP BY EducationField
ORDER BY COUNT(*) DESC
LIMIT 1;

/* 20. List the employees who have worked for the company the longest but haven't had a promotion. */
SELECT EmployeeID, EmpName, YearsAtCompany, YearsSinceLastPromotion
FROM hr_table
WHERE YearsAtCompany = (
SELECT MAX(YearsAtCompany)
FROM hr_table
)
AND YearsSinceLastPromotion = 0;

