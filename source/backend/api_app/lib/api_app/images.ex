defmodule ApiApp.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ApiApp.{Repo, ImageHandler}
  alias ApiApp.Images.{Categories, Tags, Image}

  @doc """
  Returns the list of category.

  ## Examples

      iex> list_category()
      [%Categories{}, ...]

  """
  def list_category do
    Repo.all(Categories)
  end

  @doc """
  Gets a single categories.

  Raises `Ecto.NoResultsError` if the Categories does not exist.

  ## Examples

      iex> get_categories!(123)
      %Categories{}

      iex> get_categories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_categories!(id), do: Repo.get!(Categories, id)

  @doc """
  Creates a categories.

  ## Examples

      iex> create_categories(%{field: value})
      {:ok, %Categories{}}

      iex> create_categories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_categories(attrs \\ %{}) do
    %Categories{}
    |> Categories.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a categories.

  ## Examples

      iex> update_categories(categories, %{field: new_value})
      {:ok, %Categories{}}

      iex> update_categories(categories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_categories(%Categories{} = categories, attrs) do
    categories
    |> Categories.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a categories.

  ## Examples

      iex> delete_categories(categories)
      {:ok, %Categories{}}

      iex> delete_categories(categories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_categories(%Categories{} = categories) do
    Repo.delete(categories)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking categories changes.

  ## Examples

      iex> change_categories(categories)
      %Ecto.Changeset{source: %Categories{}}

  """
  def change_categories(%Categories{} = categories) do
    Categories.changeset(categories, %{})
  end

  @doc """
  Returns the list of tag.

  ## Examples

      iex> list_tag()
      [%Tags{}, ...]

  """
  def list_tag do
    Repo.all(Tags)
  end

  @doc """
  Gets a single tags.

  Raises `Ecto.NoResultsError` if the Tags does not exist.

  ## Examples

      iex> get_tags!(123)
      %Tags{}

      iex> get_tags!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tags!(id), do: Repo.get!(Tags, id)

  @doc """
  Creates a tags.

  ## Examples

      iex> create_tags(%{field: value})
      {:ok, %Tags{}}

      iex> create_tags(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tags(attrs \\ %{}) do
    %Tags{}
    |> Tags.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tags.

  ## Examples

      iex> update_tags(tags, %{field: new_value})
      {:ok, %Tags{}}

      iex> update_tags(tags, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tags(%Tags{} = tags, attrs) do
    tags
    |> Tags.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tags.

  ## Examples

      iex> delete_tags(tags)
      {:ok, %Tags{}}

      iex> delete_tags(tags)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tags(%Tags{} = tags) do
    Repo.delete(tags)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tags changes.

  ## Examples

      iex> change_tags(tags)
      %Ecto.Changeset{source: %Tags{}}

  """
  def change_tags(%Tags{} = tags) do
    Tags.changeset(tags, %{})
  end

  def find_and_create_tags(tags) do
    existing_tags = Repo.all(from t in Tags, where: t.name in ^tags)
    new_tag_names = tags -- Enum.map(existing_tags, fn tag -> tag.name end)

    new_tags =
      new_tag_names
      |> Enum.map(fn tag_name ->
        {:ok, tag} = create_tags(%{name: tag_name})
        tag
      end)

    existing_tags ++ new_tags
  end

  @doc """
  Returns the list of image.

  ## Examples

      iex> list_image()
      [%Image{}, ...]

  """
  def list_image do
    Image
    |> Repo.all()
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id) do
    Image
    |> Repo.get!(id)
  end

  @doc """
  Creates a image and associates the category passed in the object, uses find_and_create_tags for tags object.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    # IO.inspect(attrs, label: "CREATE ATTRS")
    case %Image{}
         |> Image.changeset(%{attrs | "image" => attrs["image"].filename})
         |> Ecto.Changeset.cast_assoc(:category, with: &Categories.changeset/2)
         # |> Ecto.Changeset.put_assoc(:tags, tags)
         |> Repo.insert() do
      {:ok, image} ->
        if attrs["tags"] do
          tags = find_and_create_tags(attrs["tags"])

          tags
          |> Enum.each(fn tag ->
            TagsImages.changeset(%TagsImages{}, %{image_id: image.id, tag_id: tag.id})
            |> Repo.insert(on_conflict: :nothing)
          end)
        end

        {:ok, _image_name} = ImageHandler.store({attrs["image"], image})
        {:ok, image}

      error ->
        error
    end
  end

  def create_image_test(attrs \\ %{}) do
    # IO.inspect(attrs, label: "CREATE ATTRS")
    tags = find_and_create_tags(attrs["tags"])

    case %Image{}
         |> Image.changeset(%{attrs | "image" => attrs["image"].filename})
         |> Ecto.Changeset.cast_assoc(:category, with: &Categories.changeset/2)
         |> Repo.insert() do
      {:ok, image} ->
        {:ok, _image_name} = ImageHandler.store({attrs["image"], image})
        {:ok, image}

      error ->
        error
    end
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    case image
         |> Image.changeset(%{attrs | "image" => attrs["image"].filename})
         |> Repo.update() do
      {:ok, updated_image} ->
        if attrs["tags"] do
          tags = find_and_create_tags(attrs["tags"])

          tags
          |> Enum.each(fn updated_tags ->
            TagsImages.changeset(%TagsImages{}, %{
              image_id: updated_image.id,
              tag_id: updated_tags.id
            })
            |> Repo.insert(on_conflict: :nothing)
          end)
        end

        ImageHandler.delete({image.image, image})
        {:ok, _image_name} = ImageHandler.store({attrs["image"], updated_image})

        # image_params = %{image_params | "image" => image_name }
        {:ok, updated_image}

      error ->
        error
    end
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    ImageHandler.delete({image.image, image})
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{source: %Image{}}

  """
  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  @doc """
    Returns a list of images fetched by a specific category
  """
  def get_images_by_category(id) do
    images =
      Repo.all(
        from i in "image",
          where: i.category_id == ^id,
          select: %{
            id: i.id,
            name: i.name,
            image_original_url: i.image,
            description: i.description
          }
      )

    images
  end

  @doc """
    Returns a list of images fetched by a specific tag
  """
  def get_image_by_tags(id) do
    images_id =
      Repo.all(
        from ti in "tags_images",
          where: ti.tag_id == ^id,
          select: ti.image_id
      )

    images =
      images_id
      |> Enum.map(fn single_image_id ->
        Repo.all(
          from i in "image",
            where: i.id == ^single_image_id,
            select: %{
              name: i.name,
              description: i.description,
              image_original_url: i.image,
              category_id: i.category_id
            }
        )
      end)

    images
  end
end
