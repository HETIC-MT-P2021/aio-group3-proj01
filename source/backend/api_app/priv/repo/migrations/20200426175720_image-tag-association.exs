defmodule ApiApp.Repo.Migrations.ImageTagAssociation do
  use Ecto.Migration

  def change do
    create table(:tags_images, primary_key: false) do
      add :image_id, references(:image)
      add :tag_id, references(:tag)

      timestamps()
    end

    create(index(:tags_images, [:image_id]))
    create(index(:tags_images, [:tag_id]))

    create(
      unique_index(:tags_images,  [:image_id, :tag_id], name: :image_id_tag_id_unique_index)
    )
  end
end
