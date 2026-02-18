FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps

COPY . .

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "run", "start"]