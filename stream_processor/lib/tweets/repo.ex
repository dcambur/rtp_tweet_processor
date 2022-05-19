defmodule Tweets.Repo do
  use Ecto.Repo,
    otp_app: :stream_processor,
    adapter: Ecto.Adapters.Postgres
end
