defmodule WordlWeb.WordlLive do
  use WordlWeb, :live_view

  alias Wordl.Dictionary
  alias Wordl.Wordl
  alias Wordl.Settings

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_settings(session)
     |> assign_random_correct_word()
     |> assign(:tries, [])
     |> assign(:current_word, '')}
  end

  defp assign_settings(socket, session) do
    socket
    |> assign_new(:settings, fn -> Settings.for_session(session) end)
  end

  defp assign_random_correct_word(%{
	assigns: %{
	  settings: %{
	    dictionary: dictionary,
	    word_length: word_length
	  }
	}} = socket) do
   socket
   |> assign(:correct_word, Dictionary.random_word(dictionary, word_length))
  end

  @impl true
  def handle_event("keydown", %{"key" => key}, socket) do
    key =
      key
      |> String.downcase()
      |> String.to_charlist()

    if socket.assigns.live_action == :won do
      {:noreply, socket}
    else
      {:noreply, handle_key(socket, key)}
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp handle_key(%{
	assigns: %{
	  current_word: current_word,
	  correct_word: correct_word,
	  tries: tries,
	  settings: %{
	    dictionary: dictionary,
	    word_length: word_length,
	    max_tries: max_tries
	  },
	}} = socket, 'enter') do
    case to_string(current_word) do
      ^correct_word ->
	socket
	|> assign(:tries, tries ++ [{current_word, Wordl.score(socket.assigns.correct_word, to_string(current_word))}])
	|> assign(:current_word, '')
	|> assign(:live_action, :won)

      _ when length(current_word) < word_length ->
	socket
	|> put_flash(:error, "Too few letters!")

      _ when length(current_word) == word_length and length(tries) <= max_tries ->
	if Dictionary.has_word?(dictionary, current_word) do
	  socket
	  |> assign(:tries, tries ++ [{current_word, Wordl.score(socket.assigns.correct_word, to_string(current_word))}])
	  |> assign(:current_word, '')
	else socket
	  |> put_flash(:error, "Word not in dictionary!")
	end
    end
  end

  defp handle_key(%{
	assigns: %{
	  current_word: current_word,
	}} = socket, 'backspace') when current_word != [] do
	assign(socket, :current_word, pop(current_word))
  end

  defp handle_key(%{
	assigns: %{
	  current_word: current_word,
	  tries: tries,
	  settings: %{
	    word_length: word_length,
	    max_tries: max_tries
	  }
	}} = socket, letter)
  when
  letter >= 'a' and
  letter <= 'z' and
  length(letter) == 1 and
  length(current_word) < word_length and
  length(tries) < max_tries 
    do
    assign(socket, :current_word, current_word ++ [letter])
  end

  defp handle_key(socket, _key), do: socket

  defp pop(list) do
    list |> Enum.reverse |> tl() |> Enum.reverse
  end

  defp render_empty_row(assigns) do
    ~H""" 
    <.render_word word_length={@word_length} word={List.duplicate(0, @word_length)} colors={List.duplicate(:empty, @word_length)} />
    """
  end

  defp render_word(assigns) do
    assigns = Map.put_new(assigns, :colors, List.duplicate(:white, length(assigns.word)))

    ~H"""
    <div class="">
      <%= for {letter, color} <- Enum.zip(@word, @colors) do %>
        <.render_letter letter={letter} color={color} />
      <% end %>

      <%= for i <- 0..(@word_length - length(@word)), i > 0 do %>
        <.render_letter letter={"0"} color={:empty}) />
      <% end %>
    </div>
    """
  end

  defp render_letter(assigns) do
    ~H"""
    <div class={"inline-flex #{color_to_class(@color)}"}>
      <div id="cell-letter" class="w-16 pt-2 h-16 items-center text-4xl font-bold border uppercase text-center">
        <%= @letter %>
      </div>
    </div>
    """
  end

  defp color_to_class(:gray), do: "bg-gray-500 text-white"
  defp color_to_class(:yellow), do: "bg-yellow-400 text-white"
  defp color_to_class(:green), do: "bg-lime-600 text-white"
  defp color_to_class(:white), do: "bg-white text-black"
  defp color_to_class(:empty), do: "bg-white text-transparent"

  defp modal_title(:won), do: "You won!"
  defp modal_title(_), do: "You lost!"
end  
