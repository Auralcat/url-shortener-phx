defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :original_url, :string, null: false
      add :url_alias, :string
      add :hits, :integer, default: 0

      timestamps()
    end
  end
end
