defmodule WordlWeb.Router do
  use WordlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WordlWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_session_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WordlWeb do
    pipe_through :browser

    live "/", WordlLive, :index
    live "/settings", WordlLive, :settings
  end

  # Other scopes may use custom stacks.
  # scope "/api", WordlWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WordlWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp assign_session_id(conn, _) do
    if get_session(conn, :session_id) do
      # If the session_id is already set, don't replace it.
      conn
    else
      session_id = Ecto.UUID.generate()
      conn |> put_session(:session_id, session_id)
    end
  end
end
