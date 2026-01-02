import Config

config :inventory_management, InventoryManagement.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "inventory_management_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :inventory_management, InventoryManagementWeb.Endpoint,
  code_reloader: true,
  check_origin: false,
  debug_errors: true,
  watchers: []

