# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :url_shortener,
  ecto_repos: [UrlShortener.Repo]

config :url_shortener, UrlShortener.Scheduler,
  jobs: [
    # Run at 12AM and 12PM
    {{:cron, "0 */12 * * *"}, {UrlShortener.CleanUnusedLinks, :delete_unused_links, []}}
  ]

# Configures the endpoint
config :url_shortener, UrlShortenerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: UrlShortenerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: UrlShortener.PubSub,
  live_view: [signing_salt: "RqI+wTvX"],
  url_alias_length: {:system, :integer, "URL_ALIAS_LENGTH", 8},
  links_updated_at_threshold_days: {:system, :integer, "LINKS_UPDATED_AT_THRESHOLD_DAYS", 7}

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
