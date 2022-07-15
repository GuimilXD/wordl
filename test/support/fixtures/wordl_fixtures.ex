defmodule Wordl.WordlFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wordl.Wordl` context.
  """

  @doc """
  Generate new settings.
  """
  def settings_fixture(attrs \\ %{}) do
    {:ok, settings} =
      attrs
      |> Enum.into(%{
        max_tries: 6,
        word_length: 5,
        dictionary: "en_US",
	session_id: Ecto.UUID.generate()
      })
      |> Wordl.Wordl.create_settings()

      settings
  end
end
