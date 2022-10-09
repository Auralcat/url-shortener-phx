defmodule UrlShortener.LinkTest do
  use UrlShortener.DataCase

  alias UrlShortener.Links.Link

  describe "changeset/2" do
    test "creates new entry with valid original_url" do
      invalid_urls = ~w[httpx://whatever https://invalid not_a_url]
      valid_url = "http://example.com"

      valid_url_changeset = Link.changeset(%Link{}, %{original_url: valid_url})

      assert valid_url_changeset.valid?

      Enum.each(invalid_urls, fn invalid_url ->
        invalid_url_changeset = Link.changeset(%Link{}, %{original_url: invalid_url})

        refute invalid_url_changeset.valid?
      end)
    end
  end
end
