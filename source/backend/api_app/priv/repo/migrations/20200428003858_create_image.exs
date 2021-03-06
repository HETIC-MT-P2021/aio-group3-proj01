defmodule ApiApp.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:image) do
      add :name, :string
      add :description, :string
      add :image, :string
      add :category_id, references(:category, on_delete: :nothing)

      timestamps()
    end

    create index(:image, [:category_id])
  end
end
