defmodule TagsImages do
  use Ecto.Schema
  import Ecto.Changeset

  alias ApiApp.Images.{Image, Tags}

  @primary_key false
  schema "tags_images" do
    belongs_to :image, Image
    belongs_to :tag, Tags

    timestamps()
  end

  @doc false

  def changeset(tags_images, attrs) do
    tags_images
    |> cast(attrs, [:image_id, :tag_id])
    |> validate_required([:image_id, :tag_id])
    |> foreign_key_constraint(:image_id)
    |> foreign_key_constraint(:tag_id)
    |> unique_constraint(:image,
      name: :image_id_tag_id_unique_index,
      message: "Already exists"
    )
  end
end
