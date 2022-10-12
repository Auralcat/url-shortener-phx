defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links
  alias UrlShortenerWeb.Router.Helpers, as: Routes

  def index(conn, %{"short_url" => short_url}) do
    case Links.get_link_by_short_url(short_url) do
      {:ok, link} ->
        Links.increment_link_hits_count(link)
        redirect(conn, external: link.original_url)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.link_path(conn, :new))
    end
  end
end
