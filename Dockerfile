FROM oven/bun:1.3 AS build

WORKDIR /app

COPY bun.lock package.json ./

RUN bun install --frozen-lockfile

COPY . .

RUN bun run build

FROM nginx:1.27-alpine

RUN printf '%s\n' \
  'server {' \
  '  listen 80;' \
  '  server_name _;' \
  '  root /usr/share/nginx/html;' \
  '  index index.html;' \
  '  location / { try_files $uri $uri/ /index.html; }' \
  '  location ~* \.(?:js|mjs|css|png|jpg|jpeg|gif|svg|ico|woff2?)$ {' \
  '    expires 1y;' \
  '    add_header Cache-Control "public, immutable";' \
  '    try_files $uri =404;' \
  '  }' \
  '}' > /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
