# Build stage
FROM node:20-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create uploads folder early (fixes permission crashes)
RUN mkdir -p public/uploads \
    && chown -R node:node public/uploads \
    && chmod -R 755 public/uploads

COPY package*.json ./

# Install deps + SWC fix (your override should help)
RUN npm ci --legacy-peer-deps \
    && npm rebuild @swc/core --update-binary || true \
    && npm install @swc/core-linux-x64-gnu --save-optional || true

COPY . .

ENV NODE_ENV=production
RUN npm run build

# Production stage
FROM node:20-slim

RUN apt-get update && apt-get install -y \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app /app

# Re-ensure uploads folder in final image
RUN mkdir -p public/uploads \
    && chown -R node:node public/uploads \
    && chmod -R 755 public/uploads

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "start"]