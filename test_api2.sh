for format in "2026-05-30" "2026-05-30T00:00:00.000Z" "2026-05-30T00:00:00" "05-30-2026" "2026/05/30" "1777906683"; do
  echo "Testing: $format"
  curl -s -X POST http://16.171.45.88:3000/driver/apply \
    -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo4NCwicHVycG9zZSI6ImNvbXBsZXRlX3JlZ2lzdHJhdGlvbiIsImlhdCI6MTc3NzY0NzQ4MywiZXhwIjoxNzc3OTA2NjgzfQ.Vf5Pq22wVyxyQ00j86SXsZMRV6HqjJ_XqiELKm1ukr0" \
    -F "full_name=test user" \
    -F "national_id_expiry=$format" \
    -F "license_expiry=$format" \
    -F "truck_type_id=4" \
    -F "truck_model=ssd43" \
    -F "year=2033" \
    -F "license_plate=asdc43" \
    -F "accepts_ads=true" \
    -F "has_company=false"
  echo "\n"
done
