defmodule InventoryManagementWeb.ItemControllerTest do
  use InventoryManagementWeb.ConnCase

  alias InventoryManagement.Inventory

  @create_attrs %{name: "Test Item", sku: "SKU001", unit: "pcs"}
  @update_attrs %{name: "Updated Item", sku: "SKU001", unit: "kg"}

  def fixture(:item) do
    {:ok, item} = Inventory.create_item(@create_attrs)
    item
  end

  defp create_item(_) do
    item = fixture(:item)
    %{item: item}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, "/api/items")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      conn = post(conn, "/api/items", item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, "/api/items/#{id}")
      assert %{"id" => ^id, "name" => "Test Item"} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, "/api/items", item: %{name: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show item" do
    setup [:create_item]

    test "renders item with stock", %{conn: conn, item: item} do
      {:ok, _} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 10,
        movement_type: "IN"
      })

      conn = get(conn, "/api/items/#{item.id}")
      data = json_response(conn, 200)["data"]
      assert data["id"] == item.id
      assert data["stock"] == 10
    end
  end
end

