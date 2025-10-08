# Booklog 📚

Booklog is a simple Ruby on Rails application for tracking books you've read and building a wishlist of books you want to read.

You can add books with details like title, author, description, rating, and status (read or wishlist). The project is designed to be lightweight, responsive (TailwindCSS), and expandable with features like filters, tags, and reading goals.

## Features

- 📖 Add books you've read with:
  - Title
  - Author
  - Description/Notes
  - Rating (1–5 stars)
  - Status (Read / Wishlist)

- 🌟 Wishlist for books you plan to read
- 🎨 Responsive UI with TailwindCSS
- ⚡ Built-in support for Turbo and Stimulus (Hotwire)

## Tech Stack

- Ruby on Rails 7
- PostgreSQL
- TailwindCSS
- Hotwire (Turbo + Stimulus)
- Importmap (no Node.js or Webpack required)
- Docker + Docker Compose for easy setup

## Getting Started

### Prerequisites

You’ll need **Docker** and **Docker Compose** installed on your system.

Check with:
```bash
docker --version
docker compose version

If you don’t have them, install from:
👉 https://docs.docker.com/get-docker/

🐳 Running with Docker
1️⃣ Clone the repository

  git clone https://github.com/your-username/booklog.git
  cd booklog

2️⃣ Create a .dockerignore file
This keeps your Docker images light and clean:

  echo "log/*
  tmp/*
  node_modules
  .git
  .gitignore
  .DS_Store
  coverage" > .dockerignore

3️⃣ Create a .env file (optional)
This file is only for local development:

  DATABASE_URL=postgres://booklog:mysecretpassword@db:5432/booklog_development
  SECRET_KEY_BASE=your_secret_key_here
  RAILS_ENV=production

4️⃣ Docker Compose configuration
This file should already exist as docker-compose.yml:

  version: '3.9'
  
  services:
    db:
      image: postgres:15
      environment:
        POSTGRES_USER: booklog
        POSTGRES_PASSWORD: mysecretpassword
        POSTGRES_DB: booklog_development
      ports:
        - "5433:5432"
      volumes:
        - booklog_data:/var/lib/postgresql/data
  
    web:
      build: .
      command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"
      volumes:
        - .:/rails
      ports:
        - "3000:3000"
      environment:
        DATABASE_URL: postgres://booklog:mysecretpassword@db:5432/booklog_development
        SECRET_KEY_BASE: your_secret_key_here
        RAILS_MASTER_KEY: your_master_key_here
      depends_on:
        - db
  
  volumes:
    booklog_data:

5️⃣ Build and run containers
  docker compose up --build

The app will be available at:
👉 http://localhost:3000
