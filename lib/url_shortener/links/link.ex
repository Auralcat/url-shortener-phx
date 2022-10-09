defmodule UrlShortener.Links.Link do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @all_fields ~w[original_url short_url hits]a
  @required_fields ~w[original_url]a
  @url_regex ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/

  schema "links" do
    field :hits, :integer
    field :original_url, :string
    field :short_url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_format(
      :original_url,
      @url_regex
    )
  end
end
