import Config

config :inventory_management, ecto_repos: [InventoryManagement.Repo]

config :inventory_management, InventoryManagement.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_management_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :inventory_management, InventoryManagementWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  secret_key_base: "your-secret-key-base-change-in-production",
  live_view: [signing_salt: "your-signing-salt"],
  check_origin: false

config :inventory_management, :generators,
  migration: true,
  binary_id: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

