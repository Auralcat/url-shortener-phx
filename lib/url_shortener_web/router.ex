defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UrlShortenerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlShortenerWeb do
    pipe_through :browser

    get "/", LinkController, :new
    resources "/links", LinkController, only: [:create, :show]
    get "/:short_url", RedirectController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", UrlShortenerWeb do
  #   pipe_through :api
  # end
end
