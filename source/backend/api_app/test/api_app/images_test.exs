defmodule ApiApp.ImagesTest do
  use ApiApp.DataCase

  alias ApiApp.Images

  describe "category" do
    alias ApiApp.Images.Categories

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def categories_fixture(attrs \\ %{}) do
      {:ok, categories} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_categories()

      categories
    end

    test "list_category/0 returns all category" do
      categories = categories_fixture()
      assert Images.list_category() == [categories]
    end

    test "get_categories!/1 returns the categories with given id" do
      categories = categories_fixture()
      assert Images.get_categories!(categories.id) == categories
    end

    test "create_categories/1 with valid data creates a categories" do
      assert {:ok, %Categories{} = categories} = Images.create_categories(@valid_attrs)
      assert categories.name == "some name"
    end

    test "create_categories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_categories(@invalid_attrs)
    end

    test "update_categories/2 with valid data updates the categories" do
      categories = categories_fixture()
      assert {:ok, %Categories{} = categories} = Images.update_categories(categories, @update_attrs)
      assert categories.name == "some updated name"
    end

    test "update_categories/2 with invalid data returns error changeset" do
      categories = categories_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_categories(categories, @invalid_attrs)
      assert categories == Images.get_categories!(categories.id)
    end

    test "delete_categories/1 deletes the categories" do
      categories = categories_fixture()
      assert {:ok, %Categories{}} = Images.delete_categories(categories)
      assert_raise Ecto.NoResultsError, fn -> Images.get_categories!(categories.id) end
    end

    test "change_categories/1 returns a categories changeset" do
      categories = categories_fixture()
      assert %Ecto.Changeset{} = Images.change_categories(categories)
    end
  end
end
