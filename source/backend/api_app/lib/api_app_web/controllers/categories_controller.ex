defmodule ApiAppWeb.CategoriesController do
  use ApiAppWeb, :controller

  alias ApiApp.Images
  alias ApiApp.Images.Categories

  action_fallback ApiAppWeb.FallbackController

  def index(conn, _params) do
    category = Images.list_category()
    render(conn, "index.json", category: category)
  end

  def create(conn, %{"categories" => categories_params}) do
    with {:ok, %Categories{} = categories} <- Images.create_categories(categories_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.categories_path(conn, :show, categories))
      |> render("show.json", categories: categories)
    end
  end

  def show(conn, %{"id" => id}) do
    categories = Images.get_categories!(id)
    render(conn, "show.json", categories: categories)
  end

  def update(conn, %{"id" => id, "categories" => categories_params}) do
    categories = Images.get_categories!(id)

    with {:ok, %Categories{} = categories} <- Images.update_categories(categories, categories_params) do
      render(conn, "show.json", categories: categories)
    end
  end

  def delete(conn, %{"id" => id}) do
    categories = Images.get_categories!(id)

    with {:ok, %Categories{}} <- Images.delete_categories(categories) do
      send_resp(conn, :no_content, "")
    end
  end
end
