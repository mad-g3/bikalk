ENTITIES (Collections)

1. user
   Uses the app - stores customer information*

Attributes:
userId - unique document identifier
Name (string) - User's full name
Email (string) - Email address
phoneNumber  (string) - Contact number
isEmailVerified (boolean) - Is Email Verified

2. fare_rates
   Pricing according to bike types

Attributes:
rateId - Unique document identifier
bikeType (string) - "Electric" or "Fuel"
pricePerKm (number) - Rate per kilometer
minPrice (number) - Minimum fare for any trip
maxPrice (number) - Maximum fare
fuelPerKm (number, nullable) - Fuel consumption in liters per km

3. reports
   Submitted complaints/problems and feedback from users

Attributes:
reportId - Unique document identifier
userId (string) - reference to user document ID (points to {userId}
Category (string) - "app-bug", "pricing-error", "feature-request", "location-issue", "feedback"
Description (string) - Detailed problem description
reportedAt (timestamp) - Submission timestamp

RELATIONSHIPS

users ↔ reports (One-to-Many)
Relationship Type: Reference by Document ID
Description:

One user can submit multiple reports
Each report belongs to one user

Implementation:

The reports collection contains a userId field
userId stores the document ID from the users collection



