# Fuvekonse

[![CI - General Service](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-general.yaml/badge.svg)](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-general.yaml)
[![CI - RBAC Service](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-rbac.yaml/badge.svg)](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-rbac.yaml)
[![CI - SQS Worker](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-sqs-worker.yaml/badge.svg)](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/ci-sqs-worker.yaml)
[![sqs-worker CD](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/cd-sqs-worker.yaml/badge.svg)](https://github.com/SoltuneMontepre/Fuvekonse/actions/workflows/cd-sqs-worker.yaml)

## Overview

Fuvekonse is a Go backend made of three implemented services:

- **general-service**: authentication, users, ticket flows, dealers, conbook submissions, panels, talents, analytics, mail, and AWS integrations.
- **rbac-service**: roles, permissions, and user bans.
- **sqs-worker**: consumes ticket job messages from SQS and applies ticket writes directly to the shared PostgreSQL schema.

Local development uses PostgreSQL, Redis, and LocalStack for S3, SQS, and SES. Production deployment is modeled with Terraform modules for Lambda, API Gateway, S3, SQS, SES, IAM, and networking.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Environment Setup](#environment-setup)
- [Running the Services](#running-the-services)
- [API Routing Notes](#api-routing-notes)
- [Development Flow](#development-flow)
- [LocalStack Guide](#localstack-guide)
- [Production Ticket Queue](#production-ticket-queue)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Required for local backend development:

- **Go 1.25.x** or newer 1.25 patch release
- **Docker Engine** with Docker Compose
- **Task** (`task`) for the one-command dev flow in `Taskfile.yml`
- **Node.js 18+** and npm for Husky git hooks

Optional, depending on what you are doing:

- **AWS CLI** for LocalStack inspection commands
- **Terraform** and **Doppler** for infrastructure and production deployment work

Verify the main tools:

```bash
go version
docker --version
docker compose version
task --version
node --version
npm --version
```

## Quick Start

From the repository root:

```bash
npm i
task dev
```

`task dev` runs the implemented development flow:

1. `go run ./tools/devctl/main.go check`
2. `go run ./tools/devctl/main.go ensure-tools`
3. `go run ./tools/devctl/main.go ensure-env`
4. `docker compose up -d`
5. `go run ./tools/devctl/main.go wait`
6. `go run ./cmd/migrate` from `services/general-service`
7. all three services with Air: `general-service`, `rbac-service`, and `sqs-worker`

Use this path for normal local development. The manual sections below are for debugging or running one part of the stack.

## Environment Setup

### Git hooks

Install the Node dependency so Husky hooks are active:

```bash
npm i
```

The current hooks validate branch names and commit messages.

### Service env files

The repo uses service-local env examples:

- `services/general-service/.env.example`
- `services/rbac-service/.env.example`
- `services/sqs-worker/.env.example`

The recommended setup is:

```bash
task env
```

That command creates or patches all service `.env` files and replaces generated placeholders such as `USER_PII_AES_KEY={{generate:base64:32}}` with safe local defaults.

Manual copy commands:

```bash
cp services/general-service/.env.example services/general-service/.env
cp services/rbac-service/.env.example services/rbac-service/.env
cp services/sqs-worker/.env.example services/sqs-worker/.env
```

PowerShell:

```powershell
Copy-Item .\services\general-service\.env.example .\services\general-service\.env -Force
Copy-Item .\services\rbac-service\.env.example .\services\rbac-service\.env -Force
Copy-Item .\services\sqs-worker\.env.example .\services\sqs-worker\.env -Force
```

Important local defaults:

| Service | Key defaults |
| --- | --- |
| `general-service` | `PORT=8085`, PostgreSQL on `localhost:5432`, Redis on `localhost:6379`, `USE_LOCALSTACK=true`, LocalStack endpoint `http://localhost:4566`, `SQS_QUEUE_URL` for `fuvekon-queue` |
| `rbac-service` | `PORT=8081`, PostgreSQL on `localhost:5432`, `REDIS_URL=redis://localhost:6379/0`, LocalStack-compatible AWS values |
| `sqs-worker` | `SQS_QUEUE_URL` for `fuvekon-queue`, the same `DB_*` values as `general-service`, LocalStack-compatible AWS values |

Do not commit service `.env` files with real secrets.

## Running the Services

### Docker infrastructure

`docker-compose.yml` runs infrastructure only:

- `fuvekon-db`: PostgreSQL 17 on port `5432`
- `fuvekon-cache`: Redis 7 on port `6379`
- `fuvekon-cloud`: LocalStack on port `4566` and edge ports `4510-4559`

Start it:

```bash
docker compose up -d
```

Stop it:

```bash
docker compose down
```

### Database migration

The implemented migration command lives in `general-service`:

```bash
cd services/general-service
go run ./cmd/migrate
```

From the repository root, the task wrapper is:

```bash
task migrate
```

The migration creates and updates the shared tables used by `general-service` and `sqs-worker`.

### Run everything

```bash
task dev
```

This starts Docker infrastructure, prepares env files, migrates the database, and launches all services with Air.

### Run services manually

Use separate terminals from the repository root:

```bash
go run ./tools/devctl/main.go run-air ./services/general-service
go run ./tools/devctl/main.go run-air ./services/rbac-service
go run ./tools/devctl/main.go run-air ./services/sqs-worker
```

Or run Air directly inside a service directory:

```bash
cd services/general-service
air
```

Local service endpoints:

| Component | Local behavior |
| --- | --- |
| `general-service` | HTTP API on `http://localhost:8085`; Swagger at `http://localhost:8085/swagger/index.html` outside production |
| `rbac-service` | HTTP API on `http://localhost:8081`; Swagger at `http://localhost:8081/swagger/index.html` |
| `sqs-worker` | Polling worker only; it does not expose an HTTP port |

## API Routing Notes

Local HTTP routes do not include the Lambda API prefix:

- `general-service`: `http://localhost:8085/v1/...`
- `rbac-service`: `http://localhost:8081/v1/...`

Lambda/API Gateway routes include prefixes:

- `general-service`: `/api/general/...`
- `rbac-service`: `/api/ticket/...` for the current legacy deployment route

`general-service` has an implemented internal endpoint:

```text
POST /internal/jobs/ticket
```

That endpoint processes ticket job payloads inside `general-service`. The current `sqs-worker` implementation does not use that HTTP endpoint; it consumes SQS messages and writes through its own processor/repository layer against the shared PostgreSQL schema.

Ticket write behavior in `general-service`:

- If `SQS_QUEUE_URL` or `SQS_QUEUE` is configured, ticket write requests are queued and the API returns `202 Accepted`.
- If no queue URL is configured, ticket writes are processed synchronously.

Internal API key behavior:

- With local defaults (`USE_LOCALSTACK=true`), `general-service` skips the `X-Internal-Api-Key` middleware check.
- Outside LocalStack mode, the current router middleware requires `X-Internal-Api-Key` to match `INTERNAL_API_KEY`.

## Development Flow

### Branch names

The Husky `pre-commit` hook accepts:

```text
main
revert-*
feat/*
fix/*
docs/*
refactor/*
chore/*
task/*
feature/*
```

### Commit messages

The Husky `commit-msg` hook accepts conventional commits:

```text
feat: add login flow
feat(auth): add Google login
fix(api): handle missing tier
docs: update README
refactor: simplify ticket repository
```

Allowed types are:

```text
feat, fix, chore, docs, style, refactor, test, perf, build, ci
```

`Merge...` and `Revert...` messages are also allowed. Single-word messages such as `wip`, `update`, `fix`, `test`, `changes`, `things`, and `stuff` are rejected.

### CI/CD

Implemented workflows:

- `ci-general.yaml`: builds `services/general-service` on pull requests when that service changes.
- `ci-rbac.yaml`: builds `services/rbac-service` on pull requests when that service changes.
- `ci-sqs-worker.yaml`: builds `services/sqs-worker` on pull requests when that service changes.
- `cd-general.yaml`, `cd-rbac.yaml`, `cd-sqs-worker.yaml`: update the matching AWS Lambda function from `main` when the service or workflow changes.

Build helpers using `task`:

```bash
# Build all services locally using your host Go toolchain (cross-compiles for Linux AWS Lambda)
task build:local

# Build all services using Docker (no local Go toolchain required)
task build:lambda
```

## LocalStack Guide

LocalStack is started by `docker-compose.yml` as `fuvekon-cloud`.

Endpoint:

```text
http://localhost:4566
```

Health endpoint:

```text
http://localhost:4566/_localstack/health
```

The init scripts in `.aws/init` create:

- S3 buckets: `fuvekon-bucket` and `fuvekonse-bucket`
- SQS queue: `fuvekon-queue`
- SES identity: `fuve.vietnam@gmail.com`

Useful commands:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 sqs get-queue-url --queue-name fuvekon-queue
aws --endpoint-url=http://localhost:4566 ses list-identities
```

Queue URL used by local env files:

```text
http://sqs.ap-southeast-1.localhost:4566/000000000000/fuvekon-queue
```

To inspect messages:

```bash
aws --endpoint-url=http://localhost:4566 sqs receive-message \
  --queue-url http://sqs.ap-southeast-1.localhost:4566/000000000000/fuvekon-queue
```

Optional LocalStack Lambda setup is guarded by `ENABLE_LOCALSTACK_LAMBDA=1`. When this variable is not set, `.aws/init/04-iam.sh` and `.aws/init/05-lambdas.sh` intentionally skip IAM and Lambda setup.

## Production Ticket Queue

In production, `general-service` receives ticket write requests. When `SQS_QUEUE` is configured, it publishes ticket job messages to SQS and returns `202 Accepted`.

Current production queue path:

| Component | Role |
| --- | --- |
| `general-service` Lambda | Receives API calls, publishes ticket jobs to SQS when queueing is enabled, and also exposes `POST /internal/jobs/ticket` |
| SQS queue | Created by Terraform as `${project_name}-queue`, with a dead-letter queue and event source mapping |
| `sqs-worker` Lambda | Triggered by SQS batches and applies ticket actions directly to PostgreSQL using the shared ticket schema |

The current worker processor handles these ticket job actions:

```text
purchase
confirm_payment
cancel
update_badge
update_tshirt_size
approve
deny
upgrade_ticket
blacklist_user
unblacklist_user
```

Infrastructure notes:

- Terraform creates Lambda functions for `general-service`, `rbac-service`, and `sqs-worker`.
- API Gateway routes `general-service` under `/api/general`.
- API Gateway routes `rbac-service` under `/api/ticket`.
- Terraform passes the SQS queue URL to `general-service` and `sqs-worker`.
- Terraform also passes `GENERAL_SERVICE_URL` and `INTERNAL_API_KEY` to `sqs-worker`, but the current worker code path processes jobs directly through the database.

Deployment packages are `bootstrap.zip` files under each service directory. CI creates them for changed services, and the CD workflows update the corresponding Lambda function.

## Troubleshooting

### Port already in use

`task dev` checks service ports `8085` and `8081`, plus infrastructure ports `5432`, `6379`, and `4566`.

PowerShell example:

```powershell
netstat -ano | findstr :5432
```

If the port belongs to this compose stack, `devctl` allows it for infrastructure ports. Otherwise stop the conflicting process or run:

```bash
docker compose down
docker compose up -d
```

### Go tools not found

`task tools` installs Air and Swag if they are missing:

```bash
task tools
```

Manual install:

```bash
go install github.com/air-verse/air@latest
go install github.com/swaggo/swag/cmd/swag@latest
```

If the commands are still not found, add Go's bin directory to `PATH`.

PowerShell:

```powershell
$env:PATH += ";$(go env GOPATH)\bin"
```

### Docker containers not starting

```bash
docker compose ps
docker compose logs
docker compose restart fuvekon-db
```

Clean restart:

```bash
docker compose down -v
docker compose up -d
```

### Database connection errors

Check the infrastructure and env values:

```bash
docker compose ps fuvekon-db
docker exec -it fuvekon-db psql -U root -d fuvekon
```

Run the migration:

```bash
task migrate
```

Or manually:

```bash
cd services/general-service
go run ./cmd/migrate
```

### Redis connection errors

```bash
docker exec -it fuvekon-cache redis-cli ping
docker compose logs fuvekon-cache
```

Expected ping response:

```text
PONG
```

### Redis "Possible SECURITY ATTACK" logs

Redis speaks RESP, not HTTP. This log usually means something is sending HTTP traffic to port `6379`.

Use the service health endpoint for HTTP checks:

```text
GET /health/redis
```

Do not point HTTP probes at Redis directly. Use `redis-cli ping`, a TCP socket check, or the API health endpoint.

### LocalStack resources missing

Check LocalStack health and logs:

```bash
curl http://localhost:4566/_localstack/health
docker compose logs fuvekon-cloud
```

Restarting the stack reruns the init scripts:

```bash
docker compose down
docker compose up -d
```

### Hot reload not working

Each service has its own `.air.toml`. Run Air from the service directory or use `devctl run-air` from the repository root:

```bash
go run ./tools/devctl/main.go run-air ./services/general-service
```

If generated docs or build artifacts look stale, stop Air with `Ctrl+C` and start it again.
