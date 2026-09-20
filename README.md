# BloodBridge

> **Smart Emergency Blood Donor Matching & Hospital Dispatch Platform**

BloodBridge is a mission-critical emergency blood donor matching platform designed to connect hospitals, blood banks, and voluntary donors with speed, transparency, and geographic precision.

---

## 🚀 Key Features

- **⚡ Emergency Broadcast Engine**: Instant multi-stage donor notifications with cascade distance expansion.
- **🎯 Intelligent Donor Discovery & Scoring**: Transparent matching algorithm considering distance, blood group compatibility, donation readiness, and response history.
- **🏥 Hospital Dispatch Dashboard**: Live donor response tracking, distance matrix, and emergency status management.
- **🩸 Donor Portal**: 1-tap availability status, real-time emergency alert acceptance, and profile management.
- **🗺️ Regional Blood Availability Heatmap**: Live inventory breakdowns and hospital shortage monitoring.
- **☁️ Supabase Cloud Integration**: Real-time PostgreSQL database with Row Level Security (RLS) and instant fallback to offline demo data.

---

## 🛠️ Tech Stack

- **Frontend**: Vanilla HTML5, CSS3 (Modern Glassmorphic Dark UI), JavaScript (ES6+)
- **Database / Backend**: Supabase (PostgreSQL, Realtime, Row Level Security)
- **Typography & Icons**: Google Fonts (Inter), Native SVG icons
- **Zero Dependencies**: Runs instantly in any modern browser without a complex build pipeline.

---

## 💻 Quick Start & Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/vnaveen0777-svg/BloodBridge.git
cd BloodBridge
```

### 2. Run Locally

#### Option A: Python Built-in Server (Recommended)
```bash
python3 -m http.server 3000
```
Open your browser and navigate to **`http://localhost:3000`**.

#### Option B: Node.js (npx serve)
```bash
npx serve . -p 3000
```

#### Option C: Direct File Access
You can also directly open `index.html` in any modern web browser (Google Chrome, Firefox, Safari, Edge).

---

## 🗄️ Database Setup (Optional - Supabase Integration)

BloodBridge works out of the box with rich demo data. To connect your live Supabase cloud database:

1. Create a free project at [supabase.com](https://supabase.com).
2. Open the **SQL Editor** in your Supabase dashboard.
3. Run `supabase/schema.sql` to initialize tables, enums, RLS policies, and triggers.
4. Run `supabase/seed.sql` to populate sample hospitals, donors, emergency requests, and zones.
5. In the BloodBridge web UI, click the **Supabase** badge in the navigation bar, input your **Project URL** and **Anon Key**, and click **Save & Connect**.
   *(Alternatively, copy `.env.example` to `.env` and fill in your keys).*

For more details, see [SUPABASE_SETUP.md](SUPABASE_SETUP.md).

---

## 📁 Project Structure

```
my-project/
├── .env.example         # Sample environment configuration
├── .gitignore           # Git ignore rules for secrets and build files
├── index.html           # Core application (UI, styles, and matching logic)
├── README.md            # Project documentation and quick start guide
├── SUPABASE_SETUP.md    # Detailed database schema and setup instructions
└── supabase/
    ├── schema.sql       # PostgreSQL DDL, schema, RLS policies, functions
    └── seed.sql         # Seed data for donors, hospitals, and emergency requests
```

---

## 🔒 Security & Privacy

- No API keys or credentials are hardcoded or tracked in Git.
- `.env` files and local secrets are excluded via `.gitignore`.
- Database access is protected by Supabase Row Level Security (RLS).

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
