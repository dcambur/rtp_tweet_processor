defmodule SSE.Supervisor.Worker do
  use Supervisor

  @worker1 :worker1
  @worker2 :worker2
  @worker3 :worker3
  def start_link(name) do
    Supervisor.start_link(__MODULE__, [], [name: name])
  end

  def init([]) do
    children = [
      Supervisor.child_spec({SSE.Process.Worker, @worker1}, id: @worker1),
      Supervisor.child_spec({SSE.Process.Worker, @worker2}, id: @worker2),
      Supervisor.child_spec({SSE.Process.Worker, @worker3}, id: @worker3)

    ]

    Supervisor.init(children, [strategy: :one_for_one])
  end
end
