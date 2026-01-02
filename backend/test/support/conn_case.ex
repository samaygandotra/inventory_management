defmodule InventoryManagementWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import InventoryManagementWeb.ConnCase
      alias InventoryManagementWeb.Router.Helpers, as: Routes
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InventoryManagement.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InventoryManagement.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

