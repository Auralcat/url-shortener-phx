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

    test "create_link/1 with valid data creates a link" do
      valid_url = "https://example.com"
      valid_attrs = %{original_url: valid_url}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.original_url == valid_url
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
