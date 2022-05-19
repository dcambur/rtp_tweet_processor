defmodule SSE.App do
  use Application

  def start(_type, _args) do
    children = [
      SSE.Supervisor.Main,
      Tweets.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, type: :supervisor)
  end
end
