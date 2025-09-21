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

# --- run (serve handles SPA fallback) ---
FROM node:20-alpine
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate \
  && pnpm add -g serve@14
COPY --from=build /app/dist /app/dist
EXPOSE 80
# -s => SPA fallback; -l 80 => listen on 80
CMD ["serve", "-s", "dist", "-l", "80"]
