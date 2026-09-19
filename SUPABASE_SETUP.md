# BloodBridge – Supabase PostgreSQL Setup Guide

Connect your BloodBridge application to your Supabase project in 3 simple steps.

---

## 1. Create a Free Supabase Project
1. Go to [supabase.com](https://supabase.com) and create a project (e.g. `bloodbridge-db`).
2. Wait a few moments for the database to provision.

---

## 2. Run Database Migration & Seed Script
1. In the Supabase dashboard, open the **SQL Editor** from the left sidebar.
2. Click **New query**.
3. Copy and paste the contents of `supabase/schema.sql` and run it (or paste `supabase/schema.sql` followed by `supabase/seed.sql`).
4. Click **Run** (or `Ctrl + Enter`).
5. All 7 tables (`profiles`, `donors`, `hospitals`, `emergency_requests`, `request_responses`, `notifications`, `zones`), their Row Level Security policies, indexes, and seeded data will be created instantly.

---

## 3. Connect to the Frontend
You have two effortless options:

### Option A: In-App Connection (Immediate – No Build Required)
1. Open BloodBridge in your browser (`http://localhost:8080`).
2. Click the **Supabase** status badge at the top right of the navigation header.
3. Paste your:
   - **Project URL** (from *Project Settings -> API*)
   - **Anon Key** (from *Project Settings -> API*)
4. Click **Save & Connect**.
5. The application will instantly load all data directly from your PostgreSQL tables!

### Option B: Using Environment Variables (`.env`)
If you are bundling or running with Vite/Node:
1. Create a `.env` file in the project root:
   ```env
   VITE_SUPABASE_URL=https://your-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key-here
   ```
2. The frontend automatically detects `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.

---

## Live Features Connected
- **Hospital Portal**:
  - Live donor location sorting based on real coordinates and distance calculations from database.
  - Live **Emergency Broadcast**: creates genuine rows in `emergency_requests` and generates targeted donor notifications.
  - Live **Cascade Expansion**: increments `cascade_km` and notified donor counts in database.
- **Donor Portal**:
  - Live **1-Tap Availability Status**: updates the `donors` table in real-time.
  - Live **Emergency Alerts Toggle**: saves preference directly to PostgreSQL.
  - Live **Alert Responses**: clicking *"I Can Help"*, *"Maybe Later"*, or *"Unavailable"* records the donor response in `request_responses` and updates the notification state.
- **Blood Availability Heatmap**:
  - Fetches real-time inventory breakdowns and facility counts from `zones`.
- **Graceful Fallback**:
  - If keys are not yet configured or if the network is offline, BloodBridge continues to display seeded demo data smoothly with zero visual disruptions.
