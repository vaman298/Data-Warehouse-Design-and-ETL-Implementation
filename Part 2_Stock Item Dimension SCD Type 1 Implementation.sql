USE InsigniaDW;
GO

CREATE PROCEDURE LoadStockItemDimension
AS
BEGIN
    -- Insert or update records
    MERGE StockItemDimension AS target
    USING (SELECT DISTINCT Stock_Item_Id, Stock_Item_Name, Stock_ItemColor, Stock_Item_Size, Item_Size, Stock_ItemPrice, (SELECT MAX(Lineage_Id) FROM Lineage) AS Lineage_Id
           FROM Insignia_staging_copy) AS source
    ON (target.Stock_Item_Id = source.Stock_Item_Id)
    WHEN MATCHED THEN
        UPDATE SET Stock_Item_Name = source.Stock_Item_Name,
                   Stock_ItemColor = source.Stock_ItemColor,
                   Stock_Item_Size = source.Stock_Item_Size,
                   Item_Size = source.Item_Size,
                   Stock_ItemPrice = source.Stock_ItemPrice,
                   Lineage_Id = source.Lineage_Id
    WHEN NOT MATCHED THEN
        INSERT (Stock_Item_Id, Stock_Item_Name, Stock_ItemColor, Stock_Item_Size, Item_Size, Stock_ItemPrice, Lineage_Id)
        VALUES (source.Stock_Item_Id, source.Stock_Item_Name, source.Stock_ItemColor, source.Stock_Item_Size, source.Item_Size, source.Stock_ItemPrice, source.Lineage_Id);
END;
GO
