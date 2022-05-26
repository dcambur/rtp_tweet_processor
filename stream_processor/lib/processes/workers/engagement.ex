defmodule SSE.Process.EngagementWorker do
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

  def calculate_engagement(favorites, retweets, followers) when followers != 0 do
    (favorites+retweets) / followers
  end

  def calculate_engagement(favorites, retweets, followers) when followers == 0 do
    0.0
  end

  @doc """
  async function to handle common data and event errors
  """
  def handle_cast([:tweet, msg], scaler_proc) do
    IO.inspect(calculate_engagement(msg["favorite_count"], msg["retweet_count"], msg["user"]["followers_count"]))
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
