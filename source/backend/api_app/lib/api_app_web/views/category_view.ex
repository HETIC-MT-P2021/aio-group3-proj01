defmodule ApiAppWeb.CategoryView do
  use ApiAppWeb, :view
  alias ApiAppWeb.CategoryView

  def render("index.json", %{category: category}) do
    %{data: render_many(category, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id, name: category.name}
  end

  def render("images_by_category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      images: render_many(category.image, ApiAppWeb.ImageView, "image.json")
    }
  end
end
