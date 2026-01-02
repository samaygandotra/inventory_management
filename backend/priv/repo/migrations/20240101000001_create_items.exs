defmodule InventoryManagement.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :sku, :string, null: false
      add :unit, :string, null: false

      timestamps()
    end

    create unique_index(:items, [:sku])
  end
end

