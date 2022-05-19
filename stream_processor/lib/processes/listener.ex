defmodule SSE.Process.Listener do
  @moduledoc """
  a process for listening the tweet1 and tweet2 feeds of the SSE Streaming API
  """
  use GenServer

  @dispatcher_proc :dispatcher_proc
  @reconnection_time 3000

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init([url: url]) do
    IO.puts("listener process starts up on #{url}...")
    GenServer.cast(self(), :start_stream)

    {:ok, url}
  end

  @doc """
  processes incoming info and sends the main data to dispatcher process
  """
  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, url) do
    SSE.Utils.TweetParser.process(@dispatcher_proc, chunk)

    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, url) do
    IO.puts("Connection status #{inspect(self())}: #{inspect(status)}")

    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, url) do
    IO.puts("Connection headers #{inspect(self())}: #{inspect(headers)}")

    {:noreply, url}
  end

  def handle_info(%HTTPoison.AsyncEnd{}, url) do
    IO.puts("Connection to the stream feed ends... reconnecting after #{@reconnection_time} ms")
    Process.sleep(@reconnection_time)

    GenServer.cast(self(), :start_stream)

    {:noreply, url}
  end

  def handle_cast(:start_stream, url) do

    HTTPoison.get!(url, [], [
      recv_timeout: 10_000,
      timeout: 10_000,
      stream_to: self(),
      hackney: [pool: :default],
       ])

    {:noreply, url}
  end
end
