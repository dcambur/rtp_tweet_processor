defmodule SSE.Process.Scaler do
  use GenServer

  @worker_sup :worker_sup

  @min_workers 30
  @worker_idle 500

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("scaler process starts up...")

    set_workers(@min_workers)
    children = DynamicSupervisor.count_children(@worker_sup)
    IO.puts("current workers:#{children.active}")
    Process.send_after(self(), :time_trigg, @worker_idle)

    {:ok, 0}
  end

  def handle_info(:time_trigg, cur_tweets) do
    children = DynamicSupervisor.count_children(@worker_sup)

    dist = cur_tweets - children.active + @min_workers

    IO.puts("current workers:#{children.active}")
    IO.puts("current tweets:#{cur_tweets}")


    set_workers(dist)

    Process.send_after(self(), :time_trigg, @worker_idle)

    {:noreply, cur_tweets}
  end

  def handle_cast([:killonce, pid], cur_tweets) do
    DynamicSupervisor.terminate_child(@worker_sup, pid)
    {:noreply, cur_tweets}
  end

  def handle_cast(:inc, cur_tweets) do
    {:noreply, cur_tweets + 1}
  end

  def handle_cast(:dec, cur_tweets) do
    {:noreply, cur_tweets - 1}
  end

  def set_workers(quantity) when quantity > 0 do
    SSE.Supervisor.Worker.add_child()
    set_workers(quantity - 1)
  end

  def set_workers(quantity) when quantity < 0 do
    SSE.Supervisor.Worker.free_child()
    set_workers(quantity + 1)
  end

  def set_workers(quantity) when quantity === 0 do
    {:ok, nil}
  end

end
