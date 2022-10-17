defmodule UrlShortener.Repo.Migrations.AddUniqueConstraintToUrlAliasLinks do
  use Ecto.Migration

  def change do
    create unique_index(:links, :url_alias)
  end
end
