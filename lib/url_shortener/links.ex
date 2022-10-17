defmodule UrlShortener.Links do
  @moduledoc false

  @url_alias_length 8
  @links_updated_at_threshold_days 7
  @hashing_algorithm :sha

  import Ecto.Query, warn: false

  alias UrlShortener.Links.Link
  alias UrlShortener.Repo

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.
  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    original_url = attrs[:original_url]

    with {:ok, url_alias} <- create_url_alias(original_url) do
      link_params = %{original_url: original_url, url_alias: url_alias}

      %Link{}
      |> Link.create_changeset(link_params)
      |> Repo.insert(
        on_conflict: :nothing,
        conflict_target: :url_alias,
        returning: true
      )
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.create_changeset(link, attrs)
  end

  @doc """
  Removes the scheme from the URL and saves the result in the database
  as a URL alias.
  """
  def create_url_alias(original_url) do
    processed_url = Regex.replace(~r/^https?:\/\//, original_url, "")

    url_alias =
      @hashing_algorithm
      |> :crypto.hash(processed_url)
      |> Base.encode64()
      |> String.slice(0, @url_alias_length)

    {:ok, url_alias}
  end

  @doc """
  Returns the URL alias associated with the provided short URL in the database.
  """
  @spec get_link_by_short_url(String.t()) :: {:ok, Link.t()} | {:error, term()}
  def get_link_by_short_url(short_url) do
    with {:ok, url_alias} <- get_url_alias_from_short_url(short_url),
         {:ok, link} <- get_link_by_url_alias(url_alias) do
      {:ok, link}
    else
      error ->
        error
    end
  end

  def increment_link_hits_count(link) do
    link_changeset = Ecto.Changeset.change(link, hits: link.hits + 1)

    Repo.update(link_changeset)
  end

  def delete_unused_links() do
    from(l in Link, where: l.updated_at < ago(@links_updated_at_threshold_days, "day"))
    |> Repo.delete_all()
  end

  defp get_url_alias_from_short_url(short_url) do
    case URI.new(short_url) do
      {:ok, parsed_short_url} ->
        short_url_path = parsed_short_url.path
        url_alias = String.replace_prefix(short_url_path, "/", "")

        {:ok, url_alias}

      {:error, _part} ->
        {:error, :invalid_url}
    end
  end

  defp get_link_by_url_alias(url_alias) do
    link = Repo.get_by(Link, url_alias: url_alias)

    if is_nil(link) do
      {:error, :not_found}
    else
      {:ok, link}
    end
  end
end
