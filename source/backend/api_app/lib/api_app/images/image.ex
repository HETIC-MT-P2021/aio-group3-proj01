defmodule ApiApp.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "image" do
    field :description, :string
    field :image, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :image])
    |> validate_required([:name, :description, :image])
  end
end
