defmodule Wordl.WordlLiveTest do
  use WordlWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # TODO: Implement Mocking & Improve Testing
  describe "WordlLive" do
    test "gives feedback on guesses based on correct word", %{conn: conn} do
      guesses = ~w(quick piano likes crazy notes)

      {:ok, view, _html} = live(conn, "/")

      refute view_has_words?(view, guesses)

      for guess <- guesses  do
	view
	|> type_word_into_view(guess)
	|> make_guess
      end

      assert view_has_words?(view, guesses)
    end
  end

  defp view_has_words?(view, words) do
    Enum.any?(words, &(view_has_word?(view, &1)))
  end

  defp view_has_word?(view, word) do
    word
    |> String.graphemes()
    |> Enum.any?(&(view_has_letter?(view, &1)))
  end

  defp view_has_letter?(view, letter) do
    view
    |> element("#cell-letter", letter)
    |> has_element?()
  end

  defp type_word_into_view(view, word) do
    String.graphemes(word)
    |> Enum.each(fn letter ->
      render_keydown(view, "update", %{"key" => letter})
    end)

    view
  end

  defp make_guess(view) do
    view
    |> render_keydown("update", %{"key" => "Enter"})
  end
end
