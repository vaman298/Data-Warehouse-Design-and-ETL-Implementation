USE InsigniaDW;
GO

DECLARE @startDate DATE = '2000-01-01';
DECLARE @endDate DATE = '2023-12-31';

-- Generate date dimension data
WITH DateSequence AS (
    SELECT @startDate AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < @endDate
)
INSERT INTO DateDimension (DateKey, Date, Day_Number, Month_Name, Short_Month, Calendar_Month_Number, Calendar_Year, Fiscal_Month_Number, Fiscal_Year, Week_Number)
SELECT
    CONVERT(INT, CONVERT(VARCHAR, DateValue, 112)) AS DateKey,
    DateValue AS Date,
    DATEPART(DAY, DateValue) AS Day_Number,
    DATENAME(MONTH, DateValue) AS Month_Name,
    LEFT(DATENAME(MONTH, DateValue), 3) AS Short_Month,
    DATEPART(MONTH, DateValue) AS Calendar_Month_Number,
    DATEPART(YEAR, DateValue) AS Calendar_Year,
    DATEPART(MONTH, DATEADD(MONTH, -6, DateValue)) AS Fiscal_Month_Number,
    DATEPART(YEAR, DATEADD(MONTH, -6, DateValue)) AS Fiscal_Year,
    DATEPART(WEEK, DateValue) AS Week_Number
FROM DateSequence
OPTION (MAXRECURSION 0);
GO
