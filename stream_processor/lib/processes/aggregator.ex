defmodule SSE.Process.Aggregator do

  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("aggregator process starts up...")

    {:ok, {}, 0}
  end

end
