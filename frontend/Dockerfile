FROM node:18 AS build
WORKDIR /app

# Cache dependencies
COPY package*.json ./
RUN npm install --production

# Copy remaining files and build
COPY . .
RUN npm run build

# Use Nginx for serving static files
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

# Expose default Nginx port
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
