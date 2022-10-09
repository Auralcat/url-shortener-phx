defmodule UrlShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{original_url: "https://example.com", hits: 0})
      |> UrlShortener.Links.create_link()

    link
  end
end
