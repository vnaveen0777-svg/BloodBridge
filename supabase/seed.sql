-- ==============================================================================
-- BloodBridge Supabase Seed Data
-- ==============================================================================

-- Clear existing data if resetting
TRUNCATE TABLE public.notifications, public.request_responses, public.emergency_requests, public.donors, public.hospitals, public.zones CASCADE;

-- 1. Seed Hospitals & Blood Banks
INSERT INTO public.hospitals (id, name, type, trust_score, approx_area, lat, lng, phone, emergency_hotline, operating_hours)
VALUES
('h1', 'St. Jude Metropolitan Trauma & Cardiac Center', 'Hospital', 99, 'Central City Medical District', 12.973, 77.599, '+91 80 2294 5000', '1800-BLOOD-HELP', '24/7 Emergency Operation'),
('h2', 'City Care Emergency Institute', 'Hospital', 97, 'Richmond Medical Enclave', 12.964, 77.591, '+91 80 4112 3300', '+91 99800 11223', '24/7 Emergency Wing'),
('b1', 'Apex Red Cross Regional Blood Bank', 'Blood Bank', 100, 'MG Road Blood Services', 12.977, 77.605, '+91 80 2558 7766', '+91 98450 44556', '24/7 Processing & Dispatch'),
('b2', 'Lions Lifeline Blood Bank & Apheresis Center', 'Blood Bank', 98, 'Jayanagar Circle', 12.942, 77.589, '+91 80 2663 8899', '+91 97400 99887', '24 Hours Apheresis Available'),
('h3', 'Koramangala Specialty Pediatric & Maternity Hospital', 'Hospital', 95, 'Koramangala 5th Block', 12.934, 77.620, '+91 80 4900 1200', '+91 99160 33445', '24 Hours Emergency NICU/PICU')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  type = EXCLUDED.type,
  trust_score = EXCLUDED.trust_score,
  approx_area = EXCLUDED.approx_area,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  phone = EXCLUDED.phone,
  emergency_hotline = EXCLUDED.emergency_hotline,
  operating_hours = EXCLUDED.operating_hours;

-- 2. Seed Donors
INSERT INTO public.donors (id, name, phone, email, blood_group, availability, approx_area, lat, lng, last_donation_date, total_donations, emergency_responses, response_rate, avg_response_time_min, emergency_alerts_enabled, is_verified, is_medically_eligible, badges)
VALUES
('d1', 'Sarah Jenkins', '+91 98450 11990', 'sarah.jenkins@mail.com', 'O-', 'Available for Emergency', 'Indiranagar Core', 12.9716, 77.5946, '2026-06-12', 8, 6, 94, 4, true, true, true, '[{"title":"Universal LifeSaver","desc":"O- Universal donor with 5+ emergency responses","icon":"🌟"},{"title":"Speedy Hero","desc":"Avg response time under 5 mins","icon":"⚡"}]'::jsonb),
('d2', 'David Chen', '+91 98123 45678', 'david.chen@mail.com', 'O+', 'Available for Emergency', 'MG Road North', 12.9780, 77.6010, '2026-05-20', 12, 9, 98, 3, true, true, true, '[{"title":"Community Pillar","desc":"10+ lifetime donations","icon":"🏆"},{"title":"Rapid Responder","desc":"Under 3 mins 5 times","icon":"🩸"}]'::jsonb),
('d3', 'Amina Al-Fassi', '+91 97410 88231', 'amina.alfassi@mail.com', 'A+', 'Available Today', 'Richmond Town', 12.9650, 77.5850, '2026-07-01', 4, 3, 85, 8, true, true, true, '[{"title":"Dedicated Supporter","desc":"Consistently available on weekends","icon":"❤️"}]'::jsonb),
('d4', 'Marcus Brody', '+91 99001 23456', 'marcus.brody@mail.com', 'B+', 'Available for Emergency', 'Ulsoor Lake Hub', 12.9820, 77.6100, '2026-04-18', 6, 5, 91, 5, true, true, true, '[{"title":"Emergency Guard","desc":"Available 24/7 on call","icon":"🛡️"}]'::jsonb),
('d5', 'Elena Rostova', '+91 98455 67890', 'elena.rostova@mail.com', 'AB-', 'Available for Emergency', 'Koramangala Sector 1', 12.9550, 77.5920, '2026-05-02', 7, 6, 96, 4, true, true, true, '[{"title":"Rare Blood Hero","desc":"Rare AB- donor with plasma specialty","icon":"💎"}]'::jsonb),
('d6', 'Rohan Sharma', '+91 99887 76655', 'rohan.sharma@mail.com', 'O+', 'Available Today', 'Koramangala 4th Block', 12.9350, 77.6150, '2026-06-25', 3, 2, 80, 12, true, true, true, '[{"title":"Rising Star","desc":"Active contributor","icon":"⭐"}]'::jsonb),
('d7', 'Priya Nair', '+91 98801 23451', 'priya.nair@mail.com', 'A-', 'Available for Emergency', 'Malleshwaram Central', 12.9900, 77.5700, '2026-05-15', 9, 7, 92, 6, true, true, true, '[{"title":"Golden Guardian","desc":"9+ life-saving actions","icon":"🎖️"}]'::jsonb),
('d8', 'Tariq Mansoor', '+91 97422 33445', 'tariq.mansoor@mail.com', 'B-', 'Available Today', 'Jayanagar 4th Block', 12.9400, 77.5800, '2026-06-01', 5, 4, 88, 7, true, true, true, '[{"title":"Reliable Neighbor","desc":"Prompt community assistance","icon":"🤝"}]'::jsonb),
('d9', 'Kavita Sundaram', '+91 99160 55443', 'kavita.sundaram@mail.com', 'AB+', 'Available for Emergency', 'HAL Old Airport Rd', 12.9750, 77.6400, '2026-06-18', 11, 10, 99, 2, true, true, true, '[{"title":"Plasma Champion","desc":"Universal plasma donor","icon":"✨"}]'::jsonb),
('d10', 'Vikram Mehta', '+91 98451 99882', 'vikram.mehta@mail.com', 'O-', 'Available Today', 'Yeshwanthpur Gate', 13.0100, 77.5550, '2026-05-28', 4, 3, 87, 9, true, true, true, '[{"title":"Universal Hero","desc":"O- donor always ready","icon":"🌟"}]'::jsonb),
('d11', 'Rachel Varghese', '+91 99002 11223', 'rachel.varghese@mail.com', 'O+', 'Available for Emergency', 'Shanthi Nagar', 12.9600, 77.6050, '2026-04-10', 15, 12, 97, 3, true, true, true, '[{"title":"Legendary Donor","desc":"15+ lifetime donations","icon":"👑"}]'::jsonb),
('d12', 'Zackariah Paul', '+91 97430 44556', 'zackariah.paul@mail.com', 'A+', 'Available Later', 'HSR Layout Sector 2', 12.9200, 77.6200, '2026-08-15', 3, 1, 70, 20, true, true, false, '[{"title":"First Steps","desc":"Completed initial donations","icon":"🌱"}]'::jsonb),
('d13', 'Deepak Rao', '+91 98860 77889', 'deepak.rao@mail.com', 'B+', 'Unavailable', 'JP Nagar 2nd Phase', 12.9100, 77.5850, '2026-03-01', 5, 4, 80, 15, false, false, true, '[]'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  phone = EXCLUDED.phone,
  email = EXCLUDED.email,
  blood_group = EXCLUDED.blood_group,
  availability = EXCLUDED.availability,
  approx_area = EXCLUDED.approx_area,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  last_donation_date = EXCLUDED.last_donation_date,
  total_donations = EXCLUDED.total_donations,
  emergency_responses = EXCLUDED.emergency_responses,
  response_rate = EXCLUDED.response_rate,
  avg_response_time_min = EXCLUDED.avg_response_time_min,
  emergency_alerts_enabled = EXCLUDED.emergency_alerts_enabled,
  is_verified = EXCLUDED.is_verified,
  is_medically_eligible = EXCLUDED.is_medically_eligible,
  badges = EXCLUDED.badges;

-- 3. Seed Emergency Requests
INSERT INTO public.emergency_requests (id, hospital_id, hospital_name, hospital_lat, hospital_lng, blood_group, component, units_needed, urgency, status, cascade_km, notified, responses, confirmed, note)
VALUES
('R1', 'h1', 'St. Jude Metropolitan Trauma Center', 12.973, 77.599, 'O-', 'Red Blood Cells (RBC)', 2, 'Critical', 'Cascade Stage 1', 5, 8, 4, 2, 'Emergency polytrauma surgery in OT-3. Immediate RBC replacement needed.'),
('R2', 'h3', 'Koramangala Specialty Hospital', 12.934, 77.620, 'B+', 'Platelets', 3, 'Urgent', 'Cascade Stage 2', 10, 14, 7, 3, 'Severe thrombocytopenia. Single Donor Platelet request.')
ON CONFLICT (id) DO UPDATE SET
  hospital_name = EXCLUDED.hospital_name,
  blood_group = EXCLUDED.blood_group,
  component = EXCLUDED.component,
  units_needed = EXCLUDED.units_needed,
  urgency = EXCLUDED.urgency,
  status = EXCLUDED.status,
  cascade_km = EXCLUDED.cascade_km,
  notified = EXCLUDED.notified,
  responses = EXCLUDED.responses,
  confirmed = EXCLUDED.confirmed,
  note = EXCLUDED.note;

-- 4. Seed Notifications
INSERT INTO public.notifications (id, user_id, request_id, title, message, type, dist_km, is_read, action_taken, created_at)
VALUES
('n1', 'd1', 'R1', 'CRITICAL EMERGENCY MATCH (O-)', 'St. Jude Trauma Center urgently requires 2 Units of RBC. You are approximately 3.2 km away.', 'emergency_alert', 3.2, false, NULL, now() - INTERVAL '10 minutes'),
('n2', 'd1', NULL, 'Donation Eligibility Reminder', 'You have been eligible for whole blood donation since August 15. Your readiness saves lives!', 'info', NULL, true, NULL, now() - INTERVAL '1 day')
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  message = EXCLUDED.message,
  type = EXCLUDED.type,
  dist_km = EXCLUDED.dist_km,
  is_read = EXCLUDED.is_read,
  action_taken = EXCLUDED.action_taken;

-- 5. Seed Zones (Heatmap Inventory)
INSERT INTO public.zones (id, zone_name, density_level, available_units, active_emergency_donors, verified_facilities_count)
VALUES
('z1', 'Central / MG Road', 'High', '{"O+":21,"O-":3,"A+":28,"A-":8,"B+":34,"B-":9,"AB+":19,"AB-":4}'::jsonb, 14, 3),
('z2', 'Indiranagar / Halasuru', 'High', '{"O+":16,"O-":2,"A+":22,"A-":5,"B+":26,"B-":6,"AB+":14,"AB-":2}'::jsonb, 11, 2),
('z3', 'Koramangala Tech Corridor', 'Moderate', '{"O+":12,"O-":1,"A+":15,"A-":3,"B+":19,"B-":4,"AB+":10,"AB-":1}'::jsonb, 9, 2),
('z4', 'Jayanagar / South Metro', 'Moderate', '{"O+":15,"O-":2,"A+":19,"A-":4,"B+":22,"B-":5,"AB+":11,"AB-":3}'::jsonb, 8, 2),
('z5', 'North Metro / Malleshwaram', 'Low', '{"O+":8,"O-":0,"A+":10,"A-":1,"B+":12,"B-":2,"AB+":6,"AB-":0}'::jsonb, 4, 1)
ON CONFLICT (id) DO UPDATE SET
  zone_name = EXCLUDED.zone_name,
  density_level = EXCLUDED.density_level,
  available_units = EXCLUDED.available_units,
  active_emergency_donors = EXCLUDED.active_emergency_donors,
  verified_facilities_count = EXCLUDED.verified_facilities_count;
