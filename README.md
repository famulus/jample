# Jample API + Frontend

A full-stack Dockerized development environment for **Rails 7.1 (API mode)** and **React (Vite)**, backed by **PostgreSQL**.  
This setup provides hot-reloading for both the Rails API and the React frontend, while remaining production-deployable with minimal changes.

---

## 🧱 Project Overview

| Service | Description | Port |
|----------|--------------|------|
| `web` | Ruby on Rails 7.1 API | `3000` |
| `frontend` | React + Vite app | `5173` |
| `db` | PostgreSQL 15 | `5432` |

---

## 🚀 Prerequisites

Make sure you have these installed on your local machine:

- **Docker** ≥ 20.x  
- **Docker Compose** ≥ 2.x  
- **Git**
- Optional: **VS Code** with Docker and Ruby extensions

---

## ⚙️ Environment Setup

### 1. Clone the repository

```bash
git clone https://github.com/famulus/jample.git
cd jample
```

### 2. Environment variables

Create a `.env` file at the project root (same level as `docker-compose.yml`):

```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=jample_development
RAILS_ENV=development
VITE_API_URL=http://localhost:3000
```

*(If you change credentials, update them in `config/database.yml` as well.)*

---

## 🧩 Build and Run

### 1. Build images
Run once (or after Dockerfile/Gemfile/package.json changes):
```bash
docker compose build
```

### 2. Start the full stack
```bash
docker compose up
```

- Rails API: [http://localhost:3000](http://localhost:3000)  
- React frontend: [http://localhost:5173](http://localhost:5173)

Both support live reload in development mode.

---

## 💾 Database Setup

Once containers are up:
```bash
docker compose exec web bash -lc 'bin/rails db:setup'
```

If you reset the database:
```bash
docker compose exec web bash -lc 'bin/rails db:drop db:create db:migrate'
```

---

## 🧪 Running Tests

```bash
docker compose exec web bash -lc 'bundle exec rspec'
```

---

## 🧰 Useful Commands

### Rails

```bash
docker compose exec web bash                # open a shell
docker compose exec web rails c             # open Rails console
docker compose exec web bash -lc 'rails s'  # run server manually
docker compose logs -f web                  # tail Rails logs
```

### Frontend

```bash
docker compose exec frontend sh             # open frontend shell
docker compose exec frontend npm run dev    # run Vite dev server manually
docker compose logs -f frontend             # tail Vite logs
```

---

## 🐞 Debugging Rails inside Docker

### Quick breakpoints
Insert in your Rails code:
```ruby
binding.break
```

Then attach interactively:
```bash
docker compose exec -it web bash -lc 'bundle exec rails s -b 0.0.0.0 -p 3000'
```

### Remote debugger
Expose port `12345` in `docker-compose.yml`:
```yaml
ports:
  - "12345:12345"
```
Then start the server with:
```bash
docker compose exec web bash -lc 'rdbg --open --port 12345 -- bundle exec rails s'
```
Attach from your host:
```bash
rdbg -A tcp://localhost:12345
```

---

## ⚡️ Common Tasks

| Task | Command |
|------|----------|
| Start all services | `docker compose up` |
| Stop services | `docker compose down` |
| Rebuild containers | `docker compose up --build` |
| Restart Rails only | `docker compose restart web` |
| Tail all logs | `docker compose logs -f` |
| Clean up unused images | `docker system prune -af` |

---

## 🧹 Troubleshooting

- **Port 3000 already in use:**  
  ```bash
  lsof -nP -iTCP:3000 -sTCP:LISTEN
  ```
  Kill the process or change the port in `docker-compose.yml`.

- **Frontend not reachable:**  
  Check that `VITE_API_URL` matches your Rails service hostname (`http://localhost:3000` in dev).

- **Gem or package added but not picked up:**  
  ```bash
  docker compose build web      # for Gemfile updates
  docker compose build frontend # for npm/package.json updates
  ```

---

## 🧾 License

MIT © 2025 Your Name  
Feel free to modify, extend, and adapt this setup for your own projects.
