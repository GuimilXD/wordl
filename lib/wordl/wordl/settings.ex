defmodule Wordl.Wordl.Settings do
  defstruct [
    word_length: Application.fetch_env!(:wordl, :default_word_length),
    max_tries: Application.fetch_env!(:wordl, :default_max_tries),
    dictionary: Application.fetch_env!(:wordl, :default_dictionary),
  ]

  @types %{word_length: :integer, max_tries: :integer, dictionary: :string}

  alias Wordl.Wordl.Settings
  import Ecto.Changeset

  def changeset(%Settings{} = settings, attrs) do
    {settings, @types}
    |> cast(attrs, Map.keys(@types))
  end
end
