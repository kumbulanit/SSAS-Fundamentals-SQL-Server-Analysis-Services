-- ========================================================================
-- v3_assmang_mining_complete.sql
-- ========================================================================
-- Assmang Pty Ltd: Mining Operations Database (Version 3 - Complete)
-- Used in: Day 2, Topics 5-8 (Advanced analysis, KPIs, Optimization)
-- Purpose: Add KPI and advanced analytical fact tables
-- ========================================================================

USE AssmangMining;
GO

-- ========================================================================
-- FACT TABLE: Equipment Efficiency
-- ========================================================================
CREATE TABLE FactEquipmentEfficiency (
    EfficiencyID INT PRIMARY KEY IDENTITY(1,1),
    MineID INT NOT NULL FOREIGN KEY REFERENCES Dim_Mine(MineID),
    DateID INT NOT NULL FOREIGN KEY REFERENCES Dim_Date(DateID),
    EquipmentName NVARCHAR(100),
    EquipmentType NVARCHAR(50),  -- Excavator, Truck, Drill, etc.
    UpTimePercentage DECIMAL(5,2),  -- 0-100%
    DownTimeMinutes INT,
    MaintenanceEvents INT,
    SafetyIncidents INT,
    ProductivityTonnesPerHour DECIMAL(10,2),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Sample equipment efficiency data for cubes
INSERT INTO FactEquipmentEfficiency (MineID, DateID, EquipmentName, EquipmentType, UpTimePercentage, DownTimeMinutes, MaintenanceEvents, SafetyIncidents, ProductivityTonnesPerHour)
VALUES
    (1, 20230131, 'Excavator-B1', 'Excavator', 92.50, 450, 2, 0, 85.30),
    (1, 20230131, 'Truck-T5', 'Haul Truck', 88.75, 720, 1, 1, 72.15),
    (1, 20230131, 'Drill-D2', 'Blast Hole Drill', 95.20, 280, 1, 0, 52.80),
    (2, 20230131, 'Excavator-H1', 'Excavator', 91.30, 500, 2, 0, 92.45),
    (2, 20230131, 'Truck-T12', 'Haul Truck', 89.60, 600, 2, 0, 78.20),
    (3, 20230131, 'Excavator-M3', 'Excavator', 93.80, 370, 1, 0, 65.50),
    (4, 20230131, 'Truck-T8', 'Haul Truck', 87.40, 750, 3, 1, 68.30),
    (5, 20230131, 'Crusher-C1', 'Ore Crusher', 96.10, 235, 1, 0, 125.70);

GO

-- ========================================================================
-- FACT TABLE: Safety & Compliance KPIs
-- ========================================================================
CREATE TABLE FactSafetyKPI (
    SafetyKPIID INT PRIMARY KEY IDENTITY(1,1),
    MineID INT NOT NULL FOREIGN KEY REFERENCES Dim_Mine(MineID),
    DateID INT NOT NULL FOREIGN KEY REFERENCES Dim_Date(DateID),
    LostTimeInjuries INT,
    TotalRecordableIncidents INT,
    Nearmisses INT,
    DaysWithoutIncident INT,
    EnvironmentalIncidents INT,
    ComplianceScore DECIMAL(5,2),  -- 0-100
    TrainingHoursDelivered INT,
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO FactSafetyKPI (MineID, DateID, LostTimeInjuries, TotalRecordableIncidents, Nearmisses, DaysWithoutIncident, EnvironmentalIncidents, ComplianceScore, TrainingHoursDelivered)
VALUES
    (1, 20230131, 0, 2, 15, 28, 0, 98.50, 450),
    (1, 20230228, 0, 1, 12, 56, 0, 99.00, 380),
    (2, 20230131, 1, 3, 18, 15, 1, 97.20, 520),
    (2, 20230228, 0, 2, 14, 31, 0, 98.80, 410),
    (3, 20230131, 0, 1, 10, 42, 0, 98.90, 340),
    (3, 20230228, 0, 2, 13, 28, 0, 98.30, 390),
    (4, 20230131, 1, 4, 20, 8, 2, 96.70, 580),
    (4, 20230228, 0, 3, 16, 25, 1, 97.50, 450),
    (5, 20230131, 0, 1, 12, 35, 0, 99.10, 320),
    (5, 20230228, 0, 2, 14, 28, 0, 98.70, 360);

GO

-- ========================================================================
-- FACT TABLE: Employee & HR Metrics
-- ========================================================================
CREATE TABLE FactEmployeeMetrics (
    MetricsID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Dim_Employee(EmployeeID),
    DateID INT NOT NULL FOREIGN KEY REFERENCES Dim_Date(DateID),
    AttendancePercentage DECIMAL(5,2),
    OvertimeHours DECIMAL(8,2),
    TrainingHoursCompleted INT,
    PerformanceRating DECIMAL(3,1),  -- 1.0 to 5.0
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO FactEmployeeMetrics (EmployeeID, DateID, AttendancePercentage, OvertimeHours, TrainingHoursCompleted, PerformanceRating)
VALUES
    (1, 20230131, 98.50, 12.5, 8, 4.8),
    (1, 20230228, 99.00, 8.0, 6, 4.9),
    (2, 20230131, 97.50, 15.5, 10, 4.7),
    (3, 20230131, 98.00, 10.0, 12, 4.6),
    (4, 20230131, 96.50, 20.0, 15, 4.5),
    (5, 20230131, 98.75, 6.5, 8, 4.7),
    (11, 20230131, 95.50, 25.0, 6, 4.2),
    (12, 20230131, 97.00, 12.0, 16, 4.4),
    (13, 20230131, 96.25, 18.5, 4, 4.1),
    (14, 20230131, 99.25, 2.0, 20, 4.8),
    (15, 20230131, 98.50, 8.5, 10, 4.6);

GO

-- ========================================================================
-- Summary: v3 Complete Database
-- ========================================================================
PRINT 'v3 ASSMANG MINING DATABASE COMPLETED SUCCESSFULLY';
PRINT '';
PRINT 'BASE DIMENSIONS:';
PRINT '- Dim_Mine: ' + CAST((SELECT COUNT(*) FROM Dim_Mine) AS NVARCHAR(10)) + ' mines';
PRINT '- Dim_Department: ' + CAST((SELECT COUNT(*) FROM Dim_Department) AS NVARCHAR(10)) + ' departments';
PRINT '- Dim_Employee: ' + CAST((SELECT COUNT(*) FROM Dim_Employee) AS NVARCHAR(10)) + ' employees';
PRINT '- Dim_Date: ' + CAST((SELECT COUNT(*) FROM Dim_Date) AS NVARCHAR(10)) + ' dates (2023-2024)';
PRINT '';
PRINT 'FACT TABLES:';
PRINT '- FactProduction: ' + CAST((SELECT COUNT(*) FROM FactProduction) AS NVARCHAR(10)) + ' records (monthly)';
PRINT '- FactOperatingCosts: ' + CAST((SELECT COUNT(*) FROM FactOperatingCosts) AS NVARCHAR(10)) + ' records (costs)';
PRINT '- FactEquipmentEfficiency: ' + CAST((SELECT COUNT(*) FROM FactEquipmentEfficiency) AS NVARCHAR(10)) + ' records';
PRINT '- FactSafetyKPI: ' + CAST((SELECT COUNT(*) FROM FactSafetyKPI) AS NVARCHAR(10)) + ' records';
PRINT '- FactEmployeeMetrics: ' + CAST((SELECT COUNT(*) FROM FactEmployeeMetrics) AS NVARCHAR(10)) + ' records';
PRINT '';
PRINT 'Database ready for complete SSAS cube development (Day 1-2 full curriculum)';

GO

