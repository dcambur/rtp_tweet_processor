defmodule SSE.Utils.TweetParser do
  @moduledoc """
  utility module for processing SSE strings into
  key-value data structure in Elixir
  """

  @event_ok "event: \"message\"\n\ndata: "
  @event_panic "event: \"message\"\n\ndata: {\"message\": panic}\n\n"
  @panic_msg %{error: "Panic! Worker terminates forcefully."}

  @doc """
  handles data cast to dispatcher and its convertation to key-value structure
  """
  def process(send_to, raw_msg) do
    cond do
      String.contains?(raw_msg, @event_panic) -> send_panic(send_to)

      String.contains?(raw_msg, @event_ok) -> raw_msg
      |> sse_to_dict()
      |> send_message(send_to)

      true -> nil
    end

  end

  defp sse_to_dict(string) do
    String.split(string, @event_ok)
    |> Poison.decode!()
  end

  defp send_message(message, process_name) do
    GenServer.cast(process_name, [:tweet, message])
  end

  defp send_panic(process_name) do
    GenServer.cast(process_name, [:panic, @panic_msg])
  end
end
