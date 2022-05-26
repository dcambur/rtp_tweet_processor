defmodule SSE.Supervisor.Listener do
  @moduledoc """
  listener process supervisor
  """
  use Supervisor

  def start_link([[tweet1, tweet2], disp_list]) do
    Supervisor.start_link(__MODULE__, [[tweet1, tweet2], disp_list])
  end

  def init([[tweet1, tweet2], disp_list]) do
    IO.puts("listener supervisor starts up...")

    children = [
      Supervisor.child_spec({SSE.Process.Listener, [tweet1, disp_list]}, id: :feed1),
      Supervisor.child_spec({SSE.Process.Listener, [tweet2, disp_list]}, id: :feed2)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
