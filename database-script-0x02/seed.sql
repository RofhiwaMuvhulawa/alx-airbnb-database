-- Insert sample data into User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'John', 'Doe', 'john.doe@email.com', 'hash123', '+12345678901', 'host', '2025-06-01 10:00:00'),
('550e8400-e29b-41d4-a716-446655440001', 'Jane', 'Smith', 'jane.smith@email.com', 'hash456', '+12345678902', 'guest', '2025-06-01 11:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Alice', 'Brown', 'alice.brown@email.com', 'hash789', '+12345678903', 'host', '2025-06-02 09:00:00'),
('550e8400-e29b-41d4-a716-446655440003', 'Bob', 'Johnson', 'bob.johnson@email.com', 'hash012', '+12345678904', 'guest', '2025-06-02 10:00:00'),
('550e8400-e29b-41d4-a716-446655440004', 'Admin', 'User', 'admin@email.com', 'hashadmin', '+12345678905', 'admin', '2025-06-03 08:00:00');

-- Insert sample data into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e2f', '550e8400-e29b-41d4-a716-446655440000', 'Cozy Downtown Loft', 'Modern loft in the heart of the city.', '123 Main St, New York, NY', 150.00, '2025-06-05 12:00:00', '2025-06-05 12:00:00'),
('6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e30', '550e8400-e29b-41d4-a716-446655440000', 'Beachfront Cottage', 'Charming cottage with ocean views.', '456 Beach Rd, Miami, FL', 200.00, '2025-06-06 14:00:00', '2025-06-06 14:00:00'),
('6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e31', '550e8400-e29b-41d4-a716-446655440002', 'Mountain Cabin', 'Rustic cabin in the mountains.', '789 Hill St, Denver, CO', 120.00, '2025-06-07 10:00:00', '2025-06-07 10:00:00'),
('6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e32', '550e8400-e29b-41d4-a716-446655440002', 'Urban Studio', 'Stylish studio near downtown.', '101 City Ave, Chicago, IL', 180.00, '2025-06-08 11:00:00', '2025-06-08 11:00:00');

-- Insert sample data into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f40', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e2f', '550e8400-e29b-41d4-a716-446655440001', '2025-07-01', '2025-07-03', 300.00, 'confirmed', '2025-06-10 09:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f41', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e2f', '550e8400-e29b-41d4-a716-446655440003', '2025-07-05', '2025-07-07', 300.00, 'pending', '2025-06-11 10:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f42', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e30', '550e8400-e29b-41d4-a716-446655440001', '2025-07-10', '2025-07-14', 800.00, 'confirmed', '2025-06-12 12:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f43', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e31', '550e8400-e29b-41d4-a716-446655440003', '2025-07-15', '2025-07-17', 240.00, 'confirmed', '2025-06-13 14:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f44', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e32', '550e8400-e29b-41d4-a716-446655440001', '2025-07-20', '2025-07-22', 360.00, 'canceled', '2025-06-14 11:00:00'),
('8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f45', '6b3e8c2d-3f4a-4c1b-9e2d-7a8b9c0d1e32', '550e8400-e29b-41d4-a716-446655440003', '2025-07-25', '2025-07-28', 540.00, 'confirmed', '2025-06-15 13:00:00');

-- Insert sample data into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('9d5g0e4f-5b6c-4e3d-9g4f-0c1d2e3f4g50', '8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f40', 300.00, '2025-06-10 09:30:00', 'credit_card'),
('9d5g0e4f-5b6c-4e3d-9g4f-0c1d2e3f4g51', '8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f41', 300.00, '2025-06-11 10:30:00', 'paypal'),
('9d5g0e4f-5b6c-4e3d-9g4f-0c1d2e3f4g52', '8c4f9d3e-4a5b-4d2c-8f3e-9b0c1d2e3f42', 800.00, '2025-06-12 12:30:00', 'stripe'),
