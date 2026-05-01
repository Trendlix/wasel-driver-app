curl -X POST http://16.171.45.88:3000/driver/apply \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo4NCwicHVycG9zZSI6ImNvbXBsZXRlX3JlZ2lzdHJhdGlvbiIsImlhdCI6MTc3NzY0NzQ4MywiZXhwIjoxNzc3OTA2NjgzfQ.Vf5Pq22wVyxyQ00j86SXsZMRV6HqjJ_XqiELKm1ukr0" \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "test user",
    "national_id_expiry": "2026-05-30T00:00:00.000Z",
    "license_expiry": "2026-06-25T00:00:00.000Z",
    "truck_type_id": 4,
    "truck_model": "ssd43",
    "year": 2033,
    "license_plate": "asdc43",
    "accepts_ads": true,
    "has_company": false
  }'
