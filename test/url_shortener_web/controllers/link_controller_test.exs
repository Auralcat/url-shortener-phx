defmodule UrlShortenerWeb.LinkControllerTest do
  use UrlShortenerWeb.ConnCase

  @create_attrs %{original_url: "https://example.com"}
  @invalid_attrs %{original_url: "http://invalid"}

  describe "new link" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :new))
      assert html_response(conn, 200) =~ "Shorten your URLs"
    end
  end

  describe "create link" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.link_path(conn, :show, id)

      conn = get(conn, Routes.link_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Link"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @invalid_attrs)
      assert html_response(conn, 200) =~ "Shorten your URLs"
    end
  end
end
