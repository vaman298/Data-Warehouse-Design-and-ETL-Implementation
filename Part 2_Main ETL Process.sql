USE InsigniaDW;
GO

-- Main ETL Process
CREATE PROCEDURE ETL_Process
AS
BEGIN
    DECLARE @Load_Start_Datetime DATETIME = GETDATE();
    DECLARE @Load_EndDatetime DATETIME;
    DECLARE @Rows_at_Source INT;
    DECLARE @Rows_at_Destination INT;
    DECLARE @Lineage_Id INT;

    -- Start ETL Load
    INSERT INTO Lineage (Source_System, Load_Stat_Datetime, Load_EndDatetime, Rows_at_Source, Rows_at_destination_Fact, Load_Status)
    VALUES ('Insignia_Staging', @Load_Start_Datetime, NULL, 0, 0, 0);

    SET @Lineage_Id = SCOPE_IDENTITY();

    -- Truncate staging copy table
    TRUNCATE TABLE Insignia_staging_copy;

    -- Insert incremental data into staging copy
    INSERT INTO Insignia_staging_copy
    SELECT * FROM Insignia_incremental;

    -- Load data into dimensions
    EXEC LoadEmployeeDimension;
    EXEC LoadCustomerDimension;
    EXEC LoadGeographyDimension;
    EXEC LoadStockItemDimension;

    -- Load data into fact table
    EXEC LoadFactTable;

    -- Update the lineage table with load status
    SET @Load_EndDatetime = GETDATE();
    SET @Rows_at_Source = (SELECT COUNT(*) FROM Insignia_incremental);
    SET @Rows_at_Destination = (SELECT COUNT(*) FROM SalesFact WHERE Lineage_Id = @Lineage_Id);

    UPDATE Lineage
    SET Load_EndDatetime = @Load_EndDatetime,
        Rows_at_Source = @Rows_at_Source,
        Rows_at_destination_Fact = @Rows_at_Destination,
        Load_Status = 1
    WHERE Lineage_Id = @Lineage_Id;
END;
GO
