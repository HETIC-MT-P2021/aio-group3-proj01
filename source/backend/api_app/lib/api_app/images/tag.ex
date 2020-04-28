defmodule ApiApp.Images.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ApiApp.Images.{Image, TagsImages}

  schema "tag" do
    field :name, :string

    many_to_many :image, Image,
      join_through: TagsImages,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2)
  end
end
