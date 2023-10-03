defmodule Mumul.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:member) do
      add :nickname, :string
      add :chatroom_code, :string

      timestamps()
    end
  end
end
