CREATE TABLE [dbo].[Customers] (
    [ID] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [FirstName] NVARCHAR (30) NOT NULL,
    [LastName] NVARCHAR (50) NOT NULL,
    [StreetAddress] NVARCHAR (50) NULL,
    [City] NVARCHAR (30) NULL,
    [State] NVARCHAR (20) NULL,
    [Zip] NVARCHAR (10) NULL,
    [Phone] NVARCHAR (15) NULL,
    [Email] NVARCHAR (30) NOT NULL
);

CREATE TABLE [dbo].[Products] (
    [ProductID] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [ProductTab] NVARCHAR (30) NOT NULL,
    [ProductName] NVARCHAR (50) NULL,
    [ImageFile] NVARCHAR (30) NULL,
    [UnitPrice] DECIMAL (18, 2) NOT NULL,
    [MaxAmount] INT NOT NULL,
    [DefaultAmount] INT NOT NULL
);

CREATE TABLE [dbo].[Options] (
    [OptionID] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [OptionType] NVARCHAR (30) NOT NULL,
    [OptionName] NVARCHAR (50) NOT NULL,
    [OptionCost] DECIMAL (18, 2) NOT NULL
);

CREATE TABLE [dbo].[Intersections] (
    [ProductID] INT NOT NULL,
    [OptionID] INT NOT NULL,
    CONSTRAINT [PK_Intersections] PRIMARY KEY ([ProductID], [OptionID]),
    CONSTRAINT [FK_Intersections_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE,
    CONSTRAINT [FK_Intersections_Options] FOREIGN KEY ([OptionID]) REFERENCES [dbo].[Options] ([OptionID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[PurchaseOrders] (
    [OrderID] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [CustomerID] INT NOT NULL,
    [Date] DATETIME NOT NULL,
    [SubTotal] DECIMAL (18, 2) NOT NULL,
    [Tax] DECIMAL (18, 2) NOT NULL,
    [Total] DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [FK_PurchaseOrders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[LineItems] (
    [OrderID] INT NOT NULL,
    [LineNumber] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [Quantity] INT NOT NULL,
    [ExtendedPrice] DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_LineItems] PRIMARY KEY ([OrderID], [LineNumber]),
    CONSTRAINT [FK_LineItems_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[PurchaseOrders] ([OrderID]) ON DELETE CASCADE,
    CONSTRAINT [FK_LineItems_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[OptionAssociations] (
    [OrderID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [OptionID] INT NOT NULL,
    CONSTRAINT [PK_OptionAssociations] PRIMARY KEY ([OrderID], [ProductID], [OptionID]),
    CONSTRAINT [FK_OptionAssociations_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[PurchaseOrders] ([OrderID]) ON DELETE CASCADE,
    CONSTRAINT [FK_OptionAssociations_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE CASCADE,
    CONSTRAINT [FK_OptionAssociations_Options] FOREIGN KEY ([OptionID]) REFERENCES [dbo].[Options] ([OptionID]) ON DELETE CASCADE
);

INSERT INTO [dbo].[Options] ([OptionType], [OptionName], [OptionCost]) VALUES
    (N'Accessories', N'Deluxe', 10.00),
    (N'Accessories', N'Virtual money - 1000', 20.99),
    (N'Discounts', N'PS Plus', -20.00),
    (N'Discounts', N'Coupon', -10.00),
    (N'Accessories', N'Bundles', 10.00);

INSERT INTO [dbo].[Products] ([ProductTab], [ProductName], [ImageFile], [UnitPrice], [MaxAmount], [DefaultAmount]) VALUES
    (N'Tab1Orders', N'God of War: Ragnarok', N'GoW.jpg', 59.99, 10, 0),
    (N'Tab1Orders', N'Black Myth: Wukong', N'BMW.jpg', 69.99, 10, 0),
    (N'Tab1Orders', N'Call of Duty: Black Ops 6', N'COD.jpg', 69.99, 10, 0),
    (N'Tab2Orders', N'EA SPORTS FC 25', N'FC25.jpg', 69.99, 10, 0),
    (N'Tab2Orders', N'NBA 2K25', N'2K25.jpg', 69.99, 10, 0),
    (N'Tab2Orders', N'EA SPORTS College Football 25', N'COL25.jpg', 69.99, 10, 0),
    (N'Tab3Orders', N'Ghostwire: Tokyo', N'Ghostwire.jpg', 59.99, 10, 0),
    (N'Tab3Orders', N'Horizon Call of the Mountain', N'Horizon.jpg', 59.99, 10, 0),
    (N'Tab3Orders', N'Kong: Survivor Instinct', N'Kong.jpg', 24.99, 10, 0);

INSERT INTO [dbo].[Intersections] ([ProductID], [OptionID]) VALUES
    (1, 5), (2, 1), (3, 2), (4, 2), (5, 2), (6, 2), (7, 4), (8, 3), (9, 4);
GO
