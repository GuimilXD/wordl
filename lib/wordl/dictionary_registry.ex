defmodule Wordl.DictionaryRegistry do
  @name __MODULE__

  def start_link() do
    Registry.start_link(keys: :unique, name: @name)
  end

  def via_tuple(key) when is_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
