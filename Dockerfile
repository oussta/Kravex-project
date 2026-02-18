# Stage 1: Build everything (including /dist)
FROM node:20-slim AS builder

# Install build tools for sharp and any native deps
RUN apt-get update && apt-get install -y \
    build-essential \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create uploads dir early with permissions
RUN mkdir -p public/uploads \
    && chown -R node:node public/uploads \
    && chmod -R 755 public/uploads

# Copy package files for caching
COPY package*.json ./

# Install deps with SWC fix
RUN npm ci --legacy-peer-deps \
    && npm rebuild @swc/core --update-binary \
    && npm install @swc/core-linux-x64-gnu --save-optional || true

# Copy all code
COPY . .

# Set production and BUILD!
ENV NODE_ENV=production
RUN npm run build

# Stage 2: Slim production image
FROM node:20-slim

# Runtime deps for sharp
RUN apt-get update && apt-get install -y \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built code + node_modules from builder
COPY --from=builder /app /app

# Re-create uploads dir in prod stage
RUN mkdir -p public/uploads \
    && chown -R node:node public/uploads \
    && chmod -R 755 public/uploads

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "start"]