USE InsigniaDW;
GO

CREATE PROCEDURE LoadCustomerDimension
AS
BEGIN
    DECLARE @Load_Start_Datetime DATETIME = GETDATE();
    
    -- Insert new records
    INSERT INTO CustomerDimension (Customer_Id, CustomerName, CustomerCategory, CustomerContactName, CustomerPostalCode, CustomerContactNumber, ValidFrom, ValidTo, IsCurrent, Lineage_Id)
    SELECT DISTINCT Customer_Id, CustomerName, CustomerCategory, CustomerContactName, CustomerPostalCode, CustomerContactNumber, @Load_Start_Datetime, '9999-12-31', 1, (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    WHERE NOT EXISTS (
        SELECT 1 FROM CustomerDimension cd
        WHERE cd.Customer_Id = isc.Customer_Id AND cd.IsCurrent = 1
    );

    -- Update existing records
    UPDATE cd
    SET cd.ValidTo = @Load_Start_Datetime, cd.IsCurrent = 0
    FROM CustomerDimension cd
    JOIN Insignia_staging_copy isc
    ON cd.Customer_Id = isc.Customer_Id
    WHERE cd.IsCurrent = 1
    AND (
        cd.CustomerName != isc.CustomerName
        OR cd.CustomerCategory != isc.CustomerCategory
        OR cd.CustomerContactName != isc.CustomerContactName
        OR cd.CustomerPostalCode != isc.CustomerPostalCode
        OR cd.CustomerContactNumber != isc.CustomerContactNumber
    );

    -- Insert new records for updated customers
    INSERT INTO CustomerDimension (Customer_Id, CustomerName, CustomerCategory, CustomerContactName, CustomerPostalCode, CustomerContactNumber, ValidFrom, ValidTo, IsCurrent, Lineage_Id)
    SELECT DISTINCT Customer_Id, CustomerName, CustomerCategory, CustomerContactName, CustomerPostalCode, CustomerContactNumber, @Load_Start_Datetime, '9999-12-31', 1, (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    WHERE EXISTS (
        SELECT 1 FROM CustomerDimension cd
        WHERE cd.Customer_Id = isc.Customer_Id AND cd.ValidTo = @Load_Start_Datetime
    );
END;
GO
