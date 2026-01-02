defmodule InventoryManagementWeb.Router do
  use InventoryManagementWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InventoryManagementWeb do
    pipe_through :api

    resources "/items", ItemController, except: [:new, :edit]
    post "/items/:id/movements", MovementController, :create
    get "/items/:id/movements", MovementController, :index
  end
end

