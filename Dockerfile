# Use Debian-based Node (fixes SWC binding issues on Railway)
FROM node:20-slim

# Install dependencies needed for sharp (image processing in Strapi) and build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install deps (use ci for clean install)
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copy the rest of your app
COPY . .

# Build the admin panel (now it should work without SWC crash)
RUN npm run build

# Set production env
ENV NODE_ENV=production

# Expose Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]