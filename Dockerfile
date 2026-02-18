FROM node:20-slim

RUN apt-get update && apt-get install -y \
    libvips42 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Fix for uploads folder
RUN mkdir -p public/uploads \
    && chown -R node:node public/uploads \
    && chmod -R 755 public/uploads

COPY package*.json ./
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

COPY . .

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "start"]