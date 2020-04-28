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

  def render("images_by_categories.json", %{categories: categories, images: images}) do
    %{id: categories.id, name: categories.name, images: images}
  end
end
