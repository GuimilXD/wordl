defmodule Wordl.Dictionary do
  use GenServer

  @impl true
  def init(opts) do
    path = Keyword.fetch!(opts, :path)

    send(self(), {:read_file, path})

    {:ok, nil}
  end

  @impl true
  def handle_info({:read_file, path}, _) do
    dict =
      File.read!(path)
      |> String.split("\n", trim: true)

    {:noreply, dict}
  end

  @impl true
  def handle_call({:has_word?, word}, _, dict) do
    word_without_accents = to_ascii(word)

    has_word? = Enum.any?(dict, &(to_ascii(&1) == word_without_accents))

    {:reply, has_word?, dict}
  end

  @impl true
  def handle_call({:random_word, length}, _, dict) do
   {:reply, Enum.filter(dict, &(String.length(&1) == length)) |> Enum.random(), dict}
  end

  def has_word?(dict_name, word) when is_binary(word) do
    GenServer.call(via_tuple(dict_name), {:has_word?, word})
  end

  def has_word?(dict_name, word) do
    has_word?(dict_name, to_string(word))
  end

  def random_word(dict_name, length) do
    GenServer.call(via_tuple(dict_name), {:random_word, length})
  end

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)

    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  defp via_tuple(dict_name) do
    Wordl.DictionaryRegistry.via_tuple({__MODULE__, dict_name})
  end

  defp to_ascii(string) do string
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.downcase()
  end
end
