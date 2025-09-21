# --- build ---
FROM node:20-alpine AS build
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
# IMPORTANT if you serve under /finances/: set base in vite.config.ts or:
# RUN pnpm build -- --base=/finances/
RUN pnpm build

# --- run (Nginx serves static files) ---
FROM nginx:1.27-alpine
# write a tiny SPA config without needing a repo file
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
