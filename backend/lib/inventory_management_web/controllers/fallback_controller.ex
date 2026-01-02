defmodule InventoryManagementWeb.FallbackController do
  use InventoryManagementWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: InventoryManagementWeb.ChangesetView)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: InventoryManagementWeb.ErrorView)
    |> render(:"404")
  end
end

