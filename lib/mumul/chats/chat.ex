defmodule Mumul.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat" do
    field :chatroom_code, :string
    field :member_id, :string
    field :message, :string
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:chatroom_code, :member_id, :nickname, :message])
    |> validate_required([:chatroom_code, :member_id, :nickname, :message])
  end
end
