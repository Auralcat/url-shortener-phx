defmodule UrlShortenerWeb.LinkControllerTest do
  use UrlShortenerWeb.ConnCase

  describe "new link" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :new))
      assert html_response(conn, 200) =~ "Shorten your URLs"
    end
  end

  describe "create link" do
    test "redirects to show when data is valid", %{conn: conn} do
      original_url = "https://example.com"
      url_alias = "DKrySrGg"

      create_attrs = %{original_url: original_url, url_alias: url_alias}
      conn = post(conn, Routes.link_path(conn, :create), link: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.link_path(conn, :show, id)

      conn = get(conn, Routes.link_path(conn, :show, id))

      short_url = "#{UrlShortenerWeb.Endpoint.url()}/#{url_alias}"

      assert html_response(conn, 200) =~ short_url
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{original_url: "not a URL"}
      conn = post(conn, Routes.link_path(conn, :create), link: invalid_attrs)
      assert html_response(conn, 200) =~ "Shorten your URLs"
    end
  end
end
