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
	|> assign_score(current_word, correct_word)
	|> assign(:current_word, '')
	|> assign(:live_action, :won)

      _ when length(current_word) < word_length ->
	socket
	|> put_flash(:error, "Too few letters!")

      _ when length(current_word) == word_length and length(tries) <= max_tries ->
	if Dictionary.has_word?(dictionary, current_word) do
	  socket
	  |> assign_score(current_word, correct_word)
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

  defp assign_score(socket, current_word, correct_word) do
    assign(socket, :tries, socket.assigns.tries ++ [{current_word, Wordl.score(correct_word, to_string(current_word))}])
  end

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
    <div class="inline-block">
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
    <div class={"inline-block flex-nowrap shrink #{color_to_class(@color)}"}>
      <div class="cell-letter box-border select-none text-xl md:text-2xl font-bold border items-center text-center uppercase w-10 h-10 md:w-17 md:h-17 leading-8">
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

  defp render_keyboard(assigns) do
    ~H"""
    <div class="m-3 flex flex-col items-center">
      <.render_keyboard_row keys="qwertyuiop"} />
      <.render_keyboard_row keys="asdfghjkl" />
      <.render_keyboard_row keys="zxcvbnm" has_enter has_backspace />
    </div>
    """
  end

  defp render_keyboard_row(assigns) do
    assigns =
      assigns
      |> Map.put_new(:has_enter, false)
      |> Map.put_new(:has_backspace, false)

    ~H"""
      <div class="m-1">
        <%= if @has_enter do %>
          <button
	    class="pt-4 pb-4 bg-gray-300 uppercase border rounded-md"
	    id="virtual-keyboard-button-enter"
	    data-key="Enter"
	    phx-hook="VirtualKeyboardButton">Enter</button>
        <% end %>

        <%= for key <- String.graphemes(@keys) do %>
          <.render_keyboard_key key={key} />
        <% end %>

        <%= if @has_backspace do %>
          <button
	    class="pt-4 pb-4 pr-2 pl-2 bg-gray-300 uppercase border rounded-md"
	    id="virtual-keyboard-button-backspace"
	    data-key="Backspace"
	    phx-hook="VirtualKeyboardButton">
              <.icon name={:backspace} />
            </button>
        <% end %>
      </div>
    """
  end

  defp render_keyboard_key(assigns) do
    ~H"""
      <button
        class="w-6 md:w-10 pt-4 pb-4 bg-gray-300 uppercase border rounded-md"
        id={"virtual-keyboard-button-#{@key}"}
        phx-hook="VirtualKeyboardButton"><%= @key %></button>
    """
  end
end  
