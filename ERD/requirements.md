🧩 Entities and Their Attributes
1. User
user_id (PK)

first_name

last_name

email (UNIQUE)

password_hash

phone_number

role (ENUM: guest, host, admin)

created_at

2. Property
property_id (PK)

host_id (FK → User.user_id)

name

description

location

pricepernight

created_at

updated_at

3. Booking
booking_id (PK)

property_id (FK → Property.property_id)

user_id (FK → User.user_id)

start_date

end_date

total_price

status (ENUM: pending, confirmed, canceled)

created_at

4. Payment
payment_id (PK)

booking_id (FK → Booking.booking_id)

amount

payment_date

payment_method (ENUM: credit_card, paypal, stripe)

5. Review
review_id (PK)

property_id (FK → Property.property_id)

user_id (FK → User.user_id)

rating (CHECK 1–5)

comment

created_at

6. Message
message_id (PK)

sender_id (FK → User.user_id)

recipient_id (FK → User.user_id)

message_body

sent_at

🔗 Entity Relationships
Relationship	Type
A User can have many Bookings	1-to-many
A User can list many Properties (if role is host)	1-to-many
A Property can have many Bookings	1-to-many
A Booking has one Payment	1-to-1
A Property can have many Reviews	1-to-many
A User can leave many Reviews	1-to-many
A User can send/receive many Messages	1-to-many (bidirectional)


![airbnb_erd drawio](https://github.com/user-attachments/assets/084b0cbe-6ae5-4ee8-afda-1196ee171ab5)
