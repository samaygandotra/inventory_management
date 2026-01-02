import Config

config :inventory_management, InventoryManagement.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_management_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :inventory_management, InventoryManagementWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

config :logger, level: :warning

