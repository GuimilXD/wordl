defmodule Wordl.WordlLiveTest do
  use WordlWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # TODO: Implement Mocking & Improve Testing
  describe "WordlLive" do
    test "shows typed word", %{conn: conn} do
      word = "quick"

      {:ok, view, _html} = live(conn, "/")

      refute view_has_word?(view, word)

      type_word_into_view(view, word)

      assert view_has_word?(view, word)
    end
  end

  defp view_has_word?(view, word) do
    word
    |> String.graphemes()
    |> Enum.any?(&(view_has_letter?(view, &1)))
  end

  defp view_has_letter?(view, letter) do
    view
    |> element("#cell-letter-#{letter}")
    |> has_element?()
  end

  defp type_word_into_view(view, word) do
    String.graphemes(word)
    |> Enum.each(fn letter ->
      render_keydown(view, "update", %{"key" => letter})
    end)

    view
  end
end
