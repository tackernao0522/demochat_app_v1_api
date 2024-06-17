# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.

# The `threads` method setting takes two numbers: a minimum and maximum.

# Any libraries that use thread pools should be configured to match

# the maximum value specified for Puma. Default is set to 5 threads for minimum

# and maximum; this matches the default thread size of Active Record.

#

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before

# terminating a worker in development environments.

#

worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.

#

port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.

#

environment ENV.fetch('RAILS_ENV', 'development')

# Specifies the `pidfile` that Puma will use.

pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the number of `workers` to boot in clustered mode.

# Workers are forked web server processes. If using threads and workers together

# the concurrency of the application would be max `threads` \* `workers`.

# Workers do not work on JRuby or Windows (both of which do not support

# processes).

#

# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.

# This directive tells Puma to first boot the application and load code

# before forking the application. This takes advantage of Copy On Write

# process behavior so workers use less memory.

#

# preload_app!

# Allow puma to be restarted by `bin/rails restart` command.

plugin :tmp_restart

(base) groovy@GroovynoAir demochat_app % flyctl postgres create --name demochat-db --region nrt
automatically selected personal organization: cheap_trick_magic@yahoo.co.jp
? Select configuration: Development - Single node, 1x shared CPU, 256MB RAM, 1GB disk
? Scale single node pg to zero after one hour? No
Creating postgres cluster in organization personal
Creating app...
Setting secrets on app demochat-db...
Provisioning 1 of 1 machines with image flyio/postgres-flex:15.6@sha256:92917e5770cef6666dddbf17061c2f95b9e19b8155be9a8ce8c35e09e5381167
Waiting for machine to start...
Machine 784e666f244d08 is created
==> Monitoring health checks
Waiting for 784e666f244d08 to become healthy (started, 3/3)

Postgres cluster demochat-db created
Username: postgres
Password: Byvuntsm2myNzTt
Hostname: demochat-db.internal
Flycast: fdaa:9:58a5:0:1::3
Proxy port: 5432
Postgres port: 5433
Connection string: postgres://postgres:Byvuntsm2myNzTt@demochat-db.flycast:5432

Save your credentials in a secure place -- you won't be able to see them again!

Connect to postgres
Any app within the cheap_trick_magic@yahoo.co.jp organization can connect to this Postgres using the above connection string

Now that you've set up Postgres, here's what you need to understand: https://fly.io/docs/postgres/getting-started/what-you-should-know/
(base) groovy@GroovynoAir demochat_app %

flyctl ssh console -a demochat-api

psql -h demochat-db.internal -U postgres -p 5432 で入れる

fly logs -a demochat-api

rails db:migrate:status

docker compose -f docker-compose.dev.yml --env-file .env.development run --rm api bundle exec rails db:migrate

DELETE FROM users;

ALTER SEQUENCE users_id_seq RESTART WITH 1;

postgres=# \l
List of databases
Name | Owner | Encoding | Locale Provider | Collate | Ctype | ICU Locale | ICU Rules | Access privileges  
----------------+----------+----------+-----------------+------------+------------+------------+-----------+-----------------------
app_production | postgres | UTF8 | libc | en_US.utf8 | en_US.utf8 | | |
postgres | postgres | UTF8 | libc | en_US.utf8 | en_US.utf8 | | |
repmgr | repmgr | UTF8 | libc | en_US.utf8 | en_US.utf8 | | |
template0 | postgres | UTF8 | libc | en_US.utf8 | en_US.utf8 | | | =c/postgres +
| | | | | | | | postgres=CTc/postgres
template1 | postgres | UTF8 | libc | en_US.utf8 | en_US.utf8 | | | =c/postgres +
| | | | | | | | postgres=CTc/postgres
(5 rows)

postgres=# \c app_production
psql (16.3, server 15.6 (Debian 15.6-1.pgdg120+2))
You are now connected to database "app_production" as user "postgres".
app_production=# \dt
List of relations
Schema | Name | Type | Owner  
--------+----------------------+-------+----------
public | ar_internal_metadata | table | postgres
public | schema_migrations | table | postgres
public | users | table | postgres
(3 rows)

app_production=#

```
flyctl secrets set \
POSTGRES_USER=postgres \
POSTGRES_PASSWORD=Byvuntsm2myNzTt \
POSTGRES_DB=app_production \
DATABASE_URL=postgres://postgres:Byvuntsm2myNzTt@demochat-db.flycast:5432/app_production \
API_DOMAIN=https://demochat-api.fly.dev \
BASE_URL=https://demochat-api.fly.dev
```

docker network prune
docker compose -f docker-compose.dev.yml up
docker compose -f docker-compose.dev.yml down

SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'app_production';

DROP DATABASE app_production;

rails db:create
rails db:migrate
