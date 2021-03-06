defmodule ApiAppWeb.TagView do
  use ApiAppWeb, :view
  alias ApiAppWeb.TagView

  def render("index.json", %{tag: tag}) do
    %{data: render_many(tag, TagView, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{id: tag.id, name: tag.name}
  end

  def render("images_by_tag.json", %{tag: tag}) do
    %{id: tag.id, name: tag.name, images: render_many(tag.image, ApiAppWeb.ImageView, "show.json")}
  end
end
