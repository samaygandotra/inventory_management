defmodule InventoryManagement.Repo.Migrations.CreateInventoryMovements do
  use Ecto.Migration

  def change do
    create table(:inventory_movements) do
      add :quantity, :integer, null: false
      add :movement_type, :string, null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:inventory_movements, [:item_id])
    create index(:inventory_movements, [:inserted_at])
  end
end

