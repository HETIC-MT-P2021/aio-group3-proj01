defmodule ApiApp.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias ApiApp.Images.{Tag, Category, TagsImages}

  schema "image" do
    field :description, :string
    field :image, :string
    field :name, :string
    belongs_to :category, Category, foreign_key: :category_id, on_replace: :nilify


    many_to_many :tag, Tag,
      join_through: TagsImages,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :description, :image, :category_id])
    |> validate_required([:name, :description, :image, :category_id])
    |> foreign_key_constraint(:category_id,
      name: :image_category_id_fkey,
      message: "Category not found!"
    )
  end
end
