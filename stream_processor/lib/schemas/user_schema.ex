defmodule Schemas.User do
  use Ecto.Schema

  schema "user" do
    field :username, :string
  end
end
