defmodule Wordl.WordlLiveTest do
  use WordlWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # TODO: Implement Mocking & Improve Testing
  describe "WordlLive" do
    test "shows typed word", %{conn: conn} do
      word = "quick"

      {:ok, view, html} = live(conn, "/wordl")

      refute html =~ word

      String.graphemes(word)
      |> Enum.each(fn letter ->
	render_keydown(view, "update", %{"key" => letter})
      end)

      for letter <- String.graphemes(word) do
	assert render(view) =~ letter
      end
    end
  end
end
