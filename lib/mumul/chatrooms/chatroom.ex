defmodule Mumul.Chatrooms.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatroom" do
    field(:active_yn, Ecto.Enum, values: [:y, :n], default: :y)
    field(:max_size, :integer)

    timestamps()
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:max_size, :active_yn])
    |> validate_required([:max_size, :active_yn])
  end
end
