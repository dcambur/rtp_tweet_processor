defmodule SSE.Process.SentimentWorker do
  @moduledoc """
  describes a process which handles the incoming data
  from the dispatcher
  """
  use GenServer
  @worker_idle 50..500

  def start_link(scaler_proc) do
    GenServer.start_link(__MODULE__, scaler_proc, [])
  end

  def init(scaler_proc) do
    {:ok, scaler_proc}
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([:tweet, msg], scaler_proc) do
    #IO.puts("#{msg["tweet"]["user"]["name"]}")
    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, :dec)

    {:noreply, scaler_proc}
  end

  def handle_cast([:panic, msg],  scaler_proc) do
    #IO.puts("#{inspect(msg)}")
    Enum.random(@worker_idle)
    |> Process.sleep()

    GenServer.cast(scaler_proc, [:killonce, self()])

    {:noreply, scaler_proc}
  end
end
