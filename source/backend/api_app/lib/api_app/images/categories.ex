defmodule ApiApp.Images.Categories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "category" do
    field :name, :string
    has_many :image, ApiApp.Images.Image, foreign_key: :image_id

    timestamps()
  end

  @doc false
  def changeset(categories, attrs) do
    categories
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, max: 60, count: :codepoints)
  end
end
