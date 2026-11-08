# =============================================================================
# Frontend (Next.js + Bun) — multi-stage image
# Build context: root repository
#   docker build -f docker/frontend.Dockerfile --target runner .
# =============================================================================

FROM docker.io/oven/bun:1.4 AS base

WORKDIR /app

ENV NEXT_TELEMETRY_DISABLED=1

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
FROM base AS deps

COPY frontend/package.json frontend/bun.lock ./
RUN bun install --frozen-lockfile

# -----------------------------------------------------------------------------
# Development (dipakai compose.dev.yml)
# Source tetap di-bind mount dari host; node_modules & .next di named volume.
# -----------------------------------------------------------------------------
FROM deps AS dev

COPY frontend/ ./

ENV NODE_ENV=development
EXPOSE 3000

CMD ["bun", "run", "dev"]

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------
FROM deps AS builder

COPY frontend/ ./

# NEXT_PUBLIC_* dibaca saat build dan ditanam ke bundle client.
ARG NEXT_PUBLIC_NEST_API_URL=http://localhost:3001
ENV NEXT_PUBLIC_NEST_API_URL=$NEXT_PUBLIC_NEST_API_URL

RUN bun run build

# -----------------------------------------------------------------------------
# Production (dipakai compose.prod.yml)
# -----------------------------------------------------------------------------
FROM docker.io/oven/bun:1.4-slim AS runner

WORKDIR /app

ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000 \
    HOSTNAME=0.0.0.0

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.ts ./next.config.ts
COPY --from=builder /app/tsconfig.json ./tsconfig.json
COPY --from=deps /app/node_modules ./node_modules

EXPOSE 3000

CMD ["bun", "run", "start"]
