# - stage 1: generate release files
FROM qhwa/elixir-builder:latest AS builder

ARG mix_env=prod
ARG hex_mirror_url=https://repo.hex.pm
ARG appsignal_http_proxy

ENV NODE_ENV=${mix_env} \
    MIX_ENV=${mix_env} \
    HEX_MIRROR_URL=${hex_mirror_url} \
    APPSIGNAL_HTTP_PROXY=${appsignal_http_proxy}

WORKDIR /src

COPY mix.exs mix.lock /src/

RUN mix deps.get --only $MIX_ENV

ADD . .

ARG sass_binary_site
ENV SASS_BINARY_SITE=${sass_binary_site}
# uncomment following lines to enable digesting in Phoenix project
RUN npm install --prefix assets
RUN npm rebuild --prefix assets
RUN npm run deploy --prefix assets
RUN mix phx.digest

RUN mix release --path /app --quiet

# - stage 2: build final image for running

FROM qhwa/elixir-runner:latest

ARG app_revision=latest
ARG mix_env=prod

ENV MIX_ENV=${mix_env} \
    APP_REVISION=${app_revision}

COPY --from=builder /app /app
WORKDIR /app

ENTRYPOINT ["/app/bin/bonfire"]
CMD ["start"]
