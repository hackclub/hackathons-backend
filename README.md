# Hackathons Backend

_The thing that powers [hackathons.hackclub.com](https://hackathons.hackclub.com)!_

- 📎 Collecting and reviewing applications to list your hackathon
- 📧 Notifying subscribers of hackathons in their area
- 🌍 Geocoding hackathon and subscription locations into coordinates
- 💾 Archiving hackathon websites for posterity
- 🗓️ Provides a JSON API for the [front-end](https://github.com/hackclub/hackathons)

<table>
<tr>
 <th>📝 Application Form
 <th>📬 Subscription Email
<tr>
 <td><img alt="Screenshot of Hackathons application form" src="https://github.com/hackclub/hackathons-backend/assets/20099646/46cada67-5852-44a4-bdef-a01308448112"/>
 <td><img alt="Screenshot of Hackathons subscription email" src="https://github.com/hackclub/hackathons-backend/assets/20099646/2a3964df-7a3a-4383-94d3-80c53c928bc6"/>
</table>

## Contributing

This app is built with 🛤️ [Ruby on Rails](https://rubyonrails.org) (running [on the edge](https://shopify.engineering/living-on-the-edge-of-rails))
and uses 🥋 [Solid Queue](https://github.com/rails/solid_queue) for running background jobs.

### Getting Started

1. Make sure you have Docker
   and [Ruby 3.3.6 installed](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-22-04#step-1-install-rbenv-and-dependencies).

2. Clone the repo

   ```sh
   git clone https://github.com/hackclub/hackathons-backend.git
   cd hackathons-backend
   ```

3. Install dependencies

   ```sh
   bundle install
   ```

4. Setup the database and run the server

   ```sh
   rails db:prepare
   rails server
   ```

The application will now be running at [localhost:3000](http://localhost:3000)!

### Additional Dependencies

Rails 7 (Active Storage) depends on [vips](https://libvips.github.io/libvips/) to process images. You'll want this
dependency installed on your machine. For macs, run:

```sh
brew install vips
```

## Production Deployment

**Vendors:**

- Heroku
  - Redis (Heroku Data for Redis `premium0`)
- Hetzner
  - Runs the Rails app and Solid Queue (3 vCPU, 4 GB)
  - Deployed via [Kamal](https://kamal-deploy.org)

### Kamal

All pushes to the `main` branch are automatically deployed by Kamal.

- Environment variables are stored on GitHub and accessed by GitHub Actions
  when deploying.
- Deployments take 2-5 minutes to complete.
- After pushing to `main`, please monitor the `CD / Deploy` check for the status
  of the deployment.

### Production Rails Console

We audit the use of the production console with [`console1984`](https://github.com/basecamp/console1984)
and [`audits1984`](https://github.com/basecamp/audits1984).

To use the production console, you must first have SSH access to the Hetzner
server(s). Please ask [`@garyhtou`](https://garytou.com) for access.

Then, run the following locally on your computer:

```sh
bin/console prod
```

### Solid Queue

Solid Queue is used to process background jobs in production. In development, we use
the good old default Active Job Async queue adapter.

To check up on jobs, visit `/admin/jobs` on the production site. You must
be logged in as an admin to access this page.

---

Application performance monitoring sponsored by
<a href="https://appsignal.com/?ref=github:hackclub/hackathons-backend">
AppSignal
</a>.
