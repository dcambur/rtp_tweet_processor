defmodule SSE.Supervisor.Listener do
  @moduledoc """
  listener process supervisor
  """
  use Supervisor


  def start_link([tweet1, tweet2]) do
    Supervisor.start_link(__MODULE__, [tweet1, tweet2])
  end

  def init([tweet1, tweet2]) do
    children = [
      Supervisor.child_spec({SSE.Process.Listener, url: tweet1}, id: :feed1),
      Supervisor.child_spec({SSE.Process.Listener, url: tweet2}, id: :feed2)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
