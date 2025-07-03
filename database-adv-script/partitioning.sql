-- Report: Partitioning Strategy and Performance Improvements
--
-- Objective: Implement range partitioning on the Booking table by start_date to optimize queries on large datasets.
-- Strategy: 
-- - Partition the Booking table by year on start_date (2025, 2026, 2027+).
-- - Use PostgreSQL range partitioning, with child tables for each year range.
-- - Recreate constraints (primary key, foreign keys, check constraints) and indexes on partitions.
-- - Test performance using a date range query from performance.sql.
--
-- Performance Analysis (Before Partitioning):
-- - Query: SELECT ... FROM Booking b INNER JOIN User u ON b.user_id = u.user_id INNER JOIN Property p ON b.property_id = p.property_id INNER JOIN Payment pay ON b.booking_id = pay.booking_id WHERE b.status = 'confirmed' AND b.start_date BETWEEN '2025-07-01' AND '2025-07-31' ORDER BY b.created_at;
-- - EXPLAIN (non-partitioned): Likely shows a Seq Scan on Booking, scanning all rows (6 in sample data, millions in a large dataset), using idx_booking_status, idx_booking_user_id, idx_booking_property_id, idx_payment_booking_id, and idx_booking_created_at.
-- - Inefficiency: Full table scan on Booking for start_date filter, as no index exists on start_date.
--
-- Partitioning Implementation:
-- - Drop the existing Booking table.
-- - Create a parent Booking table with no data, partitioned by RANGE on start_date.
-- - Create child tables: booking_2025 (2025-01-01 to 2025-12-31), booking_2026 (2026-01-01 to 2026-12-31), booking_2027_future (2027-01-01+).
-- - Apply constraints and indexes to each partition.
-- - Insert sample data (6 bookings, all in 2025).
--
-- Performance Analysis (After Partitioning):
-- - EXPLAIN (partitioned): Should show partition pruning, scanning only booking_2025 for the date range, reducing rows scanned. Indexes on partitions (e.g., idx_booking_2025_status) optimize status and join conditions.
-- - Expected Improvement: For large datasets, partition pruning reduces I/O by limiting scans to relevant partitions (e.g., 2025 only). With sample data (6 rows), improvement is minimal, but significant for millions of rows.
--
-- Observations:
-- - Sample data is small (6 bookings), so performance gains are subtle (e.g., reduced rows scanned from 6 to 6 in 2025 partition).
-- - In a production environment with millions of bookings, partitioning by year would limit scans to a fraction of the data (e.g., 1 year’s worth), improving query execution time.
-- - The idx_booking_2025_status index optimizes the status filter, and idx_booking_2025_created_at optimizes ORDER BY.
-- - For MySQL, use equivalent syntax (commented below) with PARTITION BY RANGE (YEAR(start_date)).
--
-- Conclusion: Partitioning by start_date optimizes range queries by enabling partition pruning, reducing I/O and execution time for large datasets. The small sample data limits visible gains, but the structure scales well for production use.

-- Step 1: Analyze performance of query on non-partitioned Booking table
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' AND b.start_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.created_at;

-- Step 2: Drop existing Booking table (ensure dependencies are handled)
-- Note: Temporarily drop dependent constraints in Payment table
ALTER TABLE Payment DROP FOREIGN KEY fk_payment_booking;
DROP TABLE Booking;

-- Step 3: Create partitioned Booking table (PostgreSQL syntax)
CREATE TABLE Booking (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
) PARTITION BY RANGE (start_date);

-- Create child tables for 2025, 2026, and 2027+
CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01')
    (
        CONSTRAINT booking_2025_pk PRIMARY KEY (booking_id),
        CONSTRAINT fk_booking_2025_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
        CONSTRAINT fk_booking_2025_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT
    );

CREATE TABLE booking_2026 PARTITION OF Booking
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01')
    (
        CONSTRAINT booking_2026_pk PRIMARY KEY (booking_id),
        CONSTRAINT fk_booking_2026_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
        CONSTRAINT fk_booking_2026_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT
    );

CREATE TABLE booking_2027_future PARTITION OF Booking
    FOR VALUES FROM ('2027-01-01') TO (MAXVALUE)
    (
        CONSTRAINT booking_2027_future_pk PRIMARY KEY (booking_id),
        CONSTRAINT fk_booking_2027_future_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
        CONSTRAINT fk_booking_2027_future_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT
    );

-- Step 4: Recreate indexes on partitions
CREATE INDEX idx_booking_2025_property_id ON booking_2025(property_id);
CREATE INDEX idx_booking_2025_user_id ON booking_2025(user_id);
CREATE INDEX idx_booking_2025_created_at ON booking_2025(created_at);
CREATE INDEX idx_booking_2025_status ON booking_2025(status);

CREATE INDEX idx_booking_2026_property_id ON booking_2026(property_id);
CREATE INDEX idx_booking_2026_user_id ON booking_2026(user_id);
CREATE INDEX idx_booking_2026_created_at ON booking_2026(created_at);
CREATE INDEX idx_booking_2026_status ON booking_2026(status);

CREATE INDEX idx_booking_2027_future_property_id ON booking_2027_future(property_id);
CREATE INDEX idx_booking_2027_future_user_id ON booking_2027_future(user_id);
CREATE INDEX idx_booking_2027_future_created_at ON booking_2027_future(created_at);
CREATE INDEX idx_booking_2027_future_status ON booking_2027_future(status);

-- Step 5: Recreate foreign key in Payment table
ALTER TABLE Payment ADD CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE RESTRICT;

-- Step 6: Insert sample data (from airbnb_seed.sql, all in 2025)
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f40', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e2f', '550e8400-e29b-41d4-a716-446655440001', '2025-07-01', '2025-07-03', 300.00, 'confirmed', '2025-06-10 09:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f41', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e2f', '550e8400-e29b-41d4-a716-446655440003', '2025-07-05', '2025-07-07', 300.00, 'pending', '2025-06-11 10:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f42', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e30', '550e8400-e29b-41d4-a716-446655440001', '2025-07-10', '2025-07-14', 800.00, 'confirmed', '2025-06-12 12:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f43', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e31', '550e8400-e29b-41d4-a716-446655440003', '2025-07-15', '2025-07-17', 240.00, 'confirmed', '2025-06-13 14:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f44', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e32', '550e8400-e29b-41d4-a716-446655440001', '2025-07-20', '2025-07-22', 360.00, 'canceled', '2025-06-14 11:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f45', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e32', '550e8400-e29b-41d4-a716-446655440003', '2025-07-25', '2025-07-28', 540.00, 'confirmed', '2025-06-15 13:00:00');

-- Step 7: Analyze performance of query on partitioned Booking table
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' AND b.start_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.created_at;

-- MySQL Equivalent Syntax (for reference, uncomment if using MySQL)
-- Note: MySQL uses PARTITION BY RANGE (YEAR(start_date))

ALTER TABLE Payment DROP FOREIGN KEY fk_payment_booking;
DROP TABLE Booking;

CREATE TABLE Booking (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date),
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE RESTRICT,
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
) PARTITION BY RANGE (YEAR(start_date));

CREATE TABLE booking_2025 PARTITION OF Booking VALUES LESS THAN (2026);
CREATE TABLE booking_2026 PARTITION OF Booking VALUES LESS THAN (2027);
CREATE TABLE booking_2027_future PARTITION OF Booking VALUES LESS THAN MAXVALUE;

ALTER TABLE Payment ADD CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE RESTRICT;

CREATE INDEX idx_booking_2025_property_id ON booking_2025(property_id);
CREATE INDEX idx_booking_2025_user_id ON booking_2025(user_id);
CREATE INDEX idx_booking_2025_created_at ON booking_2025(created_at);
CREATE INDEX idx_booking_2025_status ON booking_2025(status);
-- Repeat for other partitions
