defmodule Wordl.Dictionary do
  use GenServer

  @name __MODULE__

  @impl true
  def init(opts) do
    path = Keyword.get(opts, :path, "priv/static/assets/words.txt")

    send(self(), {:read_file, path})

    {:ok, nil}
  end

  @impl true
  def handle_info({:read_file, path}, _) do
    dict =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.filter(fn word -> String.match?(word, ~r/^[a-z]+$/) end)

    {:noreply, dict}
  end

  @impl true
  def handle_call({:has_word?, word}, _, dict) do
   {:reply, word in dict, dict}
  end

  @impl true
  def handle_call({:random_word, length}, _, dict) do
   {:reply, Enum.filter(dict, &(String.length(&1) == length)) |> Enum.random(), dict}
  end

  def has_word?(word) when is_binary(word) do
    GenServer.call(@name, {:has_word?, word})
  end

  def has_word?(word), do: word |> to_string() |> has_word?

  def random_word(length) do
    GenServer.call(@name, {:random_word, length})
  end

  def start_link(opts) do
    name = Keyword.get(opts, :name, @name)

    GenServer.start_link(__MODULE__, opts, name: name)
  end
end
