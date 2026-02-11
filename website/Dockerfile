FROM node:22-alpine AS build
WORKDIR /app
ARG BASE_PATH=""
ARG PUBLIC_POSTHOG_KEY=""
ARG PUBLIC_POSTHOG_HOST=""
ENV BASE_PATH=$BASE_PATH
ENV PUBLIC_POSTHOG_KEY=$PUBLIC_POSTHOG_KEY
ENV PUBLIC_POSTHOG_HOST=$PUBLIC_POSTHOG_HOST
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN if [ -n "$BASE_PATH" ]; then \
      mkdir -p /out${BASE_PATH} && \
      cp -r build/* /out${BASE_PATH}/; \
    else \
      mkdir -p /out && \
      cp -r build/* /out/; \
    fi

FROM caddy:2-alpine
COPY --from=build /out /srv
COPY Caddyfile /etc/caddy/Caddyfile
EXPOSE 80
