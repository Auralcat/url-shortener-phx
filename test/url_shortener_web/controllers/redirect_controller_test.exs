defmodule UrlShortenerWeb.RedirectControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Links
  import UrlShortener.Factory

  describe "index/2" do
    test "redirects to original URL when given short URL and increments hit count", %{conn: conn} do
      original_url = "https://example.com"
      url_alias = "12345678"
      short_url = "http://localhost:4000/#{url_alias}"

      link = insert!(:link, original_url: original_url, url_alias: url_alias, hits: 0)

      conn = get(conn, Routes.redirect_path(conn, :index, short_url))

      assert redirected_to(conn) == original_url

      updated_link = Links.get_link!(link.id)

      assert updated_link.hits == 1
    end

    test "redirects to new short URL page when short URL is invalid", %{conn: conn} do
      conn = get(conn, Routes.redirect_path(conn, :index, "http://bad URL"))

      assert redirected_to(conn) == Routes.link_path(conn, :new)
    end

    test "redirects to new short URL page when short URL is not in the database", %{conn: conn} do
      short_url = "http://localhost:4000/something_valid"
      conn = get(conn, Routes.redirect_path(conn, :index, short_url))

      assert redirected_to(conn) == Routes.link_path(conn, :new)
    end
  end
end
