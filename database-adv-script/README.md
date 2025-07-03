Airbnb Database Joins Queries
Overview
This project contains SQL queries demonstrating the use of different types of joins (INNER JOIN, LEFT JOIN, and FULL OUTER JOIN) for the Airbnb-like application database, as part of the ALX Airbnb Database Module. The queries are defined in the airbnb_joins.sql file (artifact_id: a881916a-728c-459e-a835-b4d2c5934b2f) and operate on the database schema created by airbnb_schema.sql (artifact_id: 03de4876-c8f0-4208-9234-58308c841e3e) and populated with sample data from airbnb_seed.sql (artifact_id: 2d289b70-fba7-4728-9e8b-8ff37e4d6e2d).
The queries retrieve data from the User, Property, Booking, and Review tables, showcasing complex join operations to extract meaningful relationships.
Files

airbnb_joins.sql: Contains three SQL queries using INNER JOIN, LEFT JOIN, and FULL OUTER JOIN to retrieve data from the Airbnb database.

Queries Overview
1. INNER JOIN Query

Purpose: Retrieves all bookings along with the details of the users who made them.
Tables Involved: Booking and User.
Details: Uses an INNER JOIN to match bookings with their corresponding users based on user_id. Only bookings with a valid user are included (all bookings in the sample data, due to foreign key constraints).
Output: Returns booking_id, start_date, end_date, total_price, status, user_id, first_name, last_name, and email. With the sample data, this query returns 6 rows (one for each booking).

2. LEFT JOIN Query

Purpose: Retrieves all properties and their associated reviews, including properties that have no reviews.
Tables Involved: Property and Review.
Details: Uses a LEFT JOIN to include all properties, with review details appearing as NULL for properties without reviews. This ensures all properties are listed, even those without feedback.
Output: Returns property_id, name, location, pricepernight, review_id, rating, comment, and review_date. With the sample data, this query returns 4 rows (one for each property, with some having NULL review fields).

3. FULL OUTER JOIN Query

Purpose: Retrieves all users and all bookings, including users without bookings and any bookings without users (though none exist due to foreign key constraints).
Tables Involved: User and Booking.
Details: Emulates a FULL OUTER JOIN using a UNION of a LEFT JOIN (to get all users) and a RIGHT JOIN (to get any orphaned bookings, though none exist in the sample data). This is necessary for MySQL compatibility, as it does not support FULL OUTER JOIN natively. In PostgreSQL, a native FULL OUTER JOIN could be used.
Output: Returns user_id, first_name, last_name, email, booking_id, start_date, end_date, total_price, and status. With the sample data, this query returns 7 rows (5 users, with 2 having bookings and 3 without).

Usage

Prerequisites:

The database schema must be created using airbnb_schema.sql.
The database must be populated with sample data using airbnb_seed.sql.
A relational database management system (e.g., MySQL, PostgreSQL) that supports UUIDs, ENUMs, and standard SQL syntax.
Database user with permissions to query tables.


Setup:

Execute the airbnb_joins.sql file after setting up the schema and seed data:mysql -u <username> -p <database_name> < airbnb_joins.sql

or, for PostgreSQL:psql -U <username> -d <database_name> -f airbnb_joins.sql




Notes:

UUIDs: The schema uses UUIDs for primary keys, which may require enabling the uuid-ossp extension in PostgreSQL (CREATE EXTENSION IF NOT EXISTS "uuid-ossp";).
ENUMs: The role (User), status (Booking), and other ENUM fields are MySQL-specific. For PostgreSQL, ensure the schema uses custom types or VARCHAR with check constraints.
FULL OUTER JOIN: The query uses a UNION of LEFT JOIN and RIGHT JOIN for MySQL compatibility. For PostgreSQL, you can replace it with a native FULL OUTER JOIN for simplicity:SELECT u.user_id, u.first_name, u.last_name, u.email, b.booking_id, b.start_date, b.end_date, b.total_price, b.status
FROM User u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;


Sample Data Context: The queries assume the sample data from airbnb_seed.sql (5 users, 4 properties, 6 bookings, etc.). Results may vary with different data.



Expected Results

INNER JOIN: Returns 6 rows, showing all bookings with user details (e.g., Jane Smith’s booking for Cozy Downtown Loft).
LEFT JOIN: Returns 4 rows, listing all properties, with NULLs for review columns for properties without reviews.
FULL OUTER JOIN: Returns 7 rows, including all 5 users (e.g., Admin User with no bookings) and all 6 bookings, with no orphaned bookings due to foreign key constraints.

License
This project is for educational purposes as part of the ALX Airbnb Database Module.
