defmodule Wordl.Wordl do
  alias Wordl.Repo

  alias Wordl.Wordl
  alias Wordl.GameLogic
  alias Wordl.Settings

  defdelegate score(target, guess), to: GameLogic, as: :score

  def create_settings(attrs \\ %{}) do
    %Settings{}
    |> Settings.changeset(attrs)
    |> Repo.insert()
  end

  def change_settings(%Settings{} = settings, attrs \\ %{}) do
    Settings.changeset(settings, attrs)
  end

  def insert_or_update_settings(%Settings{} = settings, attrs \\ %{}) do
    Settings.changeset(settings, attrs)
    |> Repo.insert_or_update()
  end
end
