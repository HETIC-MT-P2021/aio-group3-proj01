defmodule ApiAppWeb.Router do
  use ApiAppWeb, :router
  import Phoenix.LiveDashboard.Router
  import Phoenix.LiveView.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiAppWeb do
    pipe_through :api

    resources "/categories", CategoriesController, except: [:new, :edit]
    get "/category/images/:id", CategoriesController, :show_images
    resources "/tags", TagsController, except: [:new, :edit]
    resources "/image", ImageController, except: [:new, :edit]
  end

  if Mix.env() == :dev do
    pipeline :browser do
      plug :accepts, ["html"]
      plug :fetch_session
      plug :fetch_live_flash
      plug :protect_from_forgery
      plug :put_secure_browser_headers
    end

    scope "/", ApiAppWeb do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ApiAppWeb.Telemetry
    end
  end
end
