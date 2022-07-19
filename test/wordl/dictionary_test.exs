defmodule DictionaryTest do
  use ExUnit.Case, async: true

  alias Wordl.Dictionary

  describe "dictionary" do
    setup do
      dict_name = "test_dict"

      Dictionary.start_link(name: dict_name, path: "assets/dictionaries/English.txt")

      %{dict_name: dict_name}
    end

    test "has_word/2 returns true is word in is dictionary", %{dict_name: dict_name} do
      assert Dictionary.has_word?(dict_name, "quick")
      refute Dictionary.has_word?(dict_name, "olá")
    end

    test "has_word/2 ignores accents" do
      Dictionary.start_link(name: "spanish", path: "assets/dictionaries/Spanish.txt")

      assert Dictionary.has_word?("spanish", "ábaco")
      assert Dictionary.has_word?("spanish", "abaco")
    end

    test "random_word/2 returns a random word with a given length", %{dict_name: dict_name} do
      random_word = Dictionary.random_word(dict_name, 5)
      assert Dictionary.has_word?(dict_name, random_word)
      assert String.length(random_word) == 5
    end
  end
end
