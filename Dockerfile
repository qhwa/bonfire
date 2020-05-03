# syntax = docker/dockerfile:1.0-experimental

# -----------------------------------
# - stage: install
# - job: dependencies
# -----------------------------------
FROM qhwa/elixir-builder:latest AS deps

ARG MIX_ENV=prod
ARG HEX_MIRROR_URL=https://repo.hex.pm

WORKDIR /src

COPY config/ ./config
COPY mix.exs mix.lock /src/

RUN --mount=type=cache,target=~/.hex/packages/hexpm,sharing=locked \
    --mount=type=cache,target=~/.cache/rebar3,sharing=locked \
    mix deps.get \
    --only $MIX_ENV

# -----------------------------------
# - stage: build
# - job: compile_deps
# -----------------------------------
FROM deps AS compile_deps
WORKDIR /src

ARG MIX_ENV=prod
ARG APPSIGNAL_HTTP_PROXY

RUN mix deps.compile


# -----------------------------------
# - stage: build
# - job: compile_app
# -----------------------------------
FROM compile_deps AS compile_app
WORKDIR /src

ARG MIX_ENV=prod

COPY lib/ ./lib
COPY priv/ ./priv

RUN mix compile

# -----------------------------------
# - stage: build
# - job: assets
# -----------------------------------
FROM deps AS assets

WORKDIR /src/assets

COPY assets/package.json assets/package-lock.json ./

ARG NPM_REGISTRY=https://registry.npmjs.com/
ARG APPSIGNAL_HTTP_PROXY

# Use the npm cache directory as a cache mount
RUN --mount=type=cache,target=~/.npm,sharing=locked \
  npm \
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
# - stage: build
# - job: digest
# -----------------------------------
FROM compile_deps AS digest
WORKDIR /src

ARG MIX_ENV=prod

COPY --from=assets /src/priv ./priv

RUN ls -al ./priv/static
RUN mix phx.digest

# -----------------------------------
# - stage: release
# - job: mix_release
# -----------------------------------
FROM compile_app AS mix_release

WORKDIR /src

ARG MIX_ENV=prod

COPY --from=digest /src/priv/static ./priv/static

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
