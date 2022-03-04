defmodule SSE.Supervisor.Scaler do
  @moduledoc """
  dispatcher process supervisor
  """
  use Supervisor

  @scaler_proc :scaler_proc

  def start_link(name) do
    Supervisor.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("scaler supervisor starts up...")

    children = [
      Supervisor.child_spec({SSE.Process.Scaler, @scaler_proc}, id: @scaler_proc)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
