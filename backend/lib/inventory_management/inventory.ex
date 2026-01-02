defmodule InventoryManagement.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias InventoryManagement.Repo
  alias InventoryManagement.Inventory.{Item, Movement}

  # Items

  def list_items do
    items = Repo.all(Item)
    Enum.map(items, fn item -> Map.put(item, :stock, calculate_stock(item.id)) end)
  end

  def get_item!(id), do: Repo.get!(Item, id)

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  # Movements

  def list_movements(item_id) do
    from(m in Movement,
      where: m.item_id == ^item_id,
      order_by: [desc: m.inserted_at],
      preload: [:item]
    )
    |> Repo.all()
  end

  def create_movement(attrs \\ %{}) do
    with {:ok, movement} <- validate_and_create_movement(attrs) do
      {:ok, movement}
    end
  end

  defp validate_and_create_movement(attrs) do
    %Movement{}
    |> Movement.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, movement} ->
        case validate_stock(movement.item_id) do
          :ok -> {:ok, movement}
          {:error, reason} -> 
            Repo.delete(movement)
            {:error, reason}
        end
      error -> error
    end
  end

  # Stock Calculation

  def calculate_stock(item_id) do
    movements = 
      from(m in Movement,
        where: m.item_id == ^item_id,
        select: {m.movement_type, m.quantity}
      )
      |> Repo.all()

    Enum.reduce(movements, 0, fn {type, quantity}, acc ->
      case type do
        "IN" -> acc + quantity
        "OUT" -> acc - quantity
        "ADJUSTMENT" -> acc + quantity
      end
    end)
  end

  defp validate_stock(item_id) do
    stock = calculate_stock(item_id)
    if stock >= 0 do
      :ok
    else
      {:error, "Stock cannot be negative. Current stock would be: #{stock}"}
    end
  end
end

