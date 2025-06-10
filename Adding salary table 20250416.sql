-- =============================================
-- File: insert_hcp_salary.sql
-- Description: Creates the hcp_salary table, inserts
-- 100 rows with a random grade (A-J) and
-- corresponding salary based on grade,
-- and includes a cursor-based update example.
-- =============================================

-- 1. Create the hcp_salary table (child table)
CREATE TABLE hcp_salary (
    hcp_id INT PRIMARY KEY,
    grade CHAR(1),
    salary INT -- salary in rupees per annum
);
GO

-- 2. Populate the hcp_salary table with 100 rows
-- Each row gets a random grade and a salary as per the grade.
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    DECLARE @grade CHAR(1);
    DECLARE @salary INT;
    
    -- Generate a random grade between 'A' (ASCII 65) and 'J' (ASCII 74)
    SET @grade = CHAR(65 + (ABS(CHECKSUM(NEWID())) % 10));
    
    -- Assign salary based on grade
    SET @salary = CASE @grade
                  WHEN 'A' THEN 4500000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 45,00,000 to 50,00,000
                  WHEN 'B' THEN 4000000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 40,00,000 to 45,00,000
                  WHEN 'C' THEN 3500000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 35,00,000 to 40,00,000
                  WHEN 'D' THEN 3000000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 30,00,000 to 35,00,000
                  WHEN 'E' THEN 2500000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 25,00,000 to 30,00,000
                  WHEN 'F' THEN 2000000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 20,00,000 to 25,00,000
                  WHEN 'G' THEN 1500000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 15,00,000 to 20,00,000
                  WHEN 'H' THEN 1000000 + (ABS(CHECKSUM(NEWID())) % 500000) -- 10,00,000 to 15,00,000
                  WHEN 'I' THEN 700000 + (ABS(CHECKSUM(NEWID())) % 300000) -- 7,00,000 to 10,00,000
                  ELSE 400000 -- J: 4,00,000 fixed
                 END;
    
    INSERT INTO hcp_salary (hcp_id, grade, salary)
    VALUES (@i, @grade, @salary);
    
    SET @i = @i + 1;
END;
GO

select * from hcp_salary;


select * from HCP 
JOIN hcp_salary ON HCP.hcp_id = hcp_salary.hcp_id order by hcp_salary.salary;


​



​
-- 1. Create new table for updated data
CREATE TABLE hcp_salary_updated (
    hcp_id INT PRIMARY KEY,
    grade CHAR(1),
    old_salary INT,
    updated_salary INT
);
GO

-- 2. Cursor to read from original table and insert updated values into new table
DECLARE @hcpId INT, @salary INT, @grade CHAR(1), @updated_salary INT;

DECLARE salary_cursor CURSOR FOR
SELECT hcp_id, salary, grade FROM hcp_salary;

OPEN salary_cursor;

FETCH NEXT FROM salary_cursor INTO @hcpId, @salary, @grade;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Update logic: Add 50,000 if salary is less than 50,00,000
    IF @salary < 5000000
        SET @updated_salary = @salary + 50000;
    ELSE
        SET @updated_salary = @salary;

    -- Insert into new table
    INSERT INTO hcp_salary_updated (hcp_id, grade, old_salary, updated_salary)
    VALUES (@hcpId, @grade, @salary, @updated_salary);

    FETCH NEXT FROM salary_cursor INTO @hcpId, @salary, @grade;
END;

CLOSE salary_cursor;
DEALLOCATE salary_cursor;
GO

select * from hcp_salary;
select * from hcp_salary_updated;


UPDATE hcp_salary_updated
SET grade = 
    CASE 
        WHEN updated_salary >= 4500000 THEN 'A'
        WHEN updated_salary >= 4000000 THEN 'B'
        WHEN updated_salary >= 3500000 THEN 'C'
        WHEN updated_salary >= 3000000 THEN 'D'
        WHEN updated_salary >= 2500000 THEN 'E'
        WHEN updated_salary >= 2000000 THEN 'F'
        WHEN updated_salary >= 1500000 THEN 'G'
        WHEN updated_salary >= 1000000 THEN 'H'
        WHEN updated_salary >= 700000 THEN 'I'
        ELSE 'J'
    END;
