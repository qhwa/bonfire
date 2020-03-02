# Bonfire

An demo project for learning Elixir. Libraries involved:

* [Phoenix] for web framework
* [Phoenix LiveView] for almost-no-javascript application
* [Commanded] for [Event Sourcing]
* [Skylab] for deployment

## Run locally
## Deploy

1. generate release configs:

  ```sh
  mix skylab.init --overwrite
  ```

2. generate docker image:

  ```sh
  docker build -t bonfire .
  ```
3. distribute the docker image

  You can push your docker image to your registry and run it anywhere you want.

  Or just run it locally as:

  ```sh
  docker run \
    --rm \
    -it \
    -e DATABASE_URL=ecto://YOUR_DB_USERNAME:YOUR_DB_PASSOWRD@YOUR_DB_HOST:YOUR_DB_PORT/YOUR_DATABASE \
    -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
    -e ES_DATABASE_URL=ecto://... \
    -e GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
    -e GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
    -p 4000:4000 \
    bonfire \
    start_iex
  ```


[Phoenix]: http://www.phoenixframework.org/
[Phoenix LiveView]: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html
[Commanded]: https://github.com/commanded/commanded
