defmodule ApiApp.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tag) do
      add :name, :string

      timestamps()
    end
  end
end
