# syntax = docker/dockerfile:1.0-experimental

# -----------------------------------
# - stage: install
# - job: dependencies
# -----------------------------------
FROM qhwa/elixir-builder:latest AS deps

ARG MIX_ENV=prod
ARG HEX_MIRROR_URL=https://repo.hex.pm

WORKDIR /src

COPY mix.exs mix.lock /src/

RUN mix deps.get --only $MIX_ENV


# -----------------------------------
# - stage: build
# - job: compile
# -----------------------------------
FROM qhwa/elixir-builder:latest AS compile

ARG MIX_ENV=prod
ARG APPSIGNAL_HTTP_PROXY

WORKDIR /src

COPY --from=deps /src/deps /src/deps
ADD . .

RUN mix compile


# -----------------------------------
# - stage: build
# - job: assets
# -----------------------------------
FROM qhwa/elixir-builder:latest AS assets

WORKDIR /src/assets

COPY --from=deps /src/deps /src/deps/
COPY assets/package.json assets/package-lock.json ./

ARG NPM_REGISTRY=https://registry.npmjs.com/

# Use the npm cache directory as a cache mount
RUN npm \
  --registry ${NPM_REGISTRY} \
  --prefer-offline \
  --no-audit \
  --ignore-scripts \
  ci

ARG SASS_BINARY_SITE
RUN npm rebuild node-sass

COPY assets/ ./

RUN npm run deploy


# -----------------------------------
# - stage: release
# - job: mix_release
# -----------------------------------
FROM qhwa/elixir-builder:latest AS mix_release

WORKDIR /src

ARG MIX_ENV=prod

ADD . .

COPY --from=compile /src/deps ./deps
COPY --from=compile /src/_build ./_build


COPY --from=assets /src/assets/ ./assets
RUN mix phx.digest


RUN mix release --path /app --quiet

# -----------------------------------
# - stage: release
# - job: release_image
# -----------------------------------

FROM qhwa/elixir-runner:latest AS release_image

ARG APP_REVISION=latest
ARG MIX_ENV=prod

User nobody

COPY --from=mix_release --chown=nobody: /app /app

WORKDIR /app

ENTRYPOINT ["/app/bin/bonfire"]
CMD ["start"]
