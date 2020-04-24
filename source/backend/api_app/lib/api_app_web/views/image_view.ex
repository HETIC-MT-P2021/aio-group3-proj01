defmodule ApiAppWeb.ImageView do
  use ApiAppWeb, :view
  alias ApiAppWeb.ImageView
  alias ApiApp.ImageHandler

  def render("index.json", %{image: image}) do
    %{data: render_many(image, ImageView, "image.json")}
  end

  def render("show.json", %{image: image}) do
    %{data: render_one(image, ImageView, "image.json")}
  end

  def render("image.json", %{image: image}) do
    %{
      id: image.id,
      name: image.name,
      description: image.description,
      image_original_url: ImageHandler.url({image.image, image}, :original),
      category: render_one(image.category, ApiAppWeb.CategoriesView, "categories.json")
    }
  end
end
