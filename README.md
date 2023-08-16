# Hackathons Backend

The thing that *soon* powers [hackathons.hackclub.com](https://hackathons.hackclub.com)!

## Development

### Getting Started

1. Make sure you have Docker
   and [Ruby 3.2.2 installed](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-22-04#step-1-install-rbenv-and-dependencies).

2. Clone the repo

   ```sh
   git clone https://github.com/hackclub/hackathons-backend.git
   cd hackathons-backend
   ```

3. Setup credentials

   ```sh
   cp .env.example .env
   ```

   Then, place the master key in `config/master.key`. If you don't have the
   master key, ask [@garyhtou](https://garytou.com) or someone on the Hack Club
   Bank engineering team.

4. Install dependencies

   ```sh
   bundle install
   ```

5. Boot required services (PostgreSQL, etc.)

   ```sh
   docker compose up
   ```

6. Setup the database and run the server

   ```sh
   rails db:setup
   rails server
   ```

7. `(OPTIONAL)` Run background jobs

   We use [Sidekiq](https://sidekiq.org/) to run background jobs. To start the
   Sidekiq server, run:

   ```sh
   bundle exec sidekiq
   ```

The application will now be running at [localhost:3000](http://localhost:3000)!

### Additional Dependencies

Rails 7 (Active Storage) depends on [vips](https://libvips.github.io/libvips/) to process images. You'll want this
dependency installed on your machine. For macs, run:

```sh
brew install vips
```

## Deployment

- Herokou
  - Postgres (Heroku Postgres)
  - Redis (Redis Enterprise Cloud)
- Hetzner
  - Runs the Rails app and Sidekiq
  - Deployed via [MRSK](https://mrsk.dev/)

### MRSK Deployment

All pushes to the `main` branch are automatically deployed by MRSK.
- Environment variables are stored on GitHub and accessed by the GitHub Actions
  when deploying.
- Deployments take roughly 5 minutes to complete.

To use the production Rails Console, you must first have SSH access to the
Hetzner server(s). Then, run:

```sh
mrsk app exec "bin/rails c"
```

---

Application performance monitoring sponsored by <a href="https://appsignal.com/?ref=github:hackclub/hackathons-backend">AppSignal</a>.
