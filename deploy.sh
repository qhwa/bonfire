# ref: https://github.com/rancher/rio/blob/v0.6.0/docs/cli-reference.md#run
rio \
  --debug \
  --debug-level 10 \
  --namespace prod \
  run \
  --no-mesh \
  --build-branch master \
  --dnssearch bonfire.ooo \
  --image-pull-policy always \
  --name bonfire \
  --ports 80:4000 \
  --scale 1 \
  --env DATABASE_URL=secret://bonfire/database-url \
  --env ES_DATABASE_URL=secret://bonfire/es-database-url \
  --env SECRET_KEY_BASE=secret://bonfire/secret-key-base \
  --env AUTH_WITH_GITHUB=true \
  --env BONFIRE_GITHUB_CLIENT_ID=secret://bonfire/github-client-id \
  --env BONFIRE_GITHUB_CLIENT_SECRET=secret://bonfire/github-client-secret \
  --env AUTH_WITH_GOOGLE=true \
  --env BONFIRE_GOOGLE_CLIENT_ID=secret://bonfire/google-client-id \
  --env BONFIRE_GOOGLE_CLIENT_SECRET=secret://bonfire/google-client-secret \
  --env GOOGLE_API_KEY=secret://bonfire/google-api-key \
  --env BONFIRE_CDN="https://static.bonfirereading.com" \
  https://github.com/qhwa/bonfire
