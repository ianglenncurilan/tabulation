# DAUG 2026 Tabulation System

A comprehensive sports and esports tabulation system built with Vue 3, Pinia, and Supabase. Features real-time score updates, role-based access control, and a modern pixel design aesthetic.

## 🚀 Features

### Public Dashboard

- **Real-time Leaderboard**: Live rankings with top 3 podium display
- **Active Matches**: Live match scores and status
- **Sports Categories**: Support for both traditional sports and esports
- **Responsive Design**: Mobile-friendly interface with modern pixel aesthetics

### Manager Dashboard

- **Account Management**: Create and manage staff/judge accounts
- **Event Control**: Create events, toggle live status, manage categories
- **Tabulation System**: Real-time score management with increment/decrement controls
- **Role-Based Access**: Secure authentication with manager/staff roles

### Technical Features

- **Real-time Updates**: Supabase Realtime for instant score updates
- **Authentication**: Secure login/registration with Supabase Auth
- **Database**: PostgreSQL with Row Level Security (RLS)
- **Modern Stack**: Vue 3 Composition API, Pinia state management, Tailwind CSS v4

## 🛠️ Tech Stack

- **Frontend**: Vue 3 (Composition API), Vue Router, Pinia
- **Backend**: Supabase (PostgreSQL, Auth, Realtime)
- **Styling**: Tailwind CSS v4 with custom pixel design
- **Build Tool**: Vite
- **Deployment**: Ready for Vercel, Netlify, or any static host

## 📋 Database Schema

### Profiles Table

```sql
CREATE TABLE profiles (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('manager', 'staff')),
  full_name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Events Table

```sql
CREATE TABLE events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_name TEXT NOT NULL,
  is_live BOOLEAN DEFAULT FALSE,
  category TEXT NOT NULL CHECK (category IN ('sports', 'esports')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Scores Table

```sql
CREATE TABLE scores (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  team_name TEXT NOT NULL,
  score_value INTEGER NOT NULL DEFAULT 0,
  updated_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🚀 Quick Start

### 1. Clone and Install

```bash
git clone <repository-url>
cd tabulation
npm install
```

### 2. Set Up Supabase

1. Create a new Supabase project
2. Run the SQL schema from `supabase-schema.sql`
3. Enable Realtime on the `events` table
4. Get your project URL and anon key

### 3. Environment Configuration

```bash
cp .env.example .env
```

Add your Supabase credentials:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_APP_NAME=DAUG 2026 Tabulation System
VITE_APP_VERSION=1.0.0
```

### 4. Run Development Server

```bash
npm run dev
```

Visit `http://localhost:5173` to see the application.

## 📱 Access Routes

### Public Routes

- **/** - Public Dashboard (real-time leaderboard)
- **/manager/auth** - Manager login/registration

### Protected Manager Routes

- **/manager/dashboard** - Manager dashboard with tabs:
  - **Manage Accounts**: Create and manage staff accounts
  - **Live Events**: Create events and toggle live status
  - **Tabulation**: Manage scores and rankings

## 🔐 Authentication & Security

### Role-Based Access Control

- **Manager**: Full access to all features, can create staff accounts
- **Staff**: Can view events and manage scores (if implemented)
- **Public**: Can only view the public dashboard

### Security Features

- Row Level Security (RLS) on all database tables
- Secure authentication with Supabase Auth
- Protected routes with navigation guards
- Environment variable configuration

## 🎨 Design System

### Color Palette

- **Primary**: `#f91a10` (Red)
- **Secondary**: `#e46b43` (Orange)
- **Accent**: `#edb195` (Light Orange)
- **Primary Dark**: `#2aa7c9` (Blue)
- **Surface**: `#06628d` (Dark Blue)
- **Background**: `#04284d` (Darkest Blue)

### Design Features

- Modern pixel aesthetic with sharp borders
- Pixel glow animations and effects
- Responsive grid layouts
- Interactive hover states
- Loading states and empty states

## 🔄 Real-time Features

### Live Event Updates

- Events marked as "Live" trigger real-time updates
- Public dashboard instantly reflects live changes
- WebSocket connections via Supabase Realtime

### Score Management

- Increment/decrement score controls
- Real-time ranking updates
- Automatic sorting and podium display

## 📁 Project Structure

```
src/
├── assets/
│   └── main.css              # Global styles and design system
├── components/
│   ├── auth/
│   │   └── ManagerAuth.vue   # Login/registration component
│   ├── manager/
│   │   ├── ManagerDashboard.vue
│   │   └── tabs/
│   │       ├── ManageAccounts.vue
│   │       ├── LiveEvents.vue
│   │       └── TabulationControl.vue
│   └── tabulation/
│       ├── Dashboard.vue     # Public dashboard
│       ├── Sidebar.vue
│       ├── TopRankings.vue
│       └── FullLeaderboardTable.vue
├── router/
│   └── index.js              # Vue Router configuration
├── stores/
│   ├── useAuthStore.js       # Authentication state
│   └── useTournamentStore.js # Tournament data
├── utils/
│   └── supabase.js           # Supabase client and helpers
├── views/
│   └── Dashboard.vue         # Main public view
├── App.vue                   # Root component
└── main.js                   # App initialization
```

## 🚀 Deployment

### Build for Production

```bash
npm run build
```

### Deploy to Vercel

```bash
npm install -g vercel
vercel --prod
```

### Environment Variables

Make sure to set your environment variables in your deployment platform:

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and commit: `git commit -m "Add feature"`
4. Push to branch: `git push origin feature-name`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:

- Check the documentation above
- Review the code comments
- Create an issue in the repository

---

Built with ❤️ for DAUG 2026 Sports & Esports Tabulation
