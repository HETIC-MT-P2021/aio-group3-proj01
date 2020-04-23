defmodule ApiApp.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  alias ApiApp.Images.Categories

  schema "image" do
    field :description, :string
    field :image, :string
    field :name, :string
    belongs_to :category, Categories, foreign_key: :category_id, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :category_id, :image])
    |> validate_required([:name, :description, :category_id, :image])
    |> foreign_key_constraint(:category_id,
      name: :image_category_id_fkey,
      message: "Category not found!"
    )
  end
end
