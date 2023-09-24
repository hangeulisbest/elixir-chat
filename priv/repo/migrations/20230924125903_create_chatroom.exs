defmodule Mumul.Repo.Migrations.CreateChatroom do
  use Ecto.Migration

  def change do
    create table(:chatroom) do
      add :max_size, :integer
      add :active_yn, :string
      add :chatroom_code, :string

      timestamps()
    end
  end
end
