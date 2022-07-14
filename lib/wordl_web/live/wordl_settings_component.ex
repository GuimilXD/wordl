defmodule WordlWeb.WordlSettingsComponent do
  use WordlWeb, :live_component

  alias Wordl.Wordl
  alias Phoenix.LiveView.JS

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_settings_changeset()}
  end

  defp assign_settings_changeset(%{
	assigns: %{
	  settings: settings
	}} = socket) do
    socket
    |> assign(:settings_changeset, Wordl.change_settings(settings))
  end


  @impl true
  def handle_event("update_settings", %{"settings" => settings_params}, %{assigns: %{settings: settings}} = socket) do
    case Wordl.insert_or_update_settings(settings, settings_params) do
      {:ok, settings} ->
	{:noreply,
	 socket
	 |> assign(:settings, settings)
	 |> put_flash(:info, "Settings updated successfully")
	 |> push_redirect(to: Routes.wordl_path(socket, :index))}

      {:error, changeset} ->
	{:noreply,
	 socket
	 |> assign(:settings_changeset, changeset)}
    end
  end
end
