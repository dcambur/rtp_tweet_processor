defmodule Schemas.Tweets do
  use Ecto.Schema

  schema "tweets" do
    field :sentiment, :decimal
    field :engagement, :decimal
  end
end
