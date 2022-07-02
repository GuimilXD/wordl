defmodule Wordl.Repo do
  use Ecto.Repo,
    otp_app: :wordl,
    adapter: Ecto.Adapters.Postgres
end
