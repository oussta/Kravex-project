# Use Debian slim for glibc (fixes SWC native binding issues)
FROM node:20-slim AS builder

# Install build deps for sharp + any native modules
RUN apt-get update && apt-get install -y \
    build-essential \
    libvips-dev \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install deps + force rebuild SWC for linux-x64-gnu (critical fix)
RUN npm ci --legacy-peer-deps \
    && npm rebuild @swc/core --update-binary \
    && npm install @swc/core-linux-x64-gnu --save-optional || true

# Copy app code
COPY . .

# Build admin panel (should now succeed)
RUN npm run build

# Production stage (smaller final image)
FROM node:20-slim

# Same deps for runtime (sharp needs libvips)
RUN apt-get update && apt-get install -y \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built app + node_modules from builder
COPY --from=builder /app /app

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "start"]