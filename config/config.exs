# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ws, Ws.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "iXJ+b5mgfmUBhXF8He4oJ5xWe0jmbyrcW88z86bcFda0KbiQxZdkV+84MrCFbyL+",
  render_errors: [accepts: ~w(html json)],
  #pubsub: [name: Ws.PubSub, adapter: Phoenix.PubSub.PG2]
  pubsub: [name: Ph2.PubSub, adapter: Phoenix.PubSub.Redis, host: "127.0.0.1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
