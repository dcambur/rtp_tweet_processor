defmodule SSE.Supervisor.Pool do
  @moduledoc """
  module created to run all children supervisors,
  Essentially, it is a main supervisor.
  """

  use Supervisor

  @doc """
  runs the main supervisor
  """
  def start_link([pool_sup: name, worker_sup: worker_sup, disp_proc: disp_proc, scaler_proc: scaler_proc, type: type]) do
    Supervisor.start_link(__MODULE__, [worker_sup, disp_proc, scaler_proc, type], name: name)
  end

  def init([worker_sup, dispatch_proc, scaler_proc, type]) when type == :engagement do
    IO.puts("engagement pool supervisor #{inspect(self())} starts up...")

    children = [
        Supervisor.child_spec({SSE.Supervisor.EngagementWorker, worker_sup}, id: worker_sup),
        Supervisor.child_spec({SSE.Process.Scaler, [scaler_proc, worker_sup, type]}, id: scaler_proc),
        Supervisor.child_spec({SSE.Process.Dispatcher, [dispatch_proc, worker_sup, scaler_proc]}, id: dispatch_proc),
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def init([worker_sup, dispatch_proc, scaler_proc, type]) when type == :sentiment do
    IO.puts("sentiment pool supervisor #{inspect(self())} starts up...")

    children = [
        Supervisor.child_spec({SSE.Supervisor.SentimentWorker, worker_sup}, id: worker_sup),
        Supervisor.child_spec({SSE.Process.Scaler, [scaler_proc, worker_sup, type]}, id: scaler_proc),
        Supervisor.child_spec({SSE.Process.Dispatcher, [dispatch_proc, worker_sup, scaler_proc]}, id: dispatch_proc),
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def init([worker_sup, dispatch_proc, scaler_proc, type]) do
    raise "worker pool: wrong type"
  end

end
