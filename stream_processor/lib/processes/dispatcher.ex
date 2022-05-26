defmodule SSE.Process.Dispatcher do
  @moduledoc """
  a process which regulates the incoming
  tweet streams from tweet1 and tweet2 feeds.
  """
  use GenServer

  def start_link([name, worker_sup, scaler_proc]) do
    GenServer.start_link(__MODULE__, [worker_sup, scaler_proc], [name: name])
  end

  def init([worker_sup, scaler_proc]) do
    IO.puts("dispatcher process starts up...")

    {:ok, [1, worker_sup, scaler_proc]}
  end

  @doc """
  async handling for messages,
  finds the number of current workers under the worker supervisor
  and makes a cast via round-robin algorithm
  """
  def handle_cast([:tweet, msg], [state, worker_sup, scaler_proc]) do
    GenServer.cast(scaler_proc, :inc)

    worker_pids = DynamicSupervisor.which_children(worker_sup)
    worker_total = length(worker_pids)

    new_state = round_robin(state, worker_total)

    {_id, pid, _type, _module} = Enum.at(worker_pids, new_state)

    GenServer.cast(pid, [:tweet, msg["message"]])

    {:noreply, [new_state, worker_sup, scaler_proc]}
  end

  def handle_cast([:panic, msg], [state, worker_sup, scaler_proc]) do
    worker_pids = Supervisor.which_children(worker_sup)
    worker_total = length(worker_pids)

    new_state = round_robin(state, worker_total)

    {_id, pid, _type, _module} = Enum.at(worker_pids, state)

    GenServer.cast(pid, [:panic, msg])

    {:noreply, [new_state, worker_sup, scaler_proc]}
  end

  @doc """
  round-robin counter for workers
  """
  def round_robin(current_state, pid_len) when current_state < pid_len-1 do
    current_state + 1
  end

  def round_robin(current_state, pid_len) when current_state >= pid_len-1 do
    1
  end
end
