FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with clean slate
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

# Copy app files
COPY . .

# Set environment
ENV NODE_ENV=production

# Build admin panel
RUN npm run build

EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "start"]