# 🎉 Banquet Management System (Java + MySQL + Swing)

A desktop-based application built using Java Swing for managing banquet hall bookings, customer registration, event types, staff, menus, and payment records. It is connected to a MySQL database and supports CRUD operations on selected modules.

---

## 📌 Features

- Customer registration and login
- Booking management (Create, Read, Update, Delete)
- Payment processing and viewing
- Event Type listing
- Banquet listing
- Simple GUI with clean navigation

---

## 🚀 1. Requirements

- Java JDK 11 or above
- MySQL Workbench or MySQL Server
- MySQL Connector/J (`mysql-connector-java.jar`)

---

## 🗃️ 2. Set up the MySQL Database

1. Open **MySQL Workbench**.
2. Open the provided SQL file:  
   `sql/schema.sql`
3. Run the script to:
   - Create the database: `banquet_management`
   - Create all required tables (`Customer`, `Booking`, `Banquet`, `EventType`, `Payment`, etc.)
   - Add all foreign key constraints and checks

✅ **No need to manually create tables — just run the SQL script.**

---

## 💻 3. Run the Application

1. Add the JDBC connector to your project:
   - Place `mysql-connector-java.jar` inside the `lib/` folder.
2. Compile the app:
   ```bash
   javac -cp .;lib/mysql-connector-java.jar BanquetManagementApp.java
