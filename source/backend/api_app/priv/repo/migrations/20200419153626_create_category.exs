defmodule ApiApp.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:category) do
      add :name, :string

      timestamps()
    end

    create unique_index(:category, [:name])
  end
end
