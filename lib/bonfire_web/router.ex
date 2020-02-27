defmodule BonfireWeb.Router do
  use BonfireWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :need_authorize do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/", BonfireWeb do
    pipe_through :need_authorize

    get "/", PageController, :index
    resources "/tracks", ReadingStateController, only: [:new, :index, :show]
  end

  scope "/" do
    pipe_through :browser

    get "/~:user_name", BonfireWeb.ProfileController, :show

    pow_routes()
    pow_assent_routes()
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  # Other scopes may use custom stacks.
  # scope "/api", BonfireWeb do
  #   pipe_through :api
  # end
end
