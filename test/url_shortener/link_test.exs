defmodule UrlShortener.LinkTest do
  use UrlShortener.DataCase

  alias UrlShortener.Links.Link

  describe "changeset/2" do
    test "creates new entry with valid original_url" do
      valid_url = "http://example.com"
      url_alias = "http://localhost:4000/a75a901e"

      valid_url_changeset =
        Link.create_changeset(%Link{}, %{original_url: valid_url, url_alias: url_alias})

      assert valid_url_changeset.valid?
    end

    test "does not create entries with invalid original URLs" do
      invalid_urls = ~w[httpx://whatever https://invalid not_a_url]
      url_alias = "http://localhost:4000/a75a901e"

      Enum.each(invalid_urls, fn invalid_url ->
        invalid_url_changeset =
          Link.create_changeset(%Link{}, %{original_url: invalid_url, url_alias: url_alias})

        refute invalid_url_changeset.valid?
      end)
    end

    test "does not create entries without the url_alias parameter" do
      valid_url = "http://example.com"

      invalid_url_changeset = Link.create_changeset(%Link{}, %{original_url: valid_url})

      refute invalid_url_changeset.valid?
    end
  end
end
