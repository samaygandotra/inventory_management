defmodule InventoryManagementWeb.ItemView do
  use InventoryManagementWeb, :view

  def render("index.json", %{items: items}) do
    %{data: render_many(items, __MODULE__, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, __MODULE__, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      stock: item.stock || 0,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
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
