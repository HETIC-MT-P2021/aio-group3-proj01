defmodule ApiAppWeb.TagsControllerTest do
  use ApiAppWeb.ConnCase

  alias ApiApp.Images
  alias ApiApp.Images.Tags

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:tags) do
    {:ok, tags} = Images.create_tags(@create_attrs)
    tags
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tag", %{conn: conn} do
      conn = get(conn, Routes.tags_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tags" do
    test "renders tags when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tags_path(conn, :create), tags: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tags_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tags_path(conn, :create), tags: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tags" do
    setup [:create_tags]

    test "renders tags when data is valid", %{conn: conn, tags: %Tags{id: id} = tags} do
      conn = put(conn, Routes.tags_path(conn, :update, tags), tags: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tags_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tags: tags} do
      conn = put(conn, Routes.tags_path(conn, :update, tags), tags: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tags" do
    setup [:create_tags]

    test "deletes chosen tags", %{conn: conn, tags: tags} do
      conn = delete(conn, Routes.tags_path(conn, :delete, tags))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tags_path(conn, :show, tags))
      end
    end
  end

  defp create_tags(_) do
    tags = fixture(:tags)
    {:ok, tags: tags}
  end
end
