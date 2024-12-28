# Build Stage
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Test Stage
FROM node:18 AS test
WORKDIR /app
COPY --from=build /app .
CMD ["npm", "test", "--", "--watchAll=false"]

# Production Runtime Stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
