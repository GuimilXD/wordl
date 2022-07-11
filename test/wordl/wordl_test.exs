defmodule World.WordlTest do
  use ExUnit.Case, async: true

  alias Wordl.Wordl

  describe "Wordl.Wordl" do
    test "score/1 calculates the score of a guess in a game of Wordl." do
      assert [:green, :green, :gray, :gray, :green] == Wordl.score("EGRET", "EGYPT")
      assert [:green, :green, :gray] == Wordl.score("SUN", "SUM")
    end
  end
end
