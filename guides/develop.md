# Develop

### Before running or deployment

This project uses several free services:

* Gitlab OAuth Application, [click here](https://github.com/settings/applications/new) to setup your own
* Google Books Api, [document](https://developers.google.com/maps/documentation/embed/get-api-key)

Environment variables required:

* `GOOGLE_API_KEY`
* `BONFIRE_GITHUB_APP_ID` and `BONFIRE_GITHUB_APP_SECRET`

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
    -e BONFIRE_DATABASE_URL=ecto://YOUR_DB_USERNAME:YOUR_DB_PASSOWRD@YOUR_DB_HOST:YOUR_DB_PORT/YOUR_DATABASE \
    -e BONFIRE_SECRET_KEY_BASE=$(mix phx.gen.secret) \
    -e BONFIRE_ES_DATABASE_URL=ecto://... \
    -e BONFIRE_GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
    -e BONFIRE_GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
    -e BONFIRE_GOOGLE_API_KEY=${GOOGLE_API_KEY} \
    -p 4000:4000 \
    bonfire \
    start_iex
  ```

