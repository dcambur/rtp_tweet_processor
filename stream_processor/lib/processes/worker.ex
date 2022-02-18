defmodule SSE.Process.Worker do
  @moduledoc """
  describes a process which handles the incoming data
  from the dispatcher
  """
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    {:ok, nil}
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([:tweet, msg], state) do
    IO.inspect(msg)
    Process.sleep(2500)
    {:noreply, nil}
  end

  def handle_cast([:panic, msg],  state) do
    IO.inspect(msg)
    Process.sleep(2500)
    {:noreply, nil}
  end

end
