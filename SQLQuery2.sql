use Hospital
/* ============================================================
   HOSPITAL DATABASE - QUESTIONS 1 TO 46
   ============================================================ */


/* ============================================================
   QUESTION 1
   Count Patients per Ward
   ============================================================ */

SELECT
    WardID,
    COUNT(*) AS PatientCount
FROM PATIENT
GROUP BY WardID;


/* ============================================================
   QUESTION 2
   Calculate the Average Consultant Salary
   ============================================================ */

SELECT
    AVG(Salary) AS AverageSalary
FROM CONSULTANT;


/* ============================================================
   QUESTION 3
   Display Salary Statistics for Consultants
   ============================================================ */

SELECT
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary,
    AVG(Salary) AS AverageSalary,
    SUM(Salary) AS TotalSalary
FROM CONSULTANT;


/* ============================================================
   QUESTION 4
   Count Patients by Ward
   ============================================================ */

SELECT
    WardID,
    COUNT(*) AS PatientCount
FROM PATIENT
GROUP BY WardID
ORDER BY PatientCount DESC;


/* ============================================================
   QUESTION 5
   Medication Quantity per Patient
   ============================================================ */

SELECT
    PatientID,
    SUM(Quantity) AS TotalMedicationQuantity
FROM MEDICATION_ADMINISTRATION
GROUP BY PatientID;


/* ============================================================
   QUESTION 6
   Medication Administrations per Patient
   ============================================================ */

SELECT
    PatientID,
    COUNT(*) AS AdministrationCount
FROM MEDICATION_ADMINISTRATION
GROUP BY PatientID;


/* ============================================================
   QUESTION 7
   Patients per Ward with Ward Names
   ============================================================ */

SELECT
    W.WardID,
    W.WardName,
    COUNT(P.PatientID) AS PatientCount
FROM WARD W
LEFT JOIN PATIENT P
    ON W.WardID = P.WardID
GROUP BY
    W.WardID,
    W.WardName;


/* ============================================================
   QUESTION 8
   Average Nurse Salary per Ward
   ============================================================ */

SELECT
    W.WardID,
    W.WardName,
    AVG(N.Salary) AS AverageNurseSalary
FROM WARD W
LEFT JOIN NURSE N
    ON W.WardID = N.WardID
GROUP BY
    W.WardID,
    W.WardName;


/* ============================================================
   QUESTION 9
   Wards with More Than 3 Patients
   ============================================================ */

SELECT
    WardID,
    COUNT(*) AS PatientCount
FROM PATIENT
GROUP BY WardID
HAVING COUNT(*) > 3;


/* ============================================================
   QUESTION 10
   Patients with More Than 5 Medication Administrations
   ============================================================ */

SELECT
    PatientID,
    COUNT(*) AS AdministrationCount
FROM MEDICATION_ADMINISTRATION
GROUP BY PatientID
HAVING COUNT(*) > 5;


/* ============================================================
   QUESTION 11
   Consultants Above Average Salary
   ============================================================ */

SELECT *
FROM CONSULTANT
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM CONSULTANT
);


/* ============================================================
   QUESTION 12
   Nurses Above Average Salary
   ============================================================ */

SELECT *
FROM NURSE
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM NURSE
);


/* ============================================================
   QUESTION 13
   Patients in the Largest Ward
   ============================================================ */

SELECT *
FROM PATIENT
WHERE WardID IN
(
    SELECT WardID
    FROM PATIENT
    GROUP BY WardID
    HAVING COUNT(*) =
    (
        SELECT MAX(PatientCount)
        FROM
        (
            SELECT
                WardID,
                COUNT(*) AS PatientCount
            FROM PATIENT
            GROUP BY WardID
        ) AS WardCounts
    )
);


/* ============================================================
   QUESTION 14
   Consultants with the Maximum Salary
   ============================================================ */

SELECT *
FROM CONSULTANT
WHERE Salary =
(
    SELECT MAX(Salary)
    FROM CONSULTANT
);


/* ============================================================
   QUESTION 15
   Patients Who Received Medication
   ============================================================ */

SELECT DISTINCT
    P.*
FROM PATIENT P
INNER JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID;


/* ============================================================
   QUESTION 16
   Patients Who Never Received Medication
   ============================================================ */

SELECT
    P.*
FROM PATIENT P
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
WHERE M.PatientID IS NULL;


/* ============================================================
   QUESTION 17
   Count Medication Administrations per Patient
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    COUNT(M.PatientID) AS AdministrationCount
FROM PATIENT P
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName;


/* ============================================================
   QUESTION 18
   Total Medication Quantity per Patient
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    COALESCE(SUM(M.Quantity), 0) AS TotalQuantity
FROM PATIENT P
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName;


/* ============================================================
   QUESTION 19
   Derived Table for Consultant Salaries
   ============================================================ */

SELECT
    C.*
FROM CONSULTANT C
CROSS JOIN
(
    SELECT
        AVG(Salary) AS AverageSalary
    FROM CONSULTANT
) AS AvgSalary
WHERE C.Salary > AvgSalary.AverageSalary;


/* ============================================================
   QUESTION 20
   Patients with Above-Average Medication Quantity
   ============================================================ */

SELECT
    PatientID,
    SUM(Quantity) AS TotalQuantity
FROM MEDICATION_ADMINISTRATION
GROUP BY PatientID
HAVING SUM(Quantity) >
(
    SELECT AVG(TotalQuantity)
    FROM
    (
        SELECT
            PatientID,
            SUM(Quantity) AS TotalQuantity
        FROM MEDICATION_ADMINISTRATION
        GROUP BY PatientID
    ) AS PatientMedicationTotals
);


/* ============================================================
   QUESTION 21
   Create a Patient Backup
   ============================================================ */

SELECT *
INTO PatientBackup
FROM PATIENT;


/* ============================================================
   QUESTION 22
   Create a Basic Patient Information Table
   ============================================================ */

SELECT
    PatientID,
    PatientName,
    DateOfBirth
INTO BasicPatientInformation
FROM PATIENT;


/* ============================================================
   QUESTION 23
   Create a Consultant Salary Report
   ============================================================ */

SELECT
    ConsultantID,
    ConsultantName,
    Salary
INTO ConsultantSalaryReport
FROM CONSULTANT;


/* ============================================================
   QUESTION 24
   Create a Patient-Ward Report
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    W.WardID,
    W.WardName
INTO PatientWardReport
FROM PATIENT P
INNER JOIN WARD W
    ON P.WardID = W.WardID;


/* ============================================================
   QUESTION 25
   Create a Patient-Consultant Report
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    C.ConsultantID,
    C.ConsultantName
INTO PatientConsultantReport
FROM PATIENT P
INNER JOIN CONSULTANT C
    ON P.ConsultantID = C.ConsultantID;


/* ============================================================
   QUESTION 26
   Create a High-Salary Consultant Table
   ============================================================ */

SELECT *
INTO HighSalaryConsultants
FROM CONSULTANT
WHERE Salary > 50000;


/* ============================================================
   QUESTION 27
   Create a Young Patients Table
   ============================================================ */

SELECT *
INTO YoungPatients
FROM PATIENT
WHERE DateOfBirth > '2000-01-01';


/* ============================================================
   QUESTION 28
   Create a High-Salary Nurse Report
   ============================================================ */

SELECT
    N.NurseID,
    N.NurseName,
    N.Salary,
    W.WardID,
    W.WardName
INTO HighSalaryNurseReport
FROM NURSE N
INNER JOIN WARD W
    ON N.WardID = W.WardID
WHERE N.Salary > 30000;


/* ============================================================
   QUESTION 29
   Create a Ward Patient Summary
   ============================================================ */

SELECT
    W.WardID,
    W.WardName,
    COUNT(P.PatientID) AS PatientCount
INTO WardPatientSummary
FROM WARD W
LEFT JOIN PATIENT P
    ON W.WardID = P.WardID
GROUP BY
    W.WardID,
    W.WardName;


/* ============================================================
   QUESTION 30
   Create a Patient Medication Summary
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    COALESCE(SUM(M.Quantity), 0) AS TotalMedicationQuantity
INTO PatientMedicationSummary
FROM PATIENT P
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName;


/* ============================================================
   QUESTION 31
   Calculate Patient Age
   ============================================================ */

GO
CREATE FUNCTION dbo.CalculatePatientAge
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN

    DECLARE @Age INT;

    SET @Age =
        DATEDIFF(YEAR, @DateOfBirth, GETDATE())
        -
        CASE
            WHEN DATEADD
            (
                YEAR,
                DATEDIFF(YEAR, @DateOfBirth, GETDATE()),
                @DateOfBirth
            ) > GETDATE()
            THEN 1
            ELSE 0
        END;

    RETURN @Age;

END;

GO
/* ============================================================
   QUESTION 32
   Calculate Annual Salary
   ============================================================ */

CREATE FUNCTION dbo.CalculateAnnualSalary
(
    @MonthlySalary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    RETURN @MonthlySalary * 12;

END;

GO
/* ============================================================
   QUESTION 33
   Calculate Medication Cost
   ============================================================ */

CREATE FUNCTION dbo.CalculateMedicationCost
(
    @Quantity INT,
    @UnitPrice DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    RETURN @Quantity * @UnitPrice;

END;

GO
/* ============================================================
   QUESTION 34
   Get Patients by Ward
   ============================================================ */

CREATE FUNCTION dbo.GetPatientsByWard
(
    @WardID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM PATIENT
    WHERE WardID = @WardID
);

GO
/* ============================================================
   QUESTION 35
   Get Consultants by Minimum Salary
   ============================================================ */

CREATE FUNCTION dbo.GetConsultantsByMinimumSalary
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM CONSULTANT
    WHERE Salary >= @MinimumSalary
);

GO
/* ============================================================
   QUESTION 36
   Get Patients with Their Ward
   ============================================================ */

CREATE FUNCTION dbo.GetPatientsWithTheirWard
(
    @WardID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.PatientID,
        P.PatientName,
        P.DateOfBirth,
        W.WardID,
        W.WardName
    FROM PATIENT P
    INNER JOIN WARD W
        ON P.WardID = W.WardID
    WHERE W.WardID = @WardID
);

GO
/* ============================================================
   QUESTION 37
   Get Patients Above a Specific Age
   ============================================================ */

CREATE FUNCTION dbo.GetPatientsWithAge
(
    @MinimumAge INT
)
RETURNS @Result TABLE
(
    PatientID INT,
    PatientName VARCHAR(100),
    DateOfBirth DATE,
    Age INT
)
AS
BEGIN

    INSERT INTO @Result
    SELECT
        PatientID,
        PatientName,
        DateOfBirth,
        dbo.CalculatePatientAge(DateOfBirth)
    FROM PATIENT
    WHERE dbo.CalculatePatientAge(DateOfBirth) >= @MinimumAge;

    RETURN;

END;

GO
/* ============================================================
   QUESTION 38
   Get Patient Medication Summary
   ============================================================ */

CREATE FUNCTION dbo.GetPatientMedicationSummary
(
    @PatientID INT
)
RETURNS @Result TABLE
(
    PatientID INT,
    TotalMedicationQuantity INT,
    AdministrationCount INT
)
AS
BEGIN

    INSERT INTO @Result
    SELECT
        @PatientID,
        COALESCE(SUM(Quantity), 0),
        COUNT(*)
    FROM MEDICATION_ADMINISTRATION
    WHERE PatientID = @PatientID;

    RETURN;

END;

GO
/* ============================================================
   QUESTION 39
   Classify Consultant Salaries
   ============================================================ */

CREATE FUNCTION dbo.ClassifyConsultantSalaries
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS @Result TABLE
(
    ConsultantID INT,
    ConsultantName VARCHAR(100),
    Salary DECIMAL(10,2),
    SalaryClassification VARCHAR(20)
)
AS
BEGIN

    INSERT INTO @Result
    SELECT
        ConsultantID,
        ConsultantName,
        Salary,
        CASE
            WHEN Salary >= 70000 THEN 'High'
            WHEN Salary >= 50000 THEN 'Medium'
            ELSE 'Low'
        END
    FROM CONSULTANT
    WHERE Salary >= @MinimumSalary;

    RETURN;

END;

GO

/* ============================================================
   QUESTION 40
   Patient Medication Statistics
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    COUNT(M.PatientID) AS AdministrationCount,
    COALESCE(SUM(M.Quantity), 0) AS TotalQuantity,
    COALESCE
    (
        AVG(CAST(M.Quantity AS DECIMAL(10,2))),
        0
    ) AS AverageQuantity
FROM PATIENT P
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName;


/* ============================================================
   QUESTION 41
   Above-Average Wards
   ============================================================ */

SELECT
    W.WardID,
    W.WardName,
    COUNT(P.PatientID) AS PatientCount
FROM WARD W
LEFT JOIN PATIENT P
    ON W.WardID = P.WardID
GROUP BY
    W.WardID,
    W.WardName
HAVING COUNT(P.PatientID) >
(
    SELECT AVG(PatientCount)
    FROM
    (
        SELECT
            W2.WardID,
            COUNT(P2.PatientID) AS PatientCount
        FROM WARD W2
        LEFT JOIN PATIENT P2
            ON W2.WardID = P2.WardID
        GROUP BY W2.WardID
    ) AS WardStatistics
);


/* ============================================================
   QUESTION 42
   Create a High-Activity Patient Report
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    COUNT(M.PatientID) AS AdministrationCount
INTO HighActivityPatientReport
FROM PATIENT P
INNER JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName
HAVING COUNT(M.PatientID) > 5;


/* ============================================================
   QUESTION 43
   Create a Consultant Salary Report Using Scalar Function
   ============================================================ */

SELECT
    ConsultantID,
    ConsultantName,
    Salary AS MonthlySalary,
    dbo.CalculateAnnualSalary(Salary) AS AnnualSalary
INTO ConsultantAnnualSalaryReport
FROM CONSULTANT;


/* ============================================================
   QUESTION 44
   Use an Inline TVF with a Filter
   ============================================================ */

SELECT *
FROM dbo.GetConsultantsByMinimumSalary(50000)
WHERE ConsultantName LIKE 'A%';


/* ============================================================
   QUESTION 45
   Use a Multi-Statement TVF
   ============================================================ */

SELECT *
FROM dbo.GetPatientsWithAge(30)
ORDER BY Age DESC;


/* ============================================================
   QUESTION 46
   Final Hospital Patient Summary
   ============================================================ */

SELECT
    P.PatientID,
    P.PatientName,
    W.WardName,
    dbo.CalculatePatientAge(P.DateOfBirth) AS PatientAge,
    COUNT(M.PatientID) AS MedicationAdministrations,
    COALESCE(SUM(M.Quantity), 0) AS TotalMedicationQuantity
FROM PATIENT P
INNER JOIN WARD W
    ON P.WardID = W.WardID
LEFT JOIN MEDICATION_ADMINISTRATION M
    ON P.PatientID = M.PatientID
GROUP BY
    P.PatientID,
    P.PatientName,
    W.WardName,
    P.DateOfBirth
ORDER BY
    P.PatientID;