-- ========================================================================
-- v1_assmang_mining_base.sql
-- ========================================================================
-- Assmang Pty Ltd: Mining Operations Database (Version 1)
-- Used in: Day 1, Topics 1-2 (Basic dimensions)
-- Purpose: Create base dimension tables for SSAS cube training
-- ========================================================================

USE master;
GO

-- Drop database if it exists (for clean reinstall)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AssmangMining')
BEGIN
    ALTER DATABASE AssmangMining SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AssmangMining;
END
GO

-- Create database
CREATE DATABASE AssmangMining;
GO

USE AssmangMining;
GO

-- ========================================================================
-- DIMENSION: Mines
-- ========================================================================
CREATE TABLE Dim_Mine (
    MineID INT PRIMARY KEY IDENTITY(1,1),
    MineName NVARCHAR(100) NOT NULL,
    MineCode NVARCHAR(10) NOT NULL UNIQUE,
    MineType NVARCHAR(50) NOT NULL,  -- Iron Ore, Manganese, Chrome
    Province NVARCHAR(50) NOT NULL,   -- Northern Cape, Limpopo, Mpumalanga
    EstablishedYear INT,
    CurrentlyOperational BIT DEFAULT 1,
    OperatingManager NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Dim_Mine (MineName, MineCode, MineType, Province, EstablishedYear, CurrentlyOperational, OperatingManager)
VALUES
    ('Beeshoek Mine', 'BEESH', 'Iron Ore', 'Northern Cape', 1924, 1, 'Thabo Mthembu'),
    ('Khumani Mine', 'KHUMAN', 'Iron Ore', 'Northern Cape', 2007, 1, 'Johan Wessels'),
    ('Black Rock Mine', 'BLKRCK', 'Manganese', 'Northern Cape', 1970, 1, 'Reginald Mthiyane'),
    ('Dwarsrivier Chrome Mine', 'DWRSVR', 'Chrome', 'Limpopo', 1921, 1, 'Pieter van der Merwe'),
    ('Machadodorp Works', 'MACHAD', 'Chrome', 'Mpumalanga', 1954, 1, 'Samuel Dlamini');

GO

-- ========================================================================
-- DIMENSION: Department
-- ========================================================================
CREATE TABLE Dim_Department (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    DepartmentCode NVARCHAR(10) NOT NULL UNIQUE,
    FunctionArea NVARCHAR(50),  -- Mining Operations, Engineering, HR, Finance, Safety
    BudgetZAR DECIMAL(15,2),
    ManagerName NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Dim_Department (DepartmentName, DepartmentCode, FunctionArea, BudgetZAR, ManagerName)
VALUES
    ('Mining Operations', 'MINEOPS', 'Mining Operations', 45000000.00, 'Sizwe Nkosi'),
    ('Engineering & Maintenance', 'ENGMAINT', 'Engineering', 35000000.00, 'Dr. Kabelo Molefe'),
    ('Human Resources', 'HUMANRES', 'HR', 8000000.00, 'Naledi Sithole'),
    ('Safety & Compliance', 'SAFETY', 'Safety', 12000000.00, 'Lerato Goveia'),
    ('Finance & Accounting', 'FINANCE', 'Finance', 10000000.00, 'Trevor Williams'),
    ('Corporate Affairs', 'CORPAFFRS', 'Corporate', 5000000.00, 'Dianne Marks');

GO

-- ========================================================================
-- DIMENSION: Employee
-- ========================================================================
CREATE TABLE Dim_Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(70) NOT NULL,
    LastName NVARCHAR(70) NOT NULL,
    EmployeeCode NVARCHAR(20) NOT NULL UNIQUE,
    JobTitle NVARCHAR(100),
    DepartmentID INT FOREIGN KEY REFERENCES Dim_Department(DepartmentID),
    MineID INT FOREIGN KEY REFERENCES Dim_Mine(MineID),
    SalaryZAR DECIMAL(10,2),
    HireDate DATE,
    IsActive BIT DEFAULT 1,
    Email NVARCHAR(150),
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Dim_Employee (FirstName, LastName, EmployeeCode, JobTitle, DepartmentID, MineID, SalaryZAR, HireDate, IsActive, Email)
VALUES
    ('Sizwe', 'Nkosi', 'EMP001', 'General Manager - Operations', 1, 1, 185000.00, '2005-03-15', 1, 'sizwe.nkosi@assmang.co.za'),
    ('Kabelo', 'Molefe', 'EMP002', 'Chief Engineer', 2, 1, 165000.00, '2008-07-20', 1, 'kabelo.molefe@assmang.co.za'),
    ('Thabo', 'Mthembu', 'EMP003', 'Mine Manager - Beeshoek', 1, 1, 145000.00, '2010-01-10', 1, 'thabo.mthembu@assmang.co.za'),
    ('Johan', 'Wessels', 'EMP004', 'Mine Manager - Khumani', 1, 2, 145000.00, '2009-11-05', 1, 'johan.wessels@assmang.co.za'),
    ('Reginald', 'Mthiyane', 'EMP005', 'Mine Manager - Black Rock', 1, 3, 145000.00, '2011-06-15', 1, 'reginald.mthiyane@assmang.co.za'),
    ('Pieter', 'van der Merwe', 'EMP006', 'Mine Manager - Dwarsrivier', 1, 4, 142000.00, '2007-02-01', 1, 'pieter.vandermerwe@assmang.co.za'),
    ('Samuel', 'Dlamini', 'EMP007', 'Works Manager - Machadodorp', 1, 5, 135000.00, '2012-09-10', 1, 'samuel.dlamini@assmang.co.za'),
    ('Naledi', 'Sithole', 'EMP008', 'HR Business Partner', 3, NULL, 95000.00, '2014-04-01', 1, 'naledi.sithole@assmang.co.za'),
    ('Lerato', 'Goveia', 'EMP009', 'Health & Safety Manager', 4, NULL, 110000.00, '2013-05-15', 1, 'lerato.goveia@assmang.co.za'),
    ('Trevor', 'Williams', 'EMP010', 'Finance Manager', 5, NULL, 115000.00, '2015-01-20', 1, 'trevor.williams@assmang.co.za'),

    -- Additional operational staff
    ('Blessing', 'Madondo', 'EMP011', 'Production Supervisor', 1, 1, 65000.00, '2016-03-10', 1, 'blessing.madondo@assmang.co.za'),
    ('Zanele', 'Khumalo', 'EMP012', 'Safety Officer', 4, 1, 58000.00, '2017-02-01', 1, 'zanele.khumalo@assmang.co.za'),
    ('Themba', 'Zungu', 'EMP013', 'Equipment Operator', 1, 2, 52000.00, '2018-07-15', 1, 'themba.zungu@assmang.co.za'),
    ('Zanele', 'Mkhize', 'EMP014', 'HR Officer', 3, NULL, 52000.00, '2019-01-10', 1, 'zanele.mkhize@assmang.co.za'),
    ('Mpho', 'Modise', 'EMP015', 'Finance Specialist', 5, NULL, 68000.00, '2018-06-15', 1, 'mpho.modise@assmang.co.za'),

    -- Engineering and maintenance team
    ('David', 'Okafor', 'EMP016', 'Senior Engineer', 2, 1, 125000.00, '2009-09-01', 1, 'david.okafor@assmang.co.za'),
    ('Pule', 'Ramoeba', 'EMP017', 'Maintenance Supervisor', 2, 2, 72000.00, '2016-04-20', 1, 'pule.ramoeba@assmang.co.za'),
    ('Ashok', 'Patel', 'EMP018', 'Technical Specialist', 2, 3, 98000.00, '2014-11-05', 1, 'ashok.patel@assmang.co.za');

GO

-- ========================================================================
-- DIMENSION: Date (Calendar)
-- ========================================================================
CREATE TABLE Dim_Date (
    DateID INT PRIMARY KEY,  -- Format: YYYYMMDD (e.g., 20230115)
    FullDate DATE NOT NULL UNIQUE,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName NVARCHAR(15),
    Day INT,
    DayOfWeek INT,
    DayName NVARCHAR(10),
    WeekOfYear INT,
    IsWeekday BIT
);

-- Populate date dimension (2023-2024 for training)
DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2024-12-31';
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (DateID, FullDate, Year, Quarter, Month, MonthName, Day, DayOfWeek, DayName, WeekOfYear, IsWeekday)
    SELECT
        CAST(CONVERT(CHAR(8), @CurrentDate, 112) AS INT),
        @CurrentDate,
        YEAR(@CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DAY(@CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEK, @CurrentDate),
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) NOT IN (1, 7) THEN 1 ELSE 0 END;

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END

GO

-- ========================================================================
-- Summary of v1 Tables
-- ========================================================================
-- Tables created:
--   1. Dim_Mine (5 mines)
--   2. Dim_Department (6 departments)
--   3. Dim_Employee (18 employees)
--   4. Dim_Date (730 days: Jan 2023 - Dec 2024)
--
-- Total rows: 759
-- Ready for: Basic dimensional analysis in SSAS
-- Next version: Will add Fact tables (Production, Costs)
-- ========================================================================

DECLARE @DimMineCount INT;
DECLARE @DimDepartmentCount INT;
DECLARE @DimEmployeeCount INT;
DECLARE @DimDateCount INT;

SELECT @DimMineCount = COUNT(*) FROM Dim_Mine;
SELECT @DimDepartmentCount = COUNT(*) FROM Dim_Department;
SELECT @DimEmployeeCount = COUNT(*) FROM Dim_Employee;
SELECT @DimDateCount = COUNT(*) FROM Dim_Date;

PRINT 'v1 ASSMANG MINING DATABASE CREATED SUCCESSFULLY';
PRINT '- Dim_Mine: ' + CAST(@DimMineCount AS NVARCHAR(10)) + ' records';
PRINT '- Dim_Department: ' + CAST(@DimDepartmentCount AS NVARCHAR(10)) + ' records';
PRINT '- Dim_Employee: ' + CAST(@DimEmployeeCount AS NVARCHAR(10)) + ' records';
PRINT '- Dim_Date: ' + CAST(@DimDateCount AS NVARCHAR(10)) + ' records';
PRINT '';
PRINT 'Ready for Day 1, Topics 1-2 (Basic Dimensions and Initial Cube Build)';

GO

