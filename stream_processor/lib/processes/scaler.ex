defmodule SSE.Process.Scaler do
  use GenServer

  @min_workers 30
  @worker_idle 500

  def start_link([name, worker_sup, worker_type]) do
    GenServer.start_link(__MODULE__, [name, worker_sup, worker_type], [name: name])
  end

  def init([scaler_proc, worker_sup, worker_type]) do
    IO.puts("scaler process starts up... signals for #{@min_workers} workers to start up.")
    set_workers(@min_workers, scaler_proc, worker_sup, worker_type)
    children = DynamicSupervisor.count_children(worker_sup)
    Process.send_after(self(), :time_trigg, @worker_idle)

    {:ok, [0, scaler_proc, worker_sup, worker_type]}
  end

  def handle_info(:time_trigg, [cur_tweets, scaler_proc, worker_sup, worker_type]) do
    children = DynamicSupervisor.count_children(worker_sup)

    dist = cur_tweets - children.active + @min_workers

    IO.puts("current #{Atom.to_string(worker_type)} workers for #{worker_sup} supervisor:#{children.active}")
    IO.puts("current #{Atom.to_string(worker_type)} tweets for #{worker_sup} supervisor:#{cur_tweets}\n\n")


    set_workers(dist, scaler_proc, worker_sup, worker_type)

    Process.send_after(self(), :time_trigg, @worker_idle)

    {:noreply, [cur_tweets, scaler_proc, worker_sup, worker_type]}
  end

  def handle_cast([:killonce, pid], [cur_tweets, scaler_proc, worker_sup, worker_type]) do
    DynamicSupervisor.terminate_child(worker_sup, pid)
    {:noreply, [cur_tweets, scaler_proc, worker_sup, worker_type]}
  end

  def handle_cast(:inc, [cur_tweets, scaler_proc, worker_sup, worker_type]) do
    {:noreply, [cur_tweets + 1, scaler_proc, worker_sup, worker_type]}
  end

  def handle_cast(:dec, [cur_tweets, scaler_proc, worker_sup, worker_type]) do
    {:noreply, [cur_tweets - 1, scaler_proc, worker_sup, worker_type]}
  end

  def set_workers(quantity, scaler_proc, worker_sup, worker_type) when quantity > 0 and worker_type == :sentiment do
    SSE.Supervisor.SentimentWorker.add_child(scaler_proc, worker_sup)
    set_workers(quantity - 1, scaler_proc, worker_sup, worker_type)
  end

  def set_workers(quantity, scaler_proc, worker_sup, worker_type) when quantity > 0 and worker_type == :engagement do
    SSE.Supervisor.EngagementWorker.add_child(scaler_proc, worker_sup)
    set_workers(quantity - 1, scaler_proc, worker_sup, worker_type)
  end

  def set_workers(quantity, scaler_proc, worker_sup, worker_type) when quantity < 0 and worker_type == :sentiment do
    SSE.Supervisor.SentimentWorker.free_child(worker_sup)
    set_workers(quantity + 1, scaler_proc, worker_sup, worker_type)
  end

  def set_workers(quantity, scaler_proc, worker_sup, worker_type) when quantity < 0 and worker_type == :engagement do
    SSE.Supervisor.EngagementWorker.free_child(worker_sup)
    set_workers(quantity + 1, scaler_proc, worker_sup, worker_type)
  end

  def set_workers(quantity, scaler_proc, worker_sup, worker_type) when quantity === 0 do
    {:ok, nil}
  end

end
