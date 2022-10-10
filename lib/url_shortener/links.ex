defmodule UrlShortener.Links do
  @moduledoc """
  The Links context.
  """

  @slug_length 8
  @hashing_algorithm :sha

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Links.Link

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

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

    with {:ok, short_url} <- create_slug(original_url) do
      link_params = %{original_url: original_url, short_url: short_url}

      %Link{}
      |> Link.changeset(link_params)
      |> Repo.insert()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def create_slug(original_url) do
    processed_url = Regex.replace(~r/^https?:\/\//, original_url, "")
    server_url = UrlShortenerWeb.Endpoint.url()

    link_hash =
      @hashing_algorithm
      |> :crypto.hash(processed_url)
      |> Base.encode64()
      |> String.slice(0, @slug_length)

    hashed_url = Enum.join([server_url, link_hash], "/")

    {:ok, hashed_url}
  end
end
