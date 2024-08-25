USE InsigniaDW;

-- Lineage Table
CREATE TABLE Lineage (
    Lineage_Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Source_System VARCHAR(100),
    Load_Stat_Datetime DATETIME,
    Load_EndDatetime DATETIME,
    Rows_at_Source INT,
    Rows_at_destination_Fact INT,
    Load_Status BIT
);

-- Date Dimension Table
CREATE TABLE DateDimension (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Day_Number INT,
    Month_Name VARCHAR(20),
    Short_Month VARCHAR(3),
    Calendar_Month_Number INT,
    Calendar_Year INT,
    Fiscal_Month_Number INT,
    Fiscal_Year INT,
    Week_Number INT
);

-- Employee Dimension (SCD Type 2)
CREATE TABLE EmployeeDimension (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Id INT,
    EmployeeFirstName VARCHAR(50),
    EmployeeLastName VARCHAR(50),
    Is_Salesperson BIT,
    ValidFrom DATETIME,
    ValidTo DATETIME,
    IsCurrent BIT,
    Lineage_Id BIGINT
);

-- Customer Dimension (SCD Type 2)
CREATE TABLE CustomerDimension (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Id INT,
    CustomerName VARCHAR(100),
    CustomerCategory VARCHAR(50),
    CustomerContactName VARCHAR(100),
    CustomerPostalCode VARCHAR(20),
    CustomerContactNumber VARCHAR(20),
    ValidFrom DATETIME,
    ValidTo DATETIME,
    IsCurrent BIT,
    Lineage_Id BIGINT
);

-- Stock Item Dimension (SCD Type 1)
CREATE TABLE StockItemDimension (
    StockItemKey INT IDENTITY(1,1) PRIMARY KEY,
    Stock_Item_Id INT,
    Stock_Item_Name VARCHAR(100),
    Stock_ItemColor VARCHAR(50),
    Stock_Item_Size VARCHAR(20),
    Item_Size VARCHAR(20),
    Stock_ItemPrice DECIMAL(18, 2),
    Lineage_Id BIGINT
);

-- Geography Dimension (SCD Type 3)
CREATE TABLE GeographyDimension (
    GeographyKey INT IDENTITY(1,1) PRIMARY KEY,
    City_ID INT,
    City VARCHAR(100),
    State_Province VARCHAR(100),
    Country VARCHAR(100),
    Continent VARCHAR(50),
    Sales_Territory VARCHAR(50),
    Region VARCHAR(50),
    Subregion VARCHAR(50),
    Latest_Recorded_Population INT,
    Previous_Population INT,
    Lineage_Id BIGINT
);

-- Fact Table
CREATE TABLE SalesFact (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT,
    Description VARCHAR(255),
    Quantity INT,
    Unit_Price DECIMAL(18, 2),
    Tax_Rate DECIMAL(5, 2),
    Total_Excluding_Tax DECIMAL(18, 2),
    Tax_Amount DECIMAL(18, 2),
    Profit DECIMAL(18, 2),
    Total_Including_Tax DECIMAL(18, 2),
    EmployeeKey INT,
    StockItemKey INT,
    CustomerKey INT,
    GeographyKey INT,
    DateKey INT,
    Lineage_Id BIGINT
);

