defmodule DictionaryRegistererTest do
  use ExUnit.Case, async: true

  alias Wordl.DictionaryRegisterer

  @dictionary_dir_path Application.fetch_env!(:wordl, :dictionaries_dir_path)

  describe "dictionary registerer" do
    test "list_dictionaries/0 returns all dictionaries in dir" do
      dicts_name =
	Path.join(@dictionary_dir_path, "*.txt")
	|> Path.wildcard()
	|> Enum.map(&(Path.basename(&1, ".txt")))
	|> Enum.sort()

      assert Enum.all?(dicts_name, &Enum.member?(DictionaryRegisterer.list_dictionaries(), &1))
    end

    test "add_dictionaries/2 adds to list and registers new dictionary" do
      assert :ok == DictionaryRegisterer.add_dictionary("assets/dictionaries/English.txt", "test_dict")
      assert "test_dict" in DictionaryRegisterer.list_dictionaries
    end
  end
end
