defmodule InventoryManagement.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias InventoryManagement.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import InventoryManagement.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InventoryManagement.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InventoryManagement.Repo, {:shared, self()})
    end

    :ok
  end
end

