defmodule SSE.Process.Worker do
  @moduledoc """
  describes a process which handles the incoming data
  from the dispatcher
  """
  use GenServer

  @scaler_proc :scaler_proc
  @worker_idle 50..500

  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init([]) do
    {:ok, nil}
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([:tweet, msg], _state) do
    # IO.inspect(msg["tweet"]["user"]["name"])

    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(@scaler_proc, :dec)

    {:noreply, nil}
  end

  def handle_cast([:panic, msg],  _state) do
    IO.inspect(msg)

    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(@scaler_proc, [:killonce, self()])

    {:noreply, nil}
  end
end
