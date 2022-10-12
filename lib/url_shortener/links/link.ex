defmodule UrlShortener.Links.Link do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w[original_url url_alias]a
  @updatable_fields ~w[hits]a
  @original_url_field :original_url

  schema "links" do
    field :hits, :integer, default: 0
    field :original_url, :string
    field :url_alias, :string

    timestamps()
  end

  @doc false
  def create_changeset(link, attrs) do
    link
    |> cast(attrs, @required_fields ++ [@original_url_field])
    |> validate_required(@required_fields)
    |> validate_url_format(@original_url_field)
    |> put_encoded_url()
  end

  def update_changeset(link, attrs) do
    link
    |> cast(attrs, @updatable_fields)
    |> validate_required(@updatable_fields)
  end

  # Adapted from https://gist.github.com/atomkirk/74b39b5b09c7d0f21763dd55b877f998?permalink_comment_id=3080620
  defp validate_url_format(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: "http", host: _host} -> nil
        %URI{scheme: "https", host: _host} -> nil
        %URI{scheme: nil} -> "is missing a scheme (e.g. https)"
        %URI{host: nil} -> "is missing a host"
        %URI{scheme: _scheme} -> "has invalid scheme (allowed: http or https)"
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end)
  end

  defp put_encoded_url(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{original_url: original_url}} ->
        put_change(changeset, :original_url, URI.encode(original_url))

      _ ->
        changeset
    end
  end
end
