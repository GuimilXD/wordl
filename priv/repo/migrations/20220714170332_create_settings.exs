defmodule Wordl.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :session_id, :uuid, null: false
      add :read_at, :utc_datetime_usec

      add :word_length, :integer
      add :max_tries, :integer
      add :dictionary, :string

      timestamps()
    end
  end
end
