-- Step 1: Analyze performance of INNER JOIN query before adding index on Booking.created_at
-- Query from airbnb_joins.sql
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
    u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at;

-- Step 2: Analyze performance of LEFT JOIN query before adding index on Review.created_at
-- Query from airbnb_joins.sql
EXPLAIN
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;

-- Step 3: Create new indexes to optimize query performance
-- Index on Booking.created_at for ORDER BY in INNER JOIN query
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Index on Review.created_at for ORDER BY in LEFT JOIN query
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Step 4: Re-analyze performance of INNER JOIN query after adding index
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
    u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at;

-- Step 5: Re-analyze performance of LEFT JOIN query after adding index
EXPLAIN
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;
