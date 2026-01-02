defmodule InventoryManagementWeb.ItemController do
  use InventoryManagementWeb, :controller

  alias InventoryManagement.Inventory
  alias InventoryManagement.Inventory.Item

  action_fallback InventoryManagementWeb.FallbackController

  def index(conn, _params) do
    items = Inventory.list_items()
    render(conn, :index, items: items)
  end

  def create(conn, %{"item" => item_params}) do
    case Inventory.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> render(:show, item: item)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)
    item_with_stock = Map.put(item, :stock, Inventory.calculate_stock(item.id))
    render(conn, :show, item: item_with_stock)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Inventory.get_item!(id)

    case Inventory.update_item(item, item_params) do
      {:ok, item} ->
        render(conn, :show, item: item)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Inventory.get_item!(id)

    with {:ok, _item} <- Inventory.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
