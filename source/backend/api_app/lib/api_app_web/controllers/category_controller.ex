defmodule ApiAppWeb.CategoryController do
  use ApiAppWeb, :controller

  alias ApiApp.Images
  alias ApiApp.Images.Category

  action_fallback ApiAppWeb.FallbackController

  def index(conn, _params) do
    category = Images.list_category()
    render(conn, "index.json", category: category)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Images.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.category_path(conn, :show, category))
      |> render("show.json", category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Images.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def show_images_by_category(conn, %{"id" => id}) do
    category = Images.get_category!(id)
    {category_id, _} = Integer.parse(id)
    images = Images.get_images_by_category(category_id)

    render(conn, "images_by_categories.json", category: category, images: images)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Images.get_category!(id)

    with {:ok, %Category{} = category} <- Images.update_category(category, category_params) do
      render(conn, "show.json", category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Images.get_category!(id)

    with {:ok, %Category{}} <- Images.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end
end
