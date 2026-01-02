# Quick Setup Guide

## Prerequisites
- Elixir 1.14+ and Erlang/OTP 25+
- PostgreSQL 12+ (make sure it's running)
- Node.js 18+ and npm

## Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install Elixir dependencies:**
   ```bash
   mix deps.get
   ```

3. **Create the database:**
   ```bash
   mix ecto.create
   ```

4. **Run migrations:**
   ```bash
   mix ecto.migrate
   ```

5. **Start the Phoenix server:**
   ```bash
   mix phx.server
   ```
   
   The API will be available at `http://localhost:4000`

## Frontend Setup

Open a **new terminal window** (keep backend running):

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install npm dependencies:**
   ```bash
   npm install
   ```

3. **Start the React development server:**
   ```bash
   npm start
   ```
   
   The frontend will be available at `http://localhost:3000`

## Running Tests (Backend)

In the backend directory:
```bash
mix test
```

## Troubleshooting

### PostgreSQL Connection Issues
If `mix ecto.create` fails, make sure:
- PostgreSQL is running
- Default credentials are correct (username: `postgres`, password: `postgres`)
- If using different credentials, update `backend/config/dev.exs`

### Port Already in Use
- Backend runs on port 4000 by default
- Frontend runs on port 3000 by default
- Change ports in config files if needed

