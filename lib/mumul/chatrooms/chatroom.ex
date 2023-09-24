defmodule Mumul.Chatrooms.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatroom" do
    field :active_yn, Ecto.Enum, values: [:y, :n]
    field :chatroom_code, :string
    field :max_size, :integer

    timestamps()
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:max_size, :active_yn, :chatroom_code])
    |> validate_required([:max_size, :active_yn, :chatroom_code])
  end
end
