defmodule InventoryManagement.Inventory.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_movements" do
    field :quantity, :integer
    field :movement_type, :string
    belongs_to :item, InventoryManagement.Inventory.Item

    timestamps()
  end

  @doc false
  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:quantity, :movement_type, :item_id])
    |> validate_required([:quantity, :movement_type, :item_id])
    |> validate_inclusion(:movement_type, ["IN", "OUT", "ADJUSTMENT"])
    |> validate_quantity()
    |> foreign_key_constraint(:item_id)
  end

  defp validate_quantity(changeset) do
    movement_type = get_field(changeset, :movement_type)
    quantity = get_field(changeset, :quantity)

    cond do
      movement_type == "ADJUSTMENT" ->
        if quantity == 0 do
          add_error(changeset, :quantity, "cannot be zero")
        else
          changeset
        end

      movement_type in ["IN", "OUT"] ->
        validate_number(changeset, :quantity, greater_than: 0)

      true ->
        changeset
    end
  end
end

