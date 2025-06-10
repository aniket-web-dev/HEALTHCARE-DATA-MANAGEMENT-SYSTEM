-- Retrieve HCPs working in 'Healthcare Org 5'
SELECT hcp.FirstName, hcp.LastName, hco.HCO_Name
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID
WHERE hco.HCO_Name = 'Healthcare Org 5';

-- Get unique cities where HCPs are located
SELECT DISTINCT City FROM HCP_Address;

-- Join HCP with HCP_Specialty to get HCP names and their specialties
SELECT hcp.FirstName, hcp.LastName, hs.Specialty, hs.SubSpecialty
FROM HCP hcp
JOIN HCP_Specialty hs ON hcp.HCP_ID = hs.HCP_ID;

-- Retrieve HCP details along with the organization they belong to
SELECT hcp.FirstName, hcp.LastName, hco.HCO_Name, hco.Address AS HCO_Address
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID;


-- Find the HCO_ID with the most HCPs using  Subquerie
SELECT FirstName, LastName, HCO_ID
FROM HCP
WHERE HCO_ID = (
    SELECT TOP 1 HCO_ID
    FROM HCP
    GROUP BY HCO_ID
    ORDER BY COUNT(*) DESC
);

SELECT TOP 10 * FROM hcp;

SELECT distinct hcp_id FROM HCP_Specialty where SubSpecialty like 'Rese%';

SELECT * FROM hcp where hcp_id in (SELECT distinct hcp_id FROM HCP_Specialty where SubSpecialty = 'Research');

SELECT (SELECT distinct SubSpecialty FROM HCP_Specialty where SubSpecialty = 'Research') SubSpecialty, hcp.*  FROM hcp 
where hcp_id in (SELECT distinct hcp_id FROM HCP_Specialty where SubSpecialty = 'Research');

-- Count how many HCPs are in each organization
SELECT hco.HCO_Name, COUNT(hcp.HCP_ID) AS HCP_Count
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID
GROUP BY hco.HCO_Name
ORDER BY HCP_Count DESC;


-- Find the most common specialty by counting occurrences
SELECT Specialty, COUNT(*) AS Count
FROM HCP_Specialty
GROUP BY Specialty
ORDER BY Count DESC;


-- Rank HCOs based on the number of HCPs they have
SELECT hco.HCO_Name, COUNT(hcp.HCP_ID) AS HCP_Count,
       RANK() OVER (ORDER BY COUNT(hcp.HCP_ID) DESC) AS Rank
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID
GROUP BY hco.HCO_Name;

-- Rank HCOs based on the number of HCPs they have
SELECT hco.HCO_Name, COUNT(hcp.HCP_ID) AS HCP_Count,
       DENSE_RANK() OVER (ORDER BY COUNT(hcp.HCP_ID) DESC) AS Rank
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID
GROUP BY hco.HCO_Name;

-- Rank HCOs based on the number of HCPs they have
SELECT hco.HCO_Name, COUNT(hcp.HCP_ID) AS HCP_Count,
       ROW_NUMBER() OVER (ORDER BY COUNT(hcp.HCP_ID) DESC) AS Rank
FROM HCP hcp
JOIN HCO hco ON hcp.HCO_ID = hco.HCO_ID
GROUP BY hco.HCO_Name;

-- Use CTE to filter organizations that have more than 5 HCPs
WITH HCO_Count AS (
    SELECT HCO_ID, COUNT(*) AS HCP_Count
    FROM HCP
    GROUP BY HCO_ID
    HAVING COUNT(*) > 1
),
y as 
(SELECT hcp.FirstName, hcp.LastName, hco.HCO_Name
FROM HCP hcp
JOIN HCO_Count hc ON hcp.HCO_ID = hc.HCO_ID
JOIN HCO hco ON hc.HCO_ID = hco.HCO_ID)
select * from y order by HCO_Name;