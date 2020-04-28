defmodule ApiApp.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ApiApp.Repo
  alias ApiApp.{Repo, ImageHandler}

  alias ApiApp.Images.{Tag, Category, Image}

  @doc """
  Returns the list of tag.

  ## Examples

      iex> list_tag()
      [%Tag{}, ...]

  """
  def list_tag do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id) do
    Tag
    |> Repo.get!(id)
    |> Repo.preload(image: [:category, :tag])
  end

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  @doc """
  Query all existing tags from the argument list and create if the tag does not exist
  """
  def find_and_create_tags(tags) do
    existing_tags = Repo.all(from t in Tag, where: t.name in ^tags)
    new_tag_names = tags -- Enum.map(existing_tags, fn tag -> tag.name end)

    new_tags =
      new_tag_names
      |> Enum.map(fn tag_name ->
        {:ok, tag} = create_tag(%{name: tag_name})
        tag
      end)

    existing_tags ++ new_tags
  end

  @doc """
  Returns the list of category.

  ## Examples

      iex> list_category()
      [%Category{}, ...]

  """
  def list_category do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id) do
    Category
    |> Repo.get!(id)
    |> Repo.preload(image: [:category, :tag])
    end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    # |> Repo.preload(:image)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  @doc """
  Returns the list of image.

  ## Examples

      iex> list_image()
      [%Image{}, ...]

  """
  def list_image do
    Repo.all(Image)
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
    |> Repo.preload([:tag, :category])
    end


  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    case %Image{}
         |> Image.changeset(%{attrs | "image" => attrs["image"].filename})
         |> Ecto.Changeset.cast_assoc(:category, with: &Category.changeset/2)
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
end
