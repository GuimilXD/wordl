defmodule WordlWeb.PageController do
  use WordlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
