defmodule Mumul.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "member" do
    field :chatroom_code, :string
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:nickname, :chatroom_code])
    |> validate_required([:nickname, :chatroom_code])
  end
end
