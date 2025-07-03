-- Initial Query: Retrieve confirmed bookings in July 2025 with user, property, and payment details
-- Purpose: Join Booking, User, Property, and Payment tables, filtering with WHERE and AND
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' AND b.start_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.created_at;

-- Analyze performance of initial query
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' AND b.start_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.created_at;

-- Create index to optimize WHERE clause on Booking.status
CREATE INDEX idx_booking_status ON Booking(status);

-- Refactored Query: Optimized version with fewer columns and INNER JOIN for Payment
-- Optimizations:
-- 1. Reduced columns to essential fields for typical booking report
-- 2. Changed LEFT JOIN to INNER JOIN for Payment (1:1 relationship in sample data)
-- 3. Leverages existing indexes (idx_booking_user_id, idx_booking_property_id, idx_payment_booking_id, idx_booking_created_at) and new idx_booking_status
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

-- Analyze performance of refactored query
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
