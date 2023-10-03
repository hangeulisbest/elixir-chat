defmodule Mumul.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chat) do
      add :chatroom_code, :string
      add :member_id, :string
      add :nickname, :string
      add :message, :text

      timestamps()
    end
  end
end
