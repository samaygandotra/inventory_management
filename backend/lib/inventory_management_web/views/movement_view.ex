defmodule InventoryManagementWeb.MovementView do
  use InventoryManagementWeb, :view

  def render("index.json", %{movements: movements}) do
    %{data: render_many(movements, __MODULE__, "movement.json")}
  end

  def render("show.json", %{movement: movement}) do
    %{data: render_one(movement, __MODULE__, "movement.json")}
  end

  def render("movement.json", %{movement: movement}) do
    %{
      id: movement.id,
      item_id: movement.item_id,
      quantity: movement.quantity,
      movement_type: movement.movement_type,
      inserted_at: movement.inserted_at,
      updated_at: movement.updated_at
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
