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

  describe "tag" do
    alias ApiApp.Images.Tags

    @valid_attrs %{id: 42, name: "some name"}
    @update_attrs %{id: 43, name: "some updated name"}
    @invalid_attrs %{id: nil, name: nil}

    def tags_fixture(attrs \\ %{}) do
      {:ok, tags} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_tags()

      tags
    end

    test "list_tag/0 returns all tag" do
      tags = tags_fixture()
      assert Images.list_tag() == [tags]
    end

    test "get_tags!/1 returns the tags with given id" do
      tags = tags_fixture()
      assert Images.get_tags!(tags.id) == tags
    end

    test "create_tags/1 with valid data creates a tags" do
      assert {:ok, %Tags{} = tags} = Images.create_tags(@valid_attrs)
      assert tags.name == "some name"
    end

    test "create_tags/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_tags(@invalid_attrs)
    end

    test "update_tags/2 with valid data updates the tags" do
      tags = tags_fixture()
      assert {:ok, %Tags{} = tags} = Images.update_tags(tags, @update_attrs)
      assert tags.name == "some updated name"
    end

    test "update_tags/2 with invalid data returns error changeset" do
      tags = tags_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_tags(tags, @invalid_attrs)
      assert tags == Images.get_tags!(tags.id)
    end

    test "delete_tags/1 deletes the tags" do
      tags = tags_fixture()
      assert {:ok, %Tags{}} = Images.delete_tags(tags)
      assert_raise Ecto.NoResultsError, fn -> Images.get_tags!(tags.id) end
    end

    test "change_tags/1 returns a tags changeset" do
      tags = tags_fixture()
      assert %Ecto.Changeset{} = Images.change_tags(tags)
    end
  end
end