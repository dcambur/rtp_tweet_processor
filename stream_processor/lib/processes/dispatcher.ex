defmodule SSE.Process.Dispatcher do

  use GenServer

  @worker_sup :worker_sup

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    {:ok, 1}
  end

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

  def round_robin(current_state, pid_len) when current_state < pid_len do
    current_state + 1
  end

  def round_robin(current_state, pid_len) when current_state >= pid_len do
    1
  end
end
