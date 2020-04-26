defmodule ApiApp.Images.Tags do
  use Ecto.Schema
  import Ecto.Changeset
  alias ApiApp.Images.{Image, TagsImages}

  schema "tag" do
    field :name, :string, null: false
    many_to_many :image, Image, join_through: TagsImages, on_replace: :delete

    timestamps(usec: false)
  end

  @doc false
  def changeset(tags, attrs) do
    tags
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, max: 60, count: :codepoints)
    |> put_assoc(:image, Image)
  end
end