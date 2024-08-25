USE InsigniaDW;
GO

CREATE PROCEDURE LoadFactTable
AS
BEGIN
    INSERT INTO SalesFact (InvoiceId, Description, Quantity, Unit_Price, Tax_Rate, Total_Excluding_Tax, Tax_Amount, Profit, Total_Including_Tax, EmployeeKey, StockItemKey, CustomerKey, GeographyKey, DateKey, Lineage_Id)
    SELECT isc.InvoiceId, isc.Description, isc.Quantity, isc.Unit_Price, isc.Tax_Rate, isc.Total_Excluding_Tax, isc.Tax_Amount, isc.Profit, isc.Total_Including_Tax,
           ed.EmployeeKey, sid.StockItemKey, cd.CustomerKey, gd.GeographyKey, (SELECT DateKey FROM DateDimension WHERE [Date] = CAST(GETDATE() AS DATE)), (SELECT MAX(Lineage_Id) FROM Lineage)
    FROM Insignia_staging_copy isc
    JOIN EmployeeDimension ed ON isc.Employee_Id = ed.Employee_Id AND ed.IsCurrent = 1
    JOIN StockItemDimension sid ON isc.Stock_Item_Id = sid.Stock_Item_Id
    JOIN CustomerDimension cd ON isc.Customer_Id = cd.Customer_Id AND cd.IsCurrent = 1
    JOIN GeographyDimension gd ON isc.City_ID = gd.City_ID;
END;
GO
