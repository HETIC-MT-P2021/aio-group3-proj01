defmodule ApiApp.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias ApiApp.Repo

  alias ApiApp.Images.Categories
  alias ApiApp.Images.Tags

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
end
