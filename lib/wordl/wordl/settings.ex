defmodule Wordl.Wordl.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wordl.Repo
  alias Wordl.Wordl.Settings

  schema "settings" do
    field :session_id, Ecto.UUID
    field :read_at, :utc_datetime_usec

    field :word_length, :integer, default: Application.fetch_env!(:wordl, :default_word_length)
    field :max_tries, :integer, default: Application.fetch_env!(:wordl, :default_max_tries)
    field :dictionary, :string, default: Application.fetch_env!(:wordl, :default_dictionary)

    timestamps()
  end

  @doc false
  def changeset(%Settings{} = settings, attrs) do
    settings
    |> cast(attrs, [:session_id, :word_length, :max_tries, :dictionary])
    |> validate_required([:session_id])
  end

  def for_session(%{"session_id" => sid}) do
    settings = Repo.get_by(Settings, session_id: sid)

    if settings do
      now = DateTime.utc_now()

      # Update `read_at` so we can track stale Settings.
      settings = settings |> Ecto.Changeset.change(read_at: now) |> Repo.update!

      settings
    else
      # Return an unpersisted "null object" for convenience.
      %Settings{session_id: sid}
    end
  end
end
