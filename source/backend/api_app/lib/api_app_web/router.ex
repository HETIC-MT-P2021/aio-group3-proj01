defmodule ApiAppWeb.Router do
  use ApiAppWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:3000"
    plug :accepts, ["json"]
  end

  scope "/api", ApiAppWeb do
    pipe_through :api
    
    resources "/categories", CategoriesController, except: [:new, :edit]
    resources "/tags", TagsController, except: [:new, :edit]
    resources "/image", ImageController, except: [:new, :edit]
  end
end
