USE InsigniaDW;
GO

CREATE PROCEDURE LoadEmployeeDimension
AS
BEGIN
    DECLARE @Load_Start_Datetime DATETIME = GETDATE();
    
    -- Insert new records
    INSERT INTO EmployeeDimension (Employee_Id, EmployeeFirstName, EmployeeLastName, Is_Salesperson, ValidFrom, ValidTo, IsCurrent, Lineage_Id)
    SELECT DISTINCT Employee_Id, EmployeeFirstName, EmployeeLastName, Is_Salesperson, @Load_Start_Datetime, '9999-12-31', 1, (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    WHERE NOT EXISTS (
        SELECT 1 FROM EmployeeDimension ed
        WHERE ed.Employee_Id = isc.Employee_Id AND ed.IsCurrent = 1
    );

    -- Update existing records
    UPDATE ed
    SET ed.ValidTo = @Load_Start_Datetime, ed.IsCurrent = 0
    FROM EmployeeDimension ed
    JOIN Insignia_staging_copy isc
    ON ed.Employee_Id = isc.Employee_Id
    WHERE ed.IsCurrent = 1
    AND (
        ed.EmployeeFirstName != isc.EmployeeFirstName
        OR ed.EmployeeLastName != isc.EmployeeLastName
        OR ed.Is_Salesperson != isc.Is_Salesperson
    );

    -- Insert new records for updated employees
    INSERT INTO EmployeeDimension (Employee_Id, EmployeeFirstName, EmployeeLastName, Is_Salesperson, ValidFrom, ValidTo, IsCurrent, Lineage_Id)
    SELECT DISTINCT Employee_Id, EmployeeFirstName, EmployeeLastName, Is_Salesperson, @Load_Start_Datetime, '9999-12-31', 1, (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    WHERE EXISTS (
        SELECT 1 FROM EmployeeDimension ed
        WHERE ed.Employee_Id = isc.Employee_Id AND ed.ValidTo = @Load_Start_Datetime
    );
END;
GO
