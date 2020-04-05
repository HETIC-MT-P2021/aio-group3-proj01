defmodule ApiApp.Images.Tags do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag" do
    field :name, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(tags, attrs) do
    tags
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
