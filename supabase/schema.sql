-- ==============================================================================
-- BloodBridge Supabase PostgreSQL Database Schema
-- Version: 1.0.0
-- ==============================================================================

-- 1. Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create User Profiles table (maps to Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('donor', 'hospital')),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 3. Create Donors table
CREATE TABLE IF NOT EXISTS public.donors (
    id TEXT PRIMARY KEY, -- Supports demo IDs ('d1', 'd2') or auth.users UUIDs
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT NOT NULL,
    blood_group TEXT NOT NULL CHECK (blood_group IN ('O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+')),
    availability TEXT NOT NULL DEFAULT 'Available for Emergency' CHECK (availability IN ('Available for Emergency', 'Available Today', 'Available Later', 'Unavailable')),
    approx_area TEXT NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    last_donation_date DATE DEFAULT CURRENT_DATE - INTERVAL '60 days',
    total_donations INTEGER NOT NULL DEFAULT 0,
    emergency_responses INTEGER NOT NULL DEFAULT 0,
    response_rate INTEGER NOT NULL DEFAULT 90,
    avg_response_time_min INTEGER NOT NULL DEFAULT 5,
    emergency_alerts_enabled BOOLEAN NOT NULL DEFAULT true,
    is_verified BOOLEAN NOT NULL DEFAULT true,
    is_medically_eligible BOOLEAN NOT NULL DEFAULT true,
    badges JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 4. Create Hospitals & Blood Banks table
CREATE TABLE IF NOT EXISTS public.hospitals (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Hospital', 'Blood Bank')),
    trust_score INTEGER NOT NULL DEFAULT 95 CHECK (trust_score BETWEEN 0 AND 100),
    approx_area TEXT NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    phone TEXT NOT NULL,
    emergency_hotline TEXT NOT NULL,
    operating_hours TEXT NOT NULL DEFAULT '24/7 Emergency Operation',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 5. Create Emergency Blood Requests table
CREATE TABLE IF NOT EXISTS public.emergency_requests (
    id TEXT PRIMARY KEY,
    hospital_id TEXT REFERENCES public.hospitals(id) ON DELETE SET NULL,
    hospital_name TEXT NOT NULL,
    hospital_lat DOUBLE PRECISION NOT NULL,
    hospital_lng DOUBLE PRECISION NOT NULL,
    blood_group TEXT NOT NULL CHECK (blood_group IN ('O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+')),
    component TEXT NOT NULL,
    units_needed INTEGER NOT NULL DEFAULT 1,
    urgency TEXT NOT NULL DEFAULT 'Critical' CHECK (urgency IN ('Critical', 'Urgent', 'Standard')),
    status TEXT NOT NULL DEFAULT 'Cascade Stage 1',
    cascade_km INTEGER NOT NULL DEFAULT 5,
    notified INTEGER NOT NULL DEFAULT 0,
    responses INTEGER NOT NULL DEFAULT 0,
    confirmed INTEGER NOT NULL DEFAULT 0,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 6. Create Donor Responses table
CREATE TABLE IF NOT EXISTS public.request_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id TEXT NOT NULL REFERENCES public.emergency_requests(id) ON DELETE CASCADE,
    donor_id TEXT NOT NULL REFERENCES public.donors(id) ON DELETE CASCADE,
    action TEXT NOT NULL CHECK (action IN ('can_help', 'maybe_later', 'declined')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE (request_id, donor_id)
);

-- 7. Create Notifications / Alerts table
CREATE TABLE IF NOT EXISTS public.notifications (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL, -- donor id ('d1') or auth.users UUID or 'all'
    request_id TEXT REFERENCES public.emergency_requests(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'emergency_alert' CHECK (type IN ('emergency_alert', 'info', 'milestone')),
    dist_km NUMERIC(5,2),
    is_read BOOLEAN NOT NULL DEFAULT false,
    action_taken TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 8. Create Inventory Zones table (City heatmap)
CREATE TABLE IF NOT EXISTS public.zones (
    id TEXT PRIMARY KEY,
    zone_name TEXT NOT NULL,
    density_level TEXT NOT NULL CHECK (density_level IN ('High', 'Moderate', 'Low')),
    available_units JSONB NOT NULL DEFAULT '{}'::jsonb,
    active_emergency_donors INTEGER NOT NULL DEFAULT 0,
    verified_facilities_count INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ==============================================================================
-- Indexes for High Performance Queries
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_donors_blood_group ON public.donors(blood_group);
CREATE INDEX IF NOT EXISTS idx_donors_availability ON public.donors(availability);
CREATE INDEX IF NOT EXISTS idx_emergency_requests_status ON public.emergency_requests(status);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_request_responses_request_id ON public.request_responses(request_id);

-- ==============================================================================
-- Row Level Security (RLS) Setup
-- ==============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emergency_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.request_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zones ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can view their own profile, or view minimal info
CREATE POLICY "Users can read own profile" 
ON public.profiles FOR SELECT 
USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
ON public.profiles FOR UPDATE 
USING (auth.uid() = id);

-- Donors:
CREATE POLICY "Allow reading donors for matching" 
ON public.donors FOR SELECT 
USING (true);

CREATE POLICY "Donors can update own record" 
ON public.donors FOR UPDATE 
USING (
    id = (SELECT auth.uid()::text) 
    OR user_id = auth.uid() 
    OR auth.role() = 'anon' -- Allows public anon client updates during demo mode
);

CREATE POLICY "Allow inserting donor profiles" 
ON public.donors FOR INSERT 
WITH CHECK (true);

-- Hospitals:
CREATE POLICY "Allow reading hospitals" 
ON public.hospitals FOR SELECT 
USING (true);

-- Emergency Requests:
CREATE POLICY "Allow reading emergency requests" 
ON public.emergency_requests FOR SELECT 
USING (true);

CREATE POLICY "Allow creating emergency requests" 
ON public.emergency_requests FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Allow updating emergency requests" 
ON public.emergency_requests FOR UPDATE 
USING (true);

-- Request Responses:
CREATE POLICY "Allow reading responses" 
ON public.request_responses FOR SELECT 
USING (true);

CREATE POLICY "Allow donors to submit responses" 
ON public.request_responses FOR INSERT 
WITH CHECK (true);

-- Notifications:
CREATE POLICY "Allow users to read their own notifications" 
ON public.notifications FOR SELECT 
USING (true);

CREATE POLICY "Allow users to update their notifications" 
ON public.notifications FOR UPDATE 
USING (true);

CREATE POLICY "Allow creating notifications" 
ON public.notifications FOR INSERT 
WITH CHECK (true);

-- Zones:
CREATE POLICY "Allow reading zones" 
ON public.zones FOR SELECT 
USING (true);

-- ==============================================================================
-- Realtime Publication
-- ==============================================================================
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND tablename = 'emergency_requests'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.emergency_requests;
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND tablename = 'notifications'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' AND tablename = 'donors'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.donors;
    END IF;
END $$;
