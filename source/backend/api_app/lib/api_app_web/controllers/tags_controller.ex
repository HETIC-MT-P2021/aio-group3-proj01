defmodule ApiAppWeb.TagsController do
  use ApiAppWeb, :controller

  alias ApiApp.Images
  alias ApiApp.Images.Tags

  action_fallback ApiAppWeb.FallbackController

  def index(conn, _params) do
    tag = Images.list_tag()
    render(conn, "index.json", tag: tag)
  end

  def create(conn, %{"tags" => tags_params}) do
    with {:ok, %Tags{} = tags} <- Images.create_tags(tags_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tags_path(conn, :show, tags))
      |> render("show.json", tags: tags)
    end
  end

  def show(conn, %{"id" => id}) do
    tags = Images.get_tags!(id)
    render(conn, "show.json", tags: tags)
  end

  def show_images_by_tags(conn, %{"id" => id}) do
    tags = Images.get_tags!(id)
    {tag_id, _} = Integer.parse(id)
    images = Images.get_image_by_tags(tag_id)
    render(conn, "images_by_tags.json", tags: tags, images: images)
  end

  def update(conn, %{"id" => id, "tags" => tags_params}) do
    tags = Images.get_tags!(id)

    with {:ok, %Tags{} = tags} <- Images.update_tags(tags, tags_params) do
      render(conn, "show.json", tags: tags)
    end
  end

  def delete(conn, %{"id" => id}) do
    tags = Images.get_tags!(id)

    with {:ok, %Tags{}} <- Images.delete_tags(tags) do
      send_resp(conn, :no_content, "")
    end
  end
end
