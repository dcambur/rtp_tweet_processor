defmodule SSE.Main do
  @moduledoc """
  module created to run all children supervisors,
  Essentially, it is a main supervisor.
  """

  use Supervisor

  @tweet1 "http://127.0.0.1:4000/tweets/1"
  @tweet2 "http://127.0.0.1:4000/tweets/2"

  @listener_sup :listener_sup
  @worker_sup :worker_sup
  @dispatcher_sup :dispatcher_sup

  @doc """
  runs the main supervisor
  """
  def start() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    IO.puts("Main Supervisor init...")

    children = [
        Supervisor.child_spec({SSE.Supervisor.Worker, @worker_sup}, id: @worker_sup),
        Supervisor.child_spec({SSE.Supervisor.Listener, [@tweet1, @tweet2]}, id: @listener_sup),
        Supervisor.child_spec({SSE.Supervisor.Dispatcher, @dispatcher_sup}, id: @dispatcher_sup)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
