defmodule Bonfire.EventApp do
  use Commanded.Application, otp_app: :bonfire

  router(Bonfire.Router)
end
