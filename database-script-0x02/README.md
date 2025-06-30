Airbnb Database Seed Data
Overview
This project contains the SQL seed data for an Airbnb-like application database, designed as part of the ALX Airbnb Database Module. The seed file (airbnb_seed.sql) populates the database with realistic sample data to simulate real-world usage, including users, properties, bookings, payments, reviews, and messages. The data adheres to the schema defined in airbnb_schema.sql (artifact_id: 03de4876-c8f0-4208-9234-58308c841e3e), ensuring compliance with all constraints (e.g., UUIDs, ENUMs, foreign keys).
Files

airbnb_seed.sql: Contains INSERT statements to populate the User, Property, Booking, Payment, Review, and Message tables with sample data.

Sample Data Overview
User Table

Records: 5 users (2 hosts, 2 guests, 1 admin).
Details: Includes realistic names, emails, phone numbers, and roles. Passwords are represented as placeholder hashes. Example:
John Doe (host), Jane Smith (guest), Alice Brown (host), Bob Johnson (guest), Admin User (admin).


Purpose: Simulates a mix of users interacting with the system (hosts listing properties, guests booking, admin for management).

Property Table

Records: 4 properties (2 per host).
Details: Properties have varied names, descriptions, locations, and prices per night. Example:
Cozy Downtown Loft (New York, $150/night), Beachfront Cottage (Miami, $200/night).


Purpose: Represents diverse listings across different locations, owned by the two host users.

Booking Table

Records: 6 bookings.
Details: Bookings cover multiple properties and users, with realistic dates, total prices (calculated as pricepernight × nights), and statuses (pending, confirmed, canceled). Example:
Jane Smith books Cozy Downtown Loft for 2 nights ($300, confirmed).
Bob Johnson books Mountain Cabin for 2 nights ($240, confirmed).


Purpose: Simulates booking activity, including overlapping dates and different statuses.

Payment Table

Records: 6 payments (one per booking).
Details: Payments match booking total prices, with varied payment methods (credit_card, paypal, stripe) and timestamps. Example:
Payment of $300 for Jane’s booking via credit_card.


Purpose: Demonstrates payment processing for bookings, adhering to the 1:1 relationship.

Review Table

Records: 4 reviews.
Details: Reviews are submitted by guests for properties, with ratings (1–5) and comments. Example:
Jane Smith rates Cozy Downtown Loft 4/5 with a positive comment.


Purpose: Simulates guest feedback on properties after stays.

Message Table

Records: 4 messages.
Details: Messages between guests and hosts, with realistic message bodies and timestamps. Example:
Jane Smith messages John Doe about Cozy Downtown Loft availability.


Purpose: Represents communication between users regarding bookings or inquiries.

Usage

Prerequisites:

The database schema must be created first using airbnb_schema.sql.
A relational database management system (e.g., MySQL, PostgreSQL) that supports UUIDs, ENUMs, and standard SQL syntax.
Database user with permissions to insert data.


Setup:

Execute the airbnb_seed.sql file after creating the schema:mysql -u <username> -p <database_name> < airbnb_seed.sql

or, for PostgreSQL:psql -U <username> -d <database_name> -f airbnb_seed.sql




Notes:

UUIDs: The seed file uses fixed UUIDs for consistency. For production, use database-specific UUID generation (e.g., uuid_generate_v4() in PostgreSQL or UUID() in MySQL).
ENUMs: The role (User), status (Booking), and payment_method (Payment) fields use ENUMs, which are MySQL-specific. For PostgreSQL, ensure custom types or VARCHAR with check constraints are used in the schema.
Data Integrity: The sample data respects all constraints (e.g., foreign keys, unique constraints, check constraints on rating and end_date >= start_date).
Scalability: The data is minimal but can be extended by adding more records following the same structure.



Notes on Realism

Users: Diverse roles and realistic contact details simulate a functional user base.
Properties: Varied locations and prices reflect typical Airbnb listings.
Bookings/Payments: Total prices align with property prices and stay durations, with varied statuses and payment methods.
Reviews/Messages: Reflect post-stay feedback and user communication, common in Airbnb scenarios.

License
This project is for educational purposes as part of the ALX Airbnb Database Module.
