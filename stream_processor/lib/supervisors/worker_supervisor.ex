defmodule SSE.Supervisor.Worker do
  @moduledoc """
  worker process supervisor with a function to
  dynamically create a worker on demand
  """
  use DynamicSupervisor

  @worker_sup :worker_sup
  @worker_proc SSE.Process.Worker

  def start_link(name) do
    DynamicSupervisor.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    IO.puts("worker supervisor starts up...")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_child() do
    child_spec = %{
      id: :worker,
      start: {@worker_proc, :start_link, []},
      type: :worker,
      restart: :transient,
    }
    DynamicSupervisor.start_child(@worker_sup, child_spec)
  end

  @doc """
  terminates first child in the list
  """
  def free_child() do
    child = DynamicSupervisor.which_children(@worker_sup)
    {_, child_pid, _, _ } = Enum.at(child, 0)

    DynamicSupervisor.terminate_child(@worker_sup, child_pid)
  end
end
