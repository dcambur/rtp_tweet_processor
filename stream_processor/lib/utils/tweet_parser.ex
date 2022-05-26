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
  def process(raw_msg) do
    cond do
      String.contains?(raw_msg, @event_panic) -> give_panic()

      String.contains?(raw_msg, @event_ok) -> raw_msg
      |> sse_to_dict()
      |> give_message()

      true -> nil
    end

  end

  defp sse_to_dict(string) do
    String.split(string, @event_ok)
    |> Poison.decode!()
  end

  defp give_message(message) do
    [:tweet, message["message"]["tweet"]]
  end

  defp give_panic() do
    [:panic, @panic_msg]
  end
end
