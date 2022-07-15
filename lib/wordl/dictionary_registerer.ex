defmodule Wordl.DictionaryRegisterer do
  @moduledoc """
  This module registers all dictionaries in given directory and holds on to a list 
  """
  use GenServer

  alias Wordl.Dictionary

  @name __MODULE__

  @impl true
  def init(opts) do
    path = Keyword.fetch!(opts, :path)

    register_dictionaries_in_dir(path)

    {:ok, []}
  end

  @impl true
  def handle_cast({:add_dictionary, path, name}, dictionaries) do
    Dictionary.start_link(path: path, name: name)
    
    {:noreply, [name | dictionaries]}
  end

  @impl true
  def handle_call(:list_dictionaries, _, dictionaries) do
    {:reply, Enum.sort(dictionaries), dictionaries}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def add_dictionary(path, name) do
    GenServer.cast(@name, {:add_dictionary, path, name})
  end

  def list_dictionaries() do
    GenServer.call(@name, :list_dictionaries)
  end

  defp register_dictionaries_in_dir(path) do
    Path.join(path, "*.txt")
    |> Path.wildcard()
    |> Enum.each(&(add_dictionary(&1, extract_name_from_path(&1))))
  end

  defp extract_name_from_path(path) do
    Path.basename(path, ".txt")
  end
end
