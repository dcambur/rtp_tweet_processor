defmodule SSE.Process.Dispatcher do
  @moduledoc """
  a process which regulates the incoming
  tweet streams from tweet1 and tweet2 feeds.
  """
  use GenServer

  @worker_sup :worker_sup

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    {:ok, 1}
  end

  @doc """
  async handling for messages,
  finds the number of current workers under the worker supervisor
  and makes a cast via round-robin algorithm
  """
  def handle_cast([:tweet, msg], state) do
    worker_pids = Supervisor.which_children(@worker_sup)
    worker_total = length(worker_pids)

    GenServer.cast(:"worker#{state}", [:tweet, msg["message"]["tweet"]["user"]["name"]])
    new_state = round_robin(state, worker_total)


    {:noreply, new_state}
    end

  def handle_cast([:panic, msg], state) do
    worker_pids = Supervisor.which_children(@worker_sup)
    worker_total = length(worker_pids)


    GenServer.cast(:"worker#{state}", [:panic, msg])
    new_state = round_robin(state, worker_total)

    {:noreply, new_state}
  end

  @doc """
  round-robin counter for workers
  """
  def round_robin(current_state, pid_len) when current_state < pid_len do
    current_state + 1
  end

  def round_robin(current_state, pid_len) when current_state >= pid_len do
    1
  end
end
