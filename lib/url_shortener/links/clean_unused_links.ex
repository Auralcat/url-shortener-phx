defmodule UrlShortener.CleanUnusedLinks do
  @moduledoc """
  Holds the functions to clean unused links in the database.

  As users add more links to the system, the database using them
  grows larger and larger, and performance in it degrades over time.

  To handle this, we need to periodically remove links that are not used from
  the database.
  """

  alias UrlShortener.Links

  require Logger

  def delete_unused_links do
    Logger.info("Cleaning unused links...")

    {count, _} = Links.delete_unused_links()

    Logger.info("Removed #{count} links unused in the last 7 days.")
  end
end
