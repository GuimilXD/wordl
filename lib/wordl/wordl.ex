defmodule Wordl.Wordl do
  alias Wordl.Wordl
  alias Wordl.GameLogic
  alias Wordl.Settings

  defdelegate score(target, guess), to: GameLogic, as: :score

  def change_settings(%Settings{} = settings, attrs \\ %{}) do
    Settings.changeset(settings, attrs)
  end
end
