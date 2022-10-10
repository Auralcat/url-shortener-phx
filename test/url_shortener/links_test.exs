defmodule UrlShortener.LinksTest do
  use UrlShortener.DataCase

  alias UrlShortener.Links

  describe "links" do
    alias UrlShortener.Links.Link

    import UrlShortener.LinksFixtures

    @invalid_attrs %{original_url: "httpx://whatever"}

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link record with a short URL and 0 hits" do
      valid_url = "https://example.com"
      short_url = "#{UrlShortenerWeb.Endpoint.url()}/DKrySrGg"
      valid_attrs = %{original_url: valid_url}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.original_url == valid_url
      assert link.short_url == short_url
      assert link.hits == 0
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "create_slug/1 returns a URL with the hashed link" do
      sample_url =
        "https://www.google.com/search?q=url+shortener&oq=google+u&aqs=chrome.0.69i59j69i60l3j0j69i57.1069j0j7&sourceid=chrome&ie=UTF-8"

      {:ok, short_url} = Links.create_slug(sample_url)

      assert short_url == "#{UrlShortenerWeb.Endpoint.url()}/pNSqqt95"
    end
  end
end
