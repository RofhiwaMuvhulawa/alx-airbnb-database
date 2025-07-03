-- Query 1: Non-correlated Subquery to find properties with average rating > 4.0
-- Purpose: Calculate the average rating per property in a subquery and select properties exceeding 4.0
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight
FROM Property p
INNER JOIN (
    SELECT 
        property_id,
        AVG(rating) AS avg_rating
    FROM Review
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
) r ON p.property_id = r.property_id
ORDER BY p.property_id;

-- Query 2: Correlated Subquery to find users with more than 3 bookings
-- Purpose: For each user, count their bookings in a subquery and return users with > 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM User u
WHERE (
    SELECT COUNT(*) 
    FROM Booking b 
    WHERE b.user_id = u.user_id
) > 3
ORDER BY u.user_id;
