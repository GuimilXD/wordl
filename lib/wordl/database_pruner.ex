defmodule Wordl.DatabasePruner do
  @doc """
  This module is responsible for removing stale entries from the database
  """
  use Task

  import Ecto.Query
  alias Wordl.Repo
  alias Wordl.Wordl.Settings

  @stale_after_days 10

  def start_link(_arg) do
    Task.start_link(&loop/0)
  end

  defp loop() do
    Process.sleep(:timer.minutes(10))

    prune_stale_settings()

    loop()
  end

  defp prune_stale_settings() do
      now = DateTime.utc_now()

      stale_before = now |> DateTime.add(-60 * 60 * 24 * @stale_after_days, :second)
      Repo.delete_all(from s in Settings, where: s.read_at < ^stale_before)
  end
end
