defmodule Mumul.Members do
  import Ecto.Query, warn: false

  alias Mumul.Repo
  alias Mumul.Members.Member

  def get_members_by_chatroom_code(chatroom_code) do
    member =
      from(Member)
      |> where(chatroom_code: ^chatroom_code)
      |> Repo.one()

    case member do
      nil -> {:error, nil}
      _ -> {:ok, member}
    end
  end

  def get_member(id) do
    member = Repo.get(Member, id)

    case member do
      nil -> {:error, nil}
      _ -> {:ok, member}
    end
  end

  def create_member(chatroom_code, nickname) do
    attr = %{"chatroom_code" => chatroom_code, "nickname" => nickname}

    %Member{}
    |> Member.changeset(attr)
    |> Repo.insert()
  end
end
