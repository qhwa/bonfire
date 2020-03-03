# Bonfire

An demo project for learning Elixir. Some of the libraries involved:

* [Phoenix] for web framework
* [Phoenix LiveView] for almost-no-javascript application
* [Commanded] for [Event Sourcing]
* [Pow] for authentification
* [Rio] for deployment

It's still under active development, even the core features are not fully implemented yet. Refer to [Todos](#Todos) for more information.

## Develop

### Before running or deployment

This project uses several free services:

* Gitlab OAuth Application, [click here](https://github.com/settings/applications/new) to setup your own
* Google Books Api, [document](https://developers.google.com/maps/documentation/embed/get-api-key)

Environment variables required:

* `GOOGLE_API_KEY`
* `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`

### run locally

```sh
mix deps.get
mix phx.server
```

than open [http://localhost:4000](http://localhost:4000) in your browser

### Deploy

The easiest way to deploy may be [Rio]

After setting up Rio and your Kubernetes infrastructures, you can just run:

```sh
./deploy.sh
```

and everything is done. Out of the box there are:

* Letsencrypted SSL certification
* Continues Deployment, builds being triggered by code changes
* Easy to attach public domain

You can find more info on [Rio's homepage](https://rio.io).

Also, this project contains an `Dockerfile` so you can build your own image and run it anywhere you want.

  ```sh
  docker run \
    --rm \
    -it \
    -e DATABASE_URL=ecto://YOUR_DB_USERNAME:YOUR_DB_PASSOWRD@YOUR_DB_HOST:YOUR_DB_PORT/YOUR_DATABASE \
    -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
    -e ES_DATABASE_URL=ecto://... \
    -e GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
    -e GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
    -e GOOGLE_API_KEY=${GOOGLE_API_KEY} \
    -p 4000:4000 \
    bonfire \
    start_iex
  ```

## Todos

### Basis

* [ ] pass maintainbility checking by [credo]
* [ ] pass type checking by [dialyxir]

### core features

* [ ] tags for books
* [ ] deleting a reading track
* [ ] sharing a reading track to others
* [ ] stats of reading

After core features finished, it is next to make reading feel like a game, which is still forming on the roadmap.


[Phoenix]: http://www.phoenixframework.org/
[Phoenix LiveView]: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html
[Commanded]: https://github.com/commanded/commanded
[Event Sourcing]: https://martinfowler.com/eaaDev/EventSourcing.html
[Rio]: https://rio.io
[Pow]: https://powauth.com/
[credo]: https://github.com/rrrene/credo/
[dialyxir]: https://github.com/jeremyjh/dialyxir
