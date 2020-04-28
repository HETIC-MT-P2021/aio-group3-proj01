defmodule ApiApp.ImagesTest do
  use ApiApp.DataCase

  alias ApiApp.{Images, ImageHandler}

  describe "tag" do
    alias ApiApp.Images.Tag

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_tag()

      tag
    end

    test "list_tag/0 returns all tag" do
      tag = tag_fixture()
      assert Images.list_tag() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Images.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Images.create_tag(@valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Images.update_tag(tag, @update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_tag(tag, @invalid_attrs)
      assert tag == Images.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Images.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Images.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Images.change_tag(tag)
    end
  end

  describe "category" do
    alias ApiApp.Images.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Images.create_category()

      category
    end

    test "list_category/0 returns all category" do
      category = category_fixture()
      assert Images.list_category() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Images.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Images.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Images.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_category(category, @invalid_attrs)
      assert category == Images.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Images.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Images.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Images.change_category(category)
    end
  end

  describe "image" do
    alias ApiApp.Images.Image

    @valid_attrs %{
      "category_id" => 1,
      "description" => "some description",
      "image" => %Plug.Upload{
        content_type: "image/jpeg",
        filename: "1528_27.jpg",
        path: "test/fixtures/thumb.jpg"
      },
      "tags" => ["cat", "vacation"],
      "name" => "some name"
    }
    @update_attrs %{
      "category_id" => 42,
      "description" => "some updated description",
      "image" => %Plug.Upload{
        content_type: "image/jpeg",
        filename: "1528_27.jpg",
        path: "test/fixtures/thumb.jpg"
      },
      "tags" => ["cat", "vacation"],
      "name" => "some updated name"
    }
    @invalid_attrs %{
      "category_id" => 42,
      "description" => nil,
      "image" => %Plug.Upload{
        content_type: "image/jpeg",
        filename: nil,
        path: "test/fixtures/thumb.jpg"
      },
      "tags" => [],
      "name" => nil
    }

    def image_fixture(attrs \\ %{}) do
      category = category_fixture()

      {:ok, image} =
        attrs
        |> Map.merge(%{"category_id" => category.id})
        |> Enum.into(@valid_attrs)
        |> Images.create_image()

      image
    end

    setup do
      {:ok, %{category: category_fixture()}}
    end

    test "list_image/0 returns all image" do
      image = image_fixture()
      assert Images.list_image() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      category = categories_fixture()
      assert {:ok, %Image{} = image} = Images.create_image(%{@valid_attrs | "category_id" => category.id})
      assert image.description == "some description"
      assert image.image == "1528_27.jpg"
      assert image.name == "some name"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      category = categories_fixture()
      assert {:ok, %Image{} = image} = Images.update_image(image, @update_attrs)
      assert image.description == "some updated description"
      assert image.image == "1528_27.jpg"
      assert image.name == "some updated name"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
