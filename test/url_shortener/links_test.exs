defmodule UrlShortener.LinksTest do
  use UrlShortener.DataCase

  alias UrlShortener.Links

  describe "links" do
    alias UrlShortener.Links.Link

    import UrlShortener.LinksFixtures
    import UrlShortener.Factory

    @invalid_attrs %{original_url: "httpx://whatever"}

    Application.put_env(:url_shortener, :url_alias_length, 8)

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data upserts a link record with a short URL and 0 hits" do
      Application.put_env(:url_shortener, :url_alias_length, 8)
      valid_url = "https://example.com"
      url_alias = "DKrySrGg"
      insert!(:link, original_url: valid_url, url_alias: url_alias)

      valid_attrs = %{original_url: valid_url}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)

      assert link.original_url == valid_url
      assert link.url_alias == url_alias
      assert link.hits == 0

      assert [%Link{original_url: ^valid_url, url_alias: ^url_alias}] = Repo.all(Link)
    end

    test "create_link/1 with invalid data returns error changeset" do
      Application.put_env(:url_shortener, :url_alias_length, 8)
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "create_url_alias/1 returns the URL alias with the hashed link" do
      Application.put_env(:url_shortener, :url_alias_length, 8)

      sample_url =
        "https://www.google.com/search?q=url+shortener&oq=google+u&aqs=chrome.0.69i59j69i60l3j0j69i57.1069j0j7&sourceid=chrome&ie=UTF-8"

      {:ok, url_alias} = Links.create_url_alias(sample_url)

      assert url_alias == "pNSqqt95"
    end

    test "get_link_by_short_url/1 returns the database record associated with the short URL" do
      link = insert!(:link, original_url: "http://example.com", url_alias: "12309127")
      short_url = "http://localhost:4000/#{link.url_alias}"

      {:ok, fetched_link} = Links.get_link_by_short_url(short_url)

      assert fetched_link.original_url == link.original_url
    end

    test "increment_link_hits_count/1 increments hits count by 1 in Link record" do
      link = insert!(:link, original_url: "http://example.com", url_alias: "12309127")

      assert link.hits == 0

      Links.increment_link_hits_count(link)

      updated_link = Links.get_link!(link.id)

      assert updated_link.original_url == link.original_url
      assert updated_link.url_alias == link.url_alias
      assert updated_link.hits == 1
    end

    test "delete_unused_links removes links that were not updated in the last X days" do
      Application.put_env(:url_shortener, :links_updated_at_threshold_days, 7)
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      seven_days_ago = NaiveDateTime.add(now, -1 * 7 * 60 * 60 * 24, :second)
      six_days_ago = NaiveDateTime.add(now, -1 * 6 * 60 * 60 * 24, :second)

      insert!(:link, updated_at: seven_days_ago)
      insert!(:link, updated_at: six_days_ago)

      Links.delete_unused_links()

      assert [%Link{updated_at: ^six_days_ago}] = Repo.all(Link)
    end
  end
end
