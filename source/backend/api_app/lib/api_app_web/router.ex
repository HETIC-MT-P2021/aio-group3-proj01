defmodule ApiAppWeb.Router do
  use ApiAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiAppWeb do
    pipe_through :api

    resources "/categories", CategoriesController, except: [:new, :edit]
    resources "/tags", TagsController, except: [:new, :edit]
  end
end
