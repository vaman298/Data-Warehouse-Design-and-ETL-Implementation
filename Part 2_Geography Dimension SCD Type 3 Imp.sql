USE InsigniaDW;
GO

CREATE PROCEDURE LoadGeographyDimension
AS
BEGIN
    DECLARE @Load_Start_Datetime DATETIME = GETDATE();
    
    -- Insert new records
    INSERT INTO GeographyDimension (City_ID, City, State_Province, Country, Continent, Sales_Territory, Region, Subregion, Latest_Recorded_Population, Previous_Population, Lineage_Id)
    SELECT DISTINCT City_ID, City, State_Province, Country, Continent, Sales_Territory, Region, Subregion, Latest_Recorded_Population, NULL, (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    WHERE NOT EXISTS (
        SELECT 1 FROM GeographyDimension gd
        WHERE gd.City_ID = isc.City_ID
    );

    -- Update existing records
    UPDATE gd
    SET gd.Previous_Population = gd.Latest_Recorded_Population,
        gd.Latest_Recorded_Population = isc.Latest_Recorded_Population
    FROM GeographyDimension gd
    JOIN Insignia_staging_copy isc
    ON gd.City_ID = isc.City_ID
    WHERE gd.Latest_Recorded_Population != isc.Latest_Recorded_Population;
END;
GO
