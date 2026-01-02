defmodule InventoryManagementWeb.MovementController do
  use InventoryManagementWeb, :controller

  alias InventoryManagement.Inventory

  action_fallback InventoryManagementWeb.FallbackController

  def create(conn, %{"id" => item_id, "movement" => movement_params}) do
    movement_params = Map.put(movement_params, "item_id", item_id)

    case Inventory.create_movement(movement_params) do
      {:ok, movement} ->
        conn
        |> put_status(:created)
        |> render(:show, movement: movement)

      {:error, reason} when is_binary(reason) ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def index(conn, %{"id" => item_id}) do
    movements = Inventory.list_movements(item_id)
    render(conn, :index, movements: movements)
  end
end

