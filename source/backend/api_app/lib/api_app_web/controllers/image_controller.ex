defmodule ApiAppWeb.ImageController do
  use ApiAppWeb, :controller

  alias ApiApp.{Images, Repo}
  alias ApiApp.Images.Image

  action_fallback ApiAppWeb.FallbackController

  def index(conn, _params) do
    image =
      Images.list_image()
      |> Repo.preload(:category)
      |> Repo.preload(:tag)

    render(conn, "index.json", image: image)
  end

  def create(conn, image_params) do
    with {:ok, %Image{} = image} <- Images.create_image(image_params) do
      image =
        image
        |> Repo.preload(:category)
        |> Repo.preload(:tag)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.image_path(conn, :show, image))
      |> render("show.json", image: image)
    end
  end

  def show(conn, %{"id" => id}) do
    image =
      Images.get_image!(id)
      |> Repo.preload(:category)
      |> Repo.preload(:tag)

    render(conn, "show.json", image: image)
  end

  def update(conn, %{"id" => id} = image_params) do
    image = Images.get_image!(id)

    with {:ok, %Image{} = image} <- Images.update_image(image, image_params) do
      image = Repo.preload(image, :category)

      render(conn, "show.json", image: image)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Images.get_image!(id)

    with {:ok, %Image{}} <- Images.delete_image(image) do
      image
      |> Repo.preload(:category)
      |> Repo.preload(:tag)

      send_resp(conn, :no_content, "")
    end
  end
end
