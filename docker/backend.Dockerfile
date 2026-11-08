# =============================================================================
# Backend (NestJS + Prisma) — multi-stage image
# Build context: root repository
#   docker build -f docker/backend.Dockerfile --target runner .
# =============================================================================

FROM docker.io/library/node:22-bookworm-slim AS base

# openssl dibutuhkan Prisma; ca-certificates untuk koneksi keluar.
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV PNPM_HOME=/pnpm \
    PATH=/pnpm:$PATH \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN corepack enable && corepack prepare pnpm@10.24.0 --activate

WORKDIR /app

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
FROM base AS deps

COPY backend/package.json backend/pnpm-lock.yaml backend/pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile

# -----------------------------------------------------------------------------
# Development (dipakai compose.dev.yml)
# Source tetap di-bind mount dari host; node_modules di named volume.
# -----------------------------------------------------------------------------
FROM deps AS dev

COPY backend/ ./

ENV NODE_ENV=development
EXPOSE 3001

CMD ["pnpm", "start:dev"]

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------
FROM deps AS builder

COPY backend/ ./

# Prisma config membaca DATABASE_URL saat generate; nilai dummy cukup.
ENV DATABASE_URL=postgresql://build:build@db:5432/build

RUN pnpm db:generate && pnpm build

# -----------------------------------------------------------------------------
# Production (dipakai compose.prod.yml)
# -----------------------------------------------------------------------------
FROM docker.io/library/node:22-bookworm-slim AS runner

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV NODE_ENV=production \
    PORT=3001

COPY --from=builder --chown=node:node /app/package.json ./package.json
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/prisma ./prisma
COPY --from=builder --chown=node:node /app/prisma.config.ts ./prisma.config.ts

USER node

EXPOSE 3001

# Terapkan migrasi yang sudah ada, lalu jalankan server.
CMD ["sh", "-c", "./node_modules/.bin/prisma migrate deploy && exec node dist/main"]
