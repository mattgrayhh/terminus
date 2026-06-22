# Deploying Terminus on Railway

This fork adds Railway deployment config. Terminus runs as two services that share
one Docker image, backed by Postgres and Redis (Valkey-compatible).

## Architecture on Railway

| Railway service | Source / config            | Role                                  |
| --------------- | -------------------------- | ------------------------------------- |
| `web`           | this repo, `railway.json`  | Puma HTTP server (health check `/up`) |
| `worker`        | this repo, `railway.worker.json` | Sidekiq background jobs          |
| `Postgres`      | Railway database plugin    | provides `DATABASE_URL`               |
| `Redis`         | Railway database plugin    | provides `REDIS_URL` → `KEYVALUE_URL` |

The `web` service uses the image's default `CMD` (Puma). The `worker` service points
its config file to `railway.worker.json`, which overrides the start command to Sidekiq.

## Required environment variables

Set these on **both** the `web` and `worker` services (worker omits `HANAMI_PORT`
and `APP_SETUP`):

| Variable      | Value                                                | Notes |
| ------------- | ---------------------------------------------------- | ----- |
| `DATABASE_URL`| `${{Postgres.DATABASE_URL}}`                         | Railway reference |
| `KEYVALUE_URL`| `${{Redis.REDIS_URL}}`                               | Terminus reads Redis from here |
| `API_URI`     | `${{RAILWAY_PUBLIC_DOMAIN}}` (web) / web's domain    | public host, no scheme |
| `APP_SECRET`  | a fixed 64+ char hex string                          | pin it so sessions survive restarts and match across web/worker |
| `HANAMI_PORT` | `8080` (web only)                                    | Puma has no default; domain target port must match |
| `APP_SETUP`   | `true` (web only)                                    | runs asset compile + DB migrate on boot |

Generate an `APP_SECRET` with `ruby -rsecurerandom -e 'puts SecureRandom.hex(40)'`
or `openssl rand -hex 40`.

Only the `web` service should carry `APP_SETUP=true` so migrations don't race between
the two services.

## First deploy

1. Create a Railway project, add the **Postgres** and **Redis** plugins.
2. Add a service from this repo for `web`; set the env vars above.
3. Generate a public domain for `web` and set its target port to `8080`.
4. Add a second service from this repo for `worker`; set its config path to
   `railway.worker.json` and the shared env vars (no `HANAMI_PORT`/`APP_SETUP`).
5. Deploy. The web service is healthy once `/up` returns 200.
