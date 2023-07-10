# Hackathons Backend

The thing that *soon* powers [hackathons.hackclub.com](https://hackathons.hackclub.com)!

## Development

### Getting Started

1. Make sure you have Docker installed ([instructions](https://docs.docker.com/get-docker/))

2. Clone the repo

    ```sh
    git clone https://github.com/hackclub/hackathons-backend.git
    cd hackathons-backend
    ```

3. Set up your credentials

   ```sh
   cp .env.example .env
   ```

   Then, place the master key in `/config/master.key`. If you don't have the
   master key, ask [@garyhtou](https://garytou.com) or someone on the Hack Club
   Bank engineering team.

4. Start the server

    ```sh
    docker compose up
    ```

   Upon your first run, you may need to initialize the database. Simply visit
   [localhost:3000](http://localhost:3000) and click the "Create database"
   button, or run `docker compose run --rm web bin/rails db:create`.

The application will now be running at [localhost:3000](http://localhost:3000)
