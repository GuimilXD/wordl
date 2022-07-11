defmodule DictionaryTest do
  use ExUnit.Case, async: true

  alias Wordl.Dictionary

  #TODO: Implement Property-based testing

  setup %{test: name} do
    {:ok, pid} = Dictionary.start_link(name: name)
    {:ok, name: name, pid: pid}
  end

  test "has_word? returns true if 5-letter word is in dictionary" do 
    assert Dictionary.has_word?("fox")
    assert Dictionary.has_word?("egret")
    refute Dictionary.has_word?("orace")
    refute Dictionary.has_word?("ummagumma")
  end

  test "random_word returns a random word with given length" do
    for i <- 2..20 do
      assert Dictionary.random_word(i) |> Dictionary.has_word?
      assert String.match?(Dictionary.random_word(i), ~r/^[a-z]{#{i}}$/)
    end

  end
end
