defmodule ApiAppWeb.CategoriesControllerTest do
  use ApiAppWeb.ConnCase

  alias ApiApp.Images
  alias ApiApp.Images.Categories

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:categories) do
    {:ok, categories} = Images.create_categories(@create_attrs)
    categories
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all category", %{conn: conn} do
      conn = get(conn, Routes.categories_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create categories" do
    test "renders categories when data is valid", %{conn: conn} do
      conn = post(conn, Routes.categories_path(conn, :create), categories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.categories_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.categories_path(conn, :create), categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update categories" do
    setup [:create_categories]

    test "renders categories when data is valid", %{conn: conn, categories: %Categories{id: id} = categories} do
      conn = put(conn, Routes.categories_path(conn, :update, categories), categories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.categories_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, categories: categories} do
      conn = put(conn, Routes.categories_path(conn, :update, categories), categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete categories" do
    setup [:create_categories]

    test "deletes chosen categories", %{conn: conn, categories: categories} do
      conn = delete(conn, Routes.categories_path(conn, :delete, categories))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.categories_path(conn, :show, categories))
      end
    end
  end

  defp create_categories(_) do
    categories = fixture(:categories)
    {:ok, categories: categories}
  end
end
