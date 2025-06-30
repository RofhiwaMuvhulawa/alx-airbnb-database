Airbnb Database Schema
Overview
This project contains the SQL schema for an Airbnb-like application database, designed as part of the ALX Airbnb Database Module. The schema defines a relational database with tables for managing users, properties, bookings, payments, reviews, and messages. It adheres to normalization principles (3NF), incorporates appropriate constraints, and includes indexes for optimal query performance.
The SQL file (airbnb_schema.sql) creates the database structure with all necessary tables, primary keys, foreign keys, constraints, and indexes.
Files

airbnb_schema.sql: Contains CREATE TABLE statements and index definitions for the database schema.

Database Schema
Tables

User

Stores user information (guests, hosts, admins).
Attributes: user_id (PK, UUID), first_name, last_name, email (UNIQUE), password_hash, phone_number, role (ENUM: guest, host, admin), created_at.
Constraints: Unique constraint on email, non-null constraints on required fields.


Property

Stores property listings created by hosts.
Attributes: property_id (PK, UUID), host_id (FK), name, description, location, pricepernight, created_at, updated_at.
Constraints: Foreign key on host_id referencing User(user_id).


Booking

Manages bookings made by users for properties.
Attributes: booking_id (PK, UUID), property_id (FK), user_id (FK), start_date, end_date, total_price, status (ENUM: pending, confirmed, canceled), created_at.
Constraints: Foreign keys on property_id and user_id, check constraint ensuring end_date >= start_date.


Payment

Records payments associated with bookings.
Attributes: payment_id (PK, UUID), booking_id (FK), amount, payment_date, payment_method (ENUM: credit_card, paypal, stripe).
Constraints: Foreign key on booking_id, unique constraint on booking_id (1:1 relationship).


Review

Stores user reviews for properties.
Attributes: review_id (PK, UUID), property_id (FK), user_id (FK), rating (1-5), comment, created_at.
Constraints: Foreign keys on property_id and user_id, check constraint on rating (1-5).


Message

Manages messages between users (e.g., host-guest communication).
Attributes: message_id (PK, UUID), sender_id (FK), recipient_id (FK), message_body, sent_at.
Constraints: Foreign keys on sender_id and recipient_id.



Relationships

User to Property: One-to-Many (one user can host multiple properties).
User/Property to Booking: Many-to-Many (via Booking table).
Booking to Payment: One-to-One (each booking has one payment).
User/Property to Review: Many-to-Many (via Review table).
User to Message: Many-to-Many (users can send/receive multiple messages).

Indexes

Primary keys (user_id, property_id, etc.) are automatically indexed.
Additional indexes:
email (User) for fast lookups.
host_id (Property) for host-related queries.
property_id and user_id (Booking, Review) for efficient joins.
booking_id (Payment) for payment lookups.
sender_id and recipient_id (Message) for message queries.



Usage

Prerequisites:

A relational database management system (e.g., MySQL, PostgreSQL) that supports UUIDs, ENUMs, and standard SQL syntax.
Ensure the database user has permissions to create tables and indexes.


Setup:

Execute the airbnb_schema.sql file in your database:mysql -u <username> -p <database_name> < airbnb_schema.sql

or, for PostgreSQL:psql -U <username> -d <database_name> -f airbnb_schema.sql




Notes:

The schema uses UUID for primary keys, which may require enabling UUID extensions in some databases (e.g., uuid-ossp in PostgreSQL).
The ENUM data type is MySQL-specific; for PostgreSQL, create custom types or use VARCHAR with check constraints.
Adjust VARCHAR lengths (e.g., 50, 100, 255) based on specific requirements if needed.



Normalization
The schema is in Third Normal Form (3NF):

1NF: All attributes are atomic, with primary keys and no repeating groups.
2NF: No partial dependencies (all tables use single-column primary keys).
3NF: No transitive dependencies (non-key attributes depend only on primary keys).

Constraints

Primary Keys: Ensure unique identification of records.
Foreign Keys: Enforce referential integrity with ON DELETE RESTRICT to prevent invalid deletions.
Unique Constraints: email (User) and booking_id (Payment) ensure uniqueness.
Check Constraints: rating (Review, 1-5) and end_date >= start_date (Booking) enforce data validity.

License
This project is for educational purposes as part of the ALX Airbnb Database Module.
