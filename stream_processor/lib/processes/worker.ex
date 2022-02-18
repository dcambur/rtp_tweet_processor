defmodule SSE.Process.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    {:ok, nil}
  end

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
