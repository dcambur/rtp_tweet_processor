defmodule SSE.Supervisor.Dispatcher do
  @moduledoc """
  dispatcher process supervisor
  """
  use Supervisor

  @dispatcher_proc :dispatcher_proc

  def start_link(name) do
    Supervisor.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("dispatcher supervisor starts up...")

    children = [
      Supervisor.child_spec({SSE.Process.Dispatcher, @dispatcher_proc}, id: @dispatcher_proc)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
