defmodule InventoryManagement.InventoryTest do
  use InventoryManagement.DataCase

  alias InventoryManagement.Inventory
  alias InventoryManagement.Inventory.{Item, Movement}

  describe "items" do
    test "list_items/0 returns all items with stock" do
      {:ok, item} = Inventory.create_item(%{name: "Test Item", sku: "SKU001", unit: "pcs"})
      
      {:ok, _movement1} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 10,
        movement_type: "IN"
      })

      {:ok, _movement2} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 3,
        movement_type: "OUT"
      })

      items = Inventory.list_items()
      assert length(items) == 1
      assert hd(items).stock == 7
    end

    test "create_item/1 with valid data creates an item" do
      assert {:ok, %Item{} = item} = Inventory.create_item(%{
        name: "Test Item",
        sku: "SKU001",
        unit: "pcs"
      })
      assert item.name == "Test Item"
      assert item.sku == "SKU001"
      assert item.unit == "pcs"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_item(%{name: nil})
    end
  end

  describe "stock calculation" do
    test "calculate_stock/1 sums IN movements correctly" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU1", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 5, movement_type: "IN"})
      
      assert Inventory.calculate_stock(item.id) == 15
    end

    test "calculate_stock/1 subtracts OUT movements correctly" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU2", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 20, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 7, movement_type: "OUT"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 3, movement_type: "OUT"})
      
      assert Inventory.calculate_stock(item.id) == 10
    end

    test "calculate_stock/1 handles ADJUSTMENT movements correctly" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU3", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 5, movement_type: "ADJUSTMENT"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: -2, movement_type: "ADJUSTMENT"})
      
      assert Inventory.calculate_stock(item.id) == 13
    end

    test "calculate_stock/1 handles complex movements" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU4", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 100, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 30, movement_type: "OUT"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 20, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 5, movement_type: "ADJUSTMENT"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "OUT"})
      
      assert Inventory.calculate_stock(item.id) == 85
    end
  end

  describe "negative stock validation" do
    test "create_movement/1 rejects movement that would result in negative stock" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU5", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "IN"})
      
      assert {:error, reason} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 15,
        movement_type: "OUT"
      })
      
      assert is_binary(reason)
      assert String.contains?(reason, "negative")
      
      # Verify stock is still 10 (movement was rolled back)
      assert Inventory.calculate_stock(item.id) == 10
    end

    test "create_movement/1 allows movement that results in zero stock" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU6", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "OUT"})
      
      assert Inventory.calculate_stock(item.id) == 0
    end

    test "create_movement/1 rejects negative ADJUSTMENT that would result in negative stock" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU7", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 10, movement_type: "IN"})
      
      assert {:error, reason} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: -15,
        movement_type: "ADJUSTMENT"
      })
      
      assert is_binary(reason)
      assert String.contains?(reason, "negative")
    end

    test "create_movement/1 allows negative ADJUSTMENT that results in non-negative stock" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU8", unit: "pcs"})
      
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: 20, movement_type: "IN"})
      {:ok, _} = Inventory.create_movement(%{item_id: item.id, quantity: -5, movement_type: "ADJUSTMENT"})
      
      assert Inventory.calculate_stock(item.id) == 15
    end
  end

  describe "movements" do
    test "list_movements/1 returns movements for an item" do
      {:ok, item} = Inventory.create_item(%{name: "Item", sku: "SKU8", unit: "pcs"})
      
      {:ok, movement1} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 10,
        movement_type: "IN"
      })
      
      {:ok, movement2} = Inventory.create_movement(%{
        item_id: item.id,
        quantity: 5,
        movement_type: "OUT"
      })
      
      movements = Inventory.list_movements(item.id)
      assert length(movements) == 2
      assert Enum.any?(movements, fn m -> m.id == movement2.id end)
      assert Enum.any?(movements, fn m -> m.id == movement1.id end)
    end
  end
end

