defmodule ApiAppWeb.TagsView do
  use ApiAppWeb, :view
  alias ApiAppWeb.TagsView

  def render("index.json", %{tag: tag}) do
    %{data: render_many(tag, TagsView, "tags.json")}
  end

  def render("show.json", %{tags: tags}) do
    %{data: render_one(tags, TagsView, "tags.json")}
  end

  def render("tags.json", %{tags: tags}) do
    %{id: tags.id,
      name: tags.name}
  end
end
