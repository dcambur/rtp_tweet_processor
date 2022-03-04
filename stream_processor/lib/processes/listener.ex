defmodule SSE.Process.Listener do
  @moduledoc """
  a process for listening the tweet1 and tweet2 feeds of the SSE Streaming API
  """
  use GenServer

  @dispatcher_proc :dispatcher_proc

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init([url: url]) do
    IO.puts("listener process starts up on #{url}...")
    HTTPoison.get!(url, [], [recv_timeout: :infinity, stream_to: self()])
    {:ok, nil}
  end

  @doc """
  processes incoming info and sends the main data to dispatcher process
  """
  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, _state) do
    SSE.Utils.TweetParser.process(@dispatcher_proc, chunk)

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, _state) do
    IO.puts("Connection status: #{inspect(status)}")

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, _state) do
    IO.puts("Connection headers: #{inspect(headers)}")

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncEnd{}, _state) do
    {:noreply, nil}
  end
end
