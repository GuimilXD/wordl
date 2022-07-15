defmodule World.WordlTest do
  use Wordl.DataCase, async: true

  import Wordl.WordlFixtures

  alias Wordl.Wordl.Settings
  alias Wordl.Wordl

  describe "Wordl.Wordl" do

    @invalid_attrs %{session_id: nil}
    
    test "score/1 calculates the score of a guess in a game of Wordl." do
      assert [:green, :green, :gray, :gray, :green] == Wordl.score("EGRET", "EGYPT")
      assert [:green, :green, :gray] == Wordl.score("SUN", "SUM")
    end

    test "change_settings/1 returns a settings changeset" do
      settings = settings_fixture()
      assert %Ecto.Changeset{} = Wordl.change_settings(settings)
    end

    test "create_settings/1 with valid data creates new settings" do
      session_id = Ecto.UUID.generate()
      valid_attrs = %{session_id: session_id, dictionary: "pt_BR", max_tries: 5, word_length: 6}

      assert {:ok, %Settings{} = settings} = Wordl.create_settings(valid_attrs)
      assert settings.session_id == session_id
      assert settings.dictionary == "pt_BR"
      assert settings.max_tries == 5
      assert settings.word_length == 6
    end

    test "insert_or_update_settings/2 with valid data updates the settings" do
      settings = settings_fixture()
      update_attrs = %{dictionary: "en_US", max_tries: 4, word_length: 5}

      assert {:ok, %Settings{} = settings} = Wordl.insert_or_update_settings(settings, update_attrs)
      assert settings.dictionary == "en_US"
      assert settings.max_tries == 4
      assert settings.word_length == 5
    end

    test "insert_or_update_settings/2 with invalid data returns error changeset" do
      settings = settings_fixture()
      assert {:error, %Ecto.Changeset{}} = Wordl.insert_or_update_settings(settings, @invalid_attrs)

      updated_settings = Settings.for_session(%{"session_id" => settings.session_id})

      assert settings.session_id == updated_settings.session_id
      assert settings.dictionary == updated_settings.dictionary
      assert settings.max_tries == updated_settings.max_tries
      assert settings.word_length == updated_settings.word_length
    end
  end
end
