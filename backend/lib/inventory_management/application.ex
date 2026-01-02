defmodule InventoryManagement.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InventoryManagement.Repo,
      {Phoenix.PubSub, name: InventoryManagement.PubSub},
      InventoryManagementWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: InventoryManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    InventoryManagementWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

