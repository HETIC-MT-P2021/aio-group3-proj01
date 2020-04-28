defmodule ApiAppWeb.TagController do
  use ApiAppWeb, :controller

  alias ApiApp.Images
  alias ApiApp.Images.Tag

  action_fallback ApiAppWeb.FallbackController

  def index(conn, _params) do
    tag = Images.list_tag()
    render(conn, "index.json", tag: tag)
  end

  def create(conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Images.create_tag(tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tag_path(conn, :show, tag))
      |> render("show.json", tag: tag)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Images.get_tag!(id)
    render(conn, "show.json", tag: tag)
  end

  def show_images_by_tag(conn, %{"id" => id}) do
    tag = Images.get_tag!(id)

    render(conn, "images_by_tag.json", tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Images.get_tag!(id)

    with {:ok, %Tag{} = tag} <- Images.update_tag(tag, tag_params) do
      render(conn, "show.json", tag: tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Images.get_tag!(id)

    with {:ok, %Tag{}} <- Images.delete_tag(tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
