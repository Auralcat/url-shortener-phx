defmodule UrlShortener.Links.Link do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @all_fields ~w[original_url url_alias hits]a
  @required_fields ~w[original_url url_alias]a
  @updatable_fields ~w[hits]a

  @url_regex ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/

  schema "links" do
    field :hits, :integer, default: 0
    field :original_url, :string
    field :url_alias, :string

    timestamps()
  end

  @doc false
  def create_changeset(link, attrs) do
    link
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_format(
      :original_url,
      @url_regex
    )
  end

  def update_changeset(link, attrs) do
    link
    |> cast(attrs, @updatable_fields)
    |> validate_required(@updatable_fields)
  end
end
