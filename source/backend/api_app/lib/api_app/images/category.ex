defmodule ApiApp.Images.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias ApiApp.Images.Image

  schema "category" do
    field :name, :string
    has_many :image, Image

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2)
  end
end
