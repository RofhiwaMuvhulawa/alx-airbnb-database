-- Query 1: INNER JOIN to retrieve all bookings and the respective users
-- Purpose: Show only bookings that have a corresponding user (all bookings in the sample data due to FK constraints)
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

-- Query 2: LEFT JOIN to retrieve all properties and their reviews, including properties with no reviews
-- Purpose: Include all properties, even those without reviews (e.g., some properties may have no reviews in the sample data)
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

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings
-- Purpose: Show all users (even those without bookings) and all bookings (even those without users, though none exist due to FK constraints)
-- Note: MySQL does not support FULL OUTER JOIN; emulated using LEFT JOIN and RIGHT JOIN with UNION
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
UNION
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM Booking b
LEFT JOIN User u ON b.user_id = u.user_id
WHERE u.user_id IS NULL
ORDER BY user_id, booking_id;
