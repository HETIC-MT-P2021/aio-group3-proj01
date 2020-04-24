defmodule ApiAppWeb.CategoriesView do
  use ApiAppWeb, :view
  alias ApiAppWeb.CategoriesView

  def render("index.json", %{category: category}) do
    %{data: render_many(category, CategoriesView, "categories.json")}
  end

  def render("show.json", %{categories: categories}) do
    %{data: render_one(categories, CategoriesView, "categories.json")}
  end

  def render("categories.json", %{categories: categories}) do
    %{id: categories.id, name: categories.name}
  end

  def render("imagesByCategories.json", %{categories: categories, images: images}) do
    %{id: categories.id, name: categories.name}

  end
end
