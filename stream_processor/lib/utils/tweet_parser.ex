defmodule SSE.Utils.TweetParser do
  @moduledoc """
  utility module for processing SSE strings into
  key-value data structure in Elixir
  """

  @event_ok "event: \"message\"\n\ndata: "
  @event_panic "event: \"message\"\n\ndata: {\"message\": panic}\n\n"
  @panic_msg %{error: "TODO: Implement Worker Kill"}
  @dispatcher_proc :dispatcher_proc

  @doc """
  handles data cast to dispatcher and its convertation to key-value structure
  """
  def process(raw_msg) do
    cond do
      String.contains?(raw_msg, @event_panic) -> send_panic()

      String.contains?(raw_msg, @event_ok) -> raw_msg
      |> String.split(@event_ok)
      |> Poison.decode!()
      |> send_message()

    end

  end

  defp send_message(message) do
    GenServer.cast(@dispatcher_proc, [:tweet, message])
  end

  defp send_panic() do
    GenServer.cast(@dispatcher_proc, [:panic, @panic_msg])
  end
end
