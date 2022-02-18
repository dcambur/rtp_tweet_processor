defmodule SSE.Process.Listener do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init([url: url]) do
    IO.puts("Connecting to stream...")
    HTTPoison.get!(url, [], [recv_timeout: :infinity, stream_to: self()])
    {:ok, nil}

  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, _state) do
    SSE.Utils.TweetParser.process(chunk)

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, _state) do
    IO.puts("Connection status: #{inspect(status)}")

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, _state) do
    IO.puts"Connection headers: #{inspect(headers)}"

    {:noreply, nil}
  end

end
