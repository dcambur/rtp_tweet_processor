defmodule STREAM_PROCESSORTest do
  use ExUnit.Case
  doctest STREAM_PROCESSOR

  test "greets the world" do
    assert STREAM_PROCESSOR.hello() == :world
  end
end
