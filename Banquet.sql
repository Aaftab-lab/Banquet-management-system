CREATE DATABASE banquet_management;
USE banquet_management;

-- Creating Customer Table
CREATE TABLE Customer (
    CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'C%'),
	Name VARCHAR(30) NOT NULL CHECK (Name NOT LIKE '%[^a-zA-Z ]%'), -- Name validation
    Contact VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(255) -- Address sizes can vary greatly, so 255 is a good limit
);
ALTER TABLE Customer ADD COLUMN Password VARCHAR(50);

-- Creating Banquet Table
CREATE TABLE Banquet (
    BanquetID CHAR(5) PRIMARY KEY CHECK (BanquetID LIKE 'H%'),
    Name VARCHAR(80) NOT NULL, -- Banquet names might be longer; 100 is reasonable
    Location VARCHAR(150) NOT NULL, -- To allow for detailed location names
	Capacity INT CHECK (Capacity > 0 AND Capacity <= 1000), -- Capacity range
    CostPerDay DECIMAL(7, 2) CHECK (CostPerDay >= 0 AND CostPerDay <= 100000) -- Cost range
);

-- Creating Booking Table
CREATE TABLE Booking (
    BookingID CHAR(5) PRIMARY KEY CHECK (BookingID LIKE 'B%'),
    CustomerID CHAR(5) NOT NULL,
    BanquetID CHAR(5) NOT NULL,
    EventDate DATE NOT NULL, 
    Duration INT NOT NULL CHECK (Duration BETWEEN 1 AND 30), 
    TotalCost DECIMAL(10, 2) CHECK (TotalCost >= 0),
    Status ENUM('Confirmed', 'Cancelled') DEFAULT 'Confirmed',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BanquetID) REFERENCES Banquet(BanquetID)
);
ALTER TABLE Booking
ADD COLUMN EventID CHAR(5),
ADD FOREIGN KEY (EventID) REFERENCES EventType(EventID);

-- Creating Payment Table
CREATE TABLE Payment (
    PaymentID CHAR(5) PRIMARY KEY CHECK (PaymentID LIKE 'P%'),
    BookingID CHAR(5) NOT NULL,
    Amount DECIMAL(8, 2) CHECK (Amount >= 0 AND Amount <= 1000000), 
    PaymentMethod ENUM('Cash', 'Credit Card', 'UPI') NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentStatus ENUM('Completed', 'Pending', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE 
);


-- Creating Event Type Table
CREATE TABLE EventType (
    EventID CHAR(5) PRIMARY KEY CHECK (EventID LIKE 'E%'),
    EventName VARCHAR(50) NOT NULL, 
    Description TEXT, 
    CapacityRange VARCHAR(20) CHECK (CapacityRange REGEXP '^[0-9]+-[0-9]+$')
);

-- Creating Staff Table
CREATE TABLE Staff (
    StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'S%'),
    Name VARCHAR(30) NOT NULL CHECK (Name NOT LIKE '%[^a-zA-Z ]%'), 
    Role VARCHAR(50) NOT NULL,
    Contact VARCHAR(15) NOT NULL
);
ALTER TABLE Staff 
ADD COLUMN JoiningDate DATE, 
ADD COLUMN Salary DECIMAL(10, 2) CHECK (Salary >= 0);


CREATE TABLE BanquetStaff (
    StaffID CHAR(5) NOT NULL,
    BanquetID CHAR(5) NOT NULL,
    AssignedDate DATE NOT NULL,
    PRIMARY KEY (StaffID, BanquetID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (BanquetID) REFERENCES Banquet(BanquetID)
);
ALTER TABLE BanquetStaff
ADD COLUMN Role VARCHAR(50) NOT NULL;


-- Creating Menu Table
CREATE TABLE Menu (
    MenuID CHAR(5) PRIMARY KEY CHECK (MenuID LIKE 'M%'),
    EventID CHAR(5) NOT NULL,
    MenuType ENUM('Veg', 'Non-Veg', 'Mixed') NOT NULL,
    PricePerPlate DECIMAL(5, 2) CHECK (PricePerPlate >= 0 AND PricePerPlate <= 5000),
    FOREIGN KEY (EventID) REFERENCES EventType(EventID)
);

INSERT INTO Customer (CustomerID, Name, Contact, Email, Address) VALUES
('C001', 'Rahul Sharma', '9876543210', 'rahul.sharma@gmail.com', '123 MG Road, Bengaluru, Karnataka'),
('C002', 'Priya Gupta', '9123456789', 'priya.gupta@gmail.com', '456 Park Street, Kolkata, West Bengal'),
('C003', 'Amit Verma', '9988776655', 'amit.verma@gmail.com', '789 Malviya Nagar, Jaipur, Rajasthan'),
('C004', 'Sunita Iyer', '9234567890', 'sunita.iyer@gmail.com', '101 Banjara Hills, Hyderabad, Telangana'),
('C005', 'Vikram Singh', '9345678901', 'vikram.singh@gmail.com', '202 Connaught Place, New Delhi'),
('C006', 'Sita Patel', '9456789012', 'sita.patel@gmail.com', '303 Sadar Bazar, Ahmedabad, Gujarat'),
('C007', 'Deepak Kumar', '9567890123', 'deepak.kumar@gmail.com', '404 Gariahat Road, Kolkata, West Bengal'),
('C008', 'Anjali Reddy', '9678901234', 'anjali.reddy@gmail.com', '505 Jubilee Hills, Hyderabad, Telangana');

INSERT INTO Banquet (BanquetID, Name, Location, Capacity, CostPerDay) VALUES
('H001', 'Royal Banquet Hall', 'Bengaluru, Karnataka', 500, 20000.00),
('H002', 'Shivani Banquets', 'Kolkata, West Bengal', 300, 15000.00),
('H003', 'The Golden Room', 'Jaipur, Rajasthan', 200, 12000.00),
('H004', 'Sapphire Gardens', 'Hyderabad, Telangana', 400, 18000.00),
('H005', 'Sunrise Banquets', 'New Delhi', 350, 22000.00),
('H006', 'Lakeview Palace', 'Ahmedabad, Gujarat', 250, 10000.00),
('H007', 'Skyline Hall', 'Mumbai, Maharashtra', 450, 25000.00),
('H008', 'The Heritage Hall', 'Chennai, Tamil Nadu', 150, 8000.00),
('H009', 'Lavish Events', 'Pune, Maharashtra', 100, 5000.00),
('H010', 'Garden of Dreams', 'Chandigarh', 1000, 30000.00);

INSERT INTO Booking (BookingID, CustomerID, BanquetID, EventDate, Duration, TotalCost, Status) VALUES
('B001', 'C001', 'H001', '2024-12-01', 2, 40000.00, 'Confirmed'),
('B002', 'C002', 'H002', '2024-12-05', 1, 15000.00, 'Confirmed'),
('B003', 'C003', 'H003', '2024-12-10', 3, 36000.00, 'Cancelled'),
('B004', 'C004', 'H004', '2024-12-15', 1, 18000.00, 'Confirmed'),
('B005', 'C005', 'H005', '2024-12-20', 2, 44000.00, 'Pending'),
('B006', 'C006', 'H006', '2024-12-25', 4, 40000.00, 'Confirmed'),
('B007', 'C007', 'H007', '2024-12-30', 1, 25000.00, 'Confirmed'),
('B008', 'C008', 'H008', '2025-01-01', 3, 24000.00, 'Cancelled');

INSERT INTO Payment (PaymentID, BookingID, Amount, PaymentMethod, PaymentDate, PaymentStatus) VALUES
('P001', 'B001', 40000.00, 'Credit Card', '2024-11-30', 'Completed'),
('P002', 'B002', 15000.00, 'Cash', '2024-12-04', 'Completed'),
('P003', 'B003', 36000.00, 'UPI', '2024-12-09', 'Failed'),
('P004', 'B004', 18000.00, 'Credit Card', '2024-12-14', 'Completed'),
('P005', 'B005', 44000.00, 'UPI', '2024-12-19', 'Pending'),
('P006', 'B006', 40000.00, 'Cash', '2024-12-24', 'Completed'),
('P007', 'B007', 25000.00, 'Credit Card', '2024-12-29', 'Completed'),
('P008', 'B008', 24000.00, 'UPI', '2024-12-31', 'Failed');

INSERT INTO EventType (EventID, EventName, Description) VALUES
('E001', 'Wedding', 'A grand wedding event with full catering and decorations.'),
('E002', 'Birthday Party', 'A fun and festive birthday party for all ages.'),
('E003', 'Corporate Meeting', 'A corporate event for team-building and meetings.'),
('E004', 'Concert', 'A musical event with live performances.'),
('E005', 'Conference', 'A professional conference for various industries.'),
('E006', 'Gala', 'A formal evening event with dinner and speeches.'),
('E007', 'Exhibition', 'An exhibition showcasing arts and products.'),
('E008', 'Product Launch', 'A product unveiling event for a new market launch.');

INSERT INTO Menu (MenuID, EventID, MenuType, PricePerPlate) VALUES
('M001', 'E001', 'Mixed', 1500.00),
('M002', 'E002', 'Veg', 800.00),
('M003', 'E003', 'Non-Veg', 1200.00),
('M004', 'E004', 'Mixed', 2000.00),
('M005', 'E005', 'Veg', 1000.00),
('M006', 'E006', 'Non-Veg', 1500.00),
('M007', 'E007', 'Mixed', 1200.00),
('M008', 'E008', 'Veg', 1000.00);

-- _________________________________________________________________________________________________________________________________________ --
-- Inserting Staff data
INSERT INTO Staff (StaffID, Name, Role, Contact, JoiningDate, Salary)
VALUES
('S001', 'Rajesh Kumar', 'Manager', '9876543210', '2022-01-01', 50000.00),
('S002', 'Priya Sharma', 'Manager', '9876543211', '2022-02-01', 55000.00),
('S003', 'Anita Reddy', 'Manager', '9876543212', '2022-03-01', 52000.00),
('S004', 'Vikram Singh', 'Manager', '9876543213', '2022-04-01', 51000.00),
('S005', 'Neha Patel', 'Manager', '9876543214', '2022-05-01', 53000.00),
('S006', 'Suresh Yadav', 'Coordinator', '9876543215', '2022-06-01', 35000.00),
('S007', 'Ravi Verma', 'Coordinator', '9876543216', '2022-07-01', 36000.00),
('S008', 'Kavita Mehta', 'Coordinator', '9876543217', '2022-08-01', 37000.00),
('S009', 'Amit Joshi', 'Coordinator', '9876543218', '2022-09-01', 38000.00),
('S010', 'Sheetal Agarwal', 'Coordinator', '9876543219', '2022-10-01', 39000.00),
('S011', 'Shiv Kumar', 'Waiter', '9876543220', '2022-11-01', 25000.00),
('S012', 'Renu Singh', 'Waiter', '9876543221', '2022-12-01', 26000.00),
('S013', 'Ajay Kumar', 'Waiter', '9876543222', '2023-01-01', 24000.00),
('S014', 'Pooja Gupta', 'Waiter', '9876543223', '2023-02-01', 25000.00),
('S015', 'Rajeev Soni', 'Waiter', '9876543224', '2023-03-01', 23000.00),
('S016', 'Mohit Gupta', 'Waiter', '9876543225', '2023-04-01', 24000.00),
('S017', 'Ritika Bansal', 'Waiter', '9876543226', '2023-05-01', 22000.00),
('S018', 'Deepak Kumar', 'Waiter', '9876543227', '2023-06-01', 23000.00),
('S019', 'Simran Kaur', 'Waiter', '9876543228', '2023-07-01', 21000.00),
('S020', 'Arjun Verma', 'Waiter', '9876543229', '2023-08-01', 22000.00),
('S021', 'Seema Sharma', 'Waiter', '9876543230', '2023-09-01', 20000.00),
('S022', 'Nikhil Sharma', 'Waiter', '9876543231', '2023-10-01', 21000.00),
('S023', 'Manisha Thakur', 'Waiter', '9876543232', '2023-11-01', 19000.00),
('S024', 'Amit Mishra', 'Waiter', '9876543233', '2023-12-01', 20000.00),
('S025', 'Neelam Yadav', 'Waiter', '9876543234', '2024-01-01', 18000.00),
('S026', 'Rohit Chauhan', 'Waiter', '9876543235', '2024-02-01', 19000.00),
('S027', 'Geeta Rawat', 'Waiter', '9876543236', '2024-03-01', 17000.00),
('S028', 'Rajiv Thakur', 'Waiter', '9876543237', '2024-04-01', 18000.00),
('S029', 'Neeraj Kumar', 'Waiter', '9876543238', '2024-05-01', 16000.00),
('S030', 'Pooja Malik', 'Waiter', '9876543239', '2024-06-01', 17000.00),
('S031', 'Ravi Reddy', 'Chef', '9876543240', '2022-01-01', 35000.00),
('S032', 'Suman Patel', 'Chef', '9876543241', '2022-02-01', 36000.00),
('S033', 'Ashok Kumar', 'Chef', '9876543242', '2022-03-01', 34000.00),
('S034', 'Anjali Verma', 'Chef', '9876543243', '2022-04-01', 33000.00),
('S035', 'Naveen Jain', 'Chef', '9876543244', '2022-05-01', 32000.00),
('S036', 'Tanuja Singh', 'Chef', '9876543245', '2022-06-01', 31000.00),
('S037', 'Sandeep Kaur', 'Chef', '9876543246', '2022-07-01', 30000.00),
('S038', 'Sahil Mehta', 'Chef', '9876543247', '2022-08-01', 29000.00),
('S039', 'Rajender Kumar', 'Chef', '9876543248', '2022-09-01', 28000.00),
('S040', 'Jyoti Joshi', 'Chef', '9876543249', '2022-10-01', 27000.00),
('S041', 'Rama Devi', 'Cleaner', '9876543250', '2023-01-01', 20000.00),
('S042', 'Vinod Kumar', 'Cleaner', '9876543251', '2023-02-01', 21000.00),
('S043', 'Maya Sharma', 'Cleaner', '9876543252', '2023-03-01', 19000.00),
('S044', 'Ravi Prakash', 'Cleaner', '9876543253', '2023-04-01', 18000.00),
('S045', 'Kiran Gupta', 'Cleaner', '9876543254', '2023-05-01', 17000.00),
('S046', 'Vikas Singh', 'Security', '9876543255', '2023-06-01', 22000.00),
('S047', 'Suraj Kumar', 'Security', '9876543256', '2023-07-01', 23000.00),
('S048', 'Shikha Yadav', 'Security', '9876543257', '2023-08-01', 21000.00),
('S049', 'Manoj Verma', 'Security', '9876543258', '2023-09-01', 20000.00),
('S050', 'Rita Mehta', 'Security', '9876543259', '2023-10-01', 19000.00);

-- _________________________________________________________________________________________________________________________________________ --

-- Assigning staff for Royal Banquet Hall (H001) on 2024-12-01
INSERT INTO BanquetStaff (StaffID, BanquetID, AssignedDate, Role) VALUES
('S001', 'H001', '2024-12-01', 'Manager'),
('S002', 'H001', '2024-12-01', 'Coordinator'),
('S003', 'H001', '2024-12-01', 'Waiter'),
('S004', 'H001', '2024-12-01', 'Waiter'),
('S005', 'H001', '2024-12-01', 'Chef'),
('S006', 'H001', '2024-12-01', 'Chef'),
('S007', 'H001', '2024-12-01', 'Cleaner'),
('S008', 'H001', '2024-12-01', 'Security');

-- Assigning staff for Shivani Banquets (H002) on 2024-12-05
INSERT INTO BanquetStaff (StaffID, BanquetID, AssignedDate, Role) VALUES
('S009', 'H002', '2024-12-05', 'Manager'),
('S010', 'H002', '2024-12-05', 'Coordinator'),
('S011', 'H002', '2024-12-05', 'Waiter'),
('S012', 'H002', '2024-12-05', 'Waiter'),
('S013', 'H002', '2024-12-05', 'Chef'),
('S014', 'H002', '2024-12-05', 'Chef'),
('S015', 'H002', '2024-12-05', 'Cleaner'),
('S016', 'H002', '2024-12-05', 'Security');

-- No staff assignment for The Golden Room (H003) on 2024-12-10 (Cancelled event)

-- Assigning staff for Sapphire Gardens (H004) on 2024-12-15
INSERT INTO BanquetStaff (StaffID, BanquetID, AssignedDate, Role) VALUES
('S017', 'H004', '2024-12-15', 'Manager'),
('S018', 'H004', '2024-12-15', 'Coordinator'),
('S019', 'H004', '2024-12-15', 'Waiter'),
('S020', 'H004', '2024-12-15', 'Waiter'),
('S021', 'H004', '2024-12-15', 'Chef'),
('S022', 'H004', '2024-12-15', 'Chef'),
('S023', 'H004', '2024-12-15', 'Cleaner'),
('S024', 'H004', '2024-12-15', 'Security');

-- Assigning staff for Sunrise Banquets (H005) on 2024-12-20 (Pending event, no staff assigned)
-- Staff assignment can be done later when status changes to confirmed

-- Assigning staff for Lakeview Palace (H006) on 2024-12-25
INSERT INTO BanquetStaff (StaffID, BanquetID, AssignedDate, Role) VALUES
('S025', 'H006', '2024-12-25', 'Manager'),
('S026', 'H006', '2024-12-25', 'Coordinator'),
('S027', 'H006', '2024-12-25', 'Waiter'),
('S028', 'H006', '2024-12-25', 'Waiter'),
('S029', 'H006', '2024-12-25', 'Chef'),
('S030', 'H006', '2024-12-25', 'Chef'),
('S031', 'H006', '2024-12-25', 'Cleaner'),
('S032', 'H006', '2024-12-25', 'Security');

-- Assigning staff for Skyline Hall (H007) on 2024-12-30
INSERT INTO BanquetStaff (StaffID, BanquetID, AssignedDate, Role) VALUES
('S033', 'H007', '2024-12-30', 'Manager'),
('S034', 'H007', '2024-12-30', 'Coordinator'),
('S035', 'H007', '2024-12-30', 'Waiter'),
('S036', 'H007', '2024-12-30', 'Waiter'),
('S037', 'H007', '2024-12-30', 'Chef'),
('S038', 'H007', '2024-12-30', 'Chef'),
('S039', 'H007', '2024-12-30', 'Cleaner'),
('S040', 'H007', '2024-12-30', 'Security');

-- No staff assignment for The Heritage Hall (H008) on 2025-01-01 (Cancelled event)
-- _________________________________________________________________________________________________________________________________________ --




select * from customer;
select * from banquet;
select * from booking;
select * from eventtype;
select * from menu;
select * from payment;
select * from staff;
select * from banquetstaff;

-- Query to calculate total revenue from completed bookings
SELECT SUM(TotalCost) AS TotalRevenue
FROM Booking
WHERE Status = 'Confirmed';

-- Query to list popular banquets based on the number of bookings
SELECT BanquetID, COUNT(*) AS BookingCount
FROM Booking
GROUP BY BanquetID
ORDER BY BookingCount DESC;

-- Query to list staff assigned to a specific banquet on a specific date
SELECT BanquetID, AssignedDate, Role, StaffID
FROM BanquetStaff
WHERE BanquetID = 'H001' AND AssignedDate = '2024-12-01';

-- Query to count the roles assigned to each banquet for efficient teamwork planning
SELECT BanquetID, Role, COUNT(*) AS RoleCount
FROM BanquetStaff
GROUP BY BanquetID, Role;

-- Query to find available staff for a specific date
SELECT StaffID, Name, Role, Contact
FROM Staff
WHERE StaffID NOT IN (
    SELECT StaffID
    FROM BanquetStaff
    WHERE AssignedDate = '2024-12-01'
);

-- Query to get a list of staff by role for skill-specific allocation
SELECT Role, COUNT(*) AS StaffCount
FROM Staff
GROUP BY Role
ORDER BY StaffCount DESC;

-- Query to identify peak booking periods
SELECT MONTH(EventDate) AS Month, COUNT(*) AS BookingCount
FROM Booking
GROUP BY MONTH(EventDate)
ORDER BY BookingCount DESC;

-- Query to analyze average duration and cost of bookings
SELECT AVG(Duration) AS AverageDuration, AVG(TotalCost) AS AverageCost
FROM Booking;

-- Query to retrieve customer details for a specific booking
SELECT b.BookingID, c.CustomerID, c.Name, c.Contact, c.Email, b.Status
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
WHERE b.BookingID = 'B001';


-- Query to list bookings and payment status for follow-up
SELECT b.BookingID, b.CustomerID, b.EventDate, p.PaymentStatus
FROM Booking b
LEFT JOIN Payment p ON b.BookingID = p.BookingID
WHERE b.Status = 'Pending' OR p.PaymentStatus = 'Pending';

