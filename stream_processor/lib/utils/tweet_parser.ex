defmodule SSE.Utils.TweetParser do

  @event_ok "event: \"message\"\n\ndata: "
  @event_panic "event: \"message\"\n\ndata: {\"message\": panic}\n\n"
  @empty_list []
  @panic_msg %{error: "TODO: Implement Worker Kill"}
  @dispatcher_proc :dispatcher_proc

  def process(raw_msg) do
    cond do
      String.contains?(raw_msg, @event_panic) -> send_panic()

      String.contains?(raw_msg, @event_ok) -> raw_msg
      |> String.split(@event_ok)
      |> Poison.decode!()
      |> send_message()

    end

  end

  def send_message(message) do
    GenServer.cast(@dispatcher_proc, [:tweet, message])
  end

  def send_panic() do
    GenServer.cast(@dispatcher_proc, [:panic, @panic_msg])
  end
end
