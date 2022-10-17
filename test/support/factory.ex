defmodule UrlShortener.Factory do
  @moduledoc false

  alias UrlShortener.Repo

  # Factories

  def build(:link) do
    %UrlShortener.Links.Link{
      original_url: Faker.Internet.url(),
      url_alias: Faker.String.base64(8)
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
