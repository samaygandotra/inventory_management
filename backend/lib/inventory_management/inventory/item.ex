defmodule InventoryManagement.Inventory.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :sku, :string
    field :unit, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :sku, :unit])
    |> validate_required([:name, :sku, :unit])
    |> validate_inclusion(:unit, ["pcs", "kg", "litre"])
    |> unique_constraint(:sku)
  end
end

