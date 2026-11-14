# --- Étape 1 : dépendances (compilation des modules natifs si besoin) ---
FROM node:22-bookworm-slim AS deps

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force

# --- Étape 2 : image finale légère ---
FROM node:22-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV DATABASE_PATH=/data/alternative_transport.db

COPY --from=deps /app/node_modules ./node_modules
COPY package.json server.js ./

RUN mkdir -p /data

EXPOSE 3000

CMD ["node", "server.js"]
