defmodule UrlShortenerWeb.LinkController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Links
  alias UrlShortener.Links.Link

  def new(conn, _params) do
    changeset = Links.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => incoming_params}) do
    parsed_params = link_params(incoming_params)

    case Links.create_link(parsed_params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: Routes.link_path(conn, :show, link))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    render(conn, "show.html", link: link)
  end

  defp link_params(%{"original_url" => original_url}) do
    %{original_url: original_url}
  end

  defp link_params(incoming_params), do: incoming_params
end
