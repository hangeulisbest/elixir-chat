defmodule Mumul.Chatrooms do
  @moduledoc """
  The Chatrooms context.
  """

  import Ecto.Query, warn: false

  alias Mumul.Repo
  alias Mumul.Chatrooms.Chatroom

  def list_chatroom do
    Repo.all(Chatroom)
  end

  def get_chatroom!(id), do: Repo.get!(Chatroom, id)

  def get_chatroom_by_chatroom_code(chatroom_code) do
    chatroom =
      from(Chatroom)
      |> where(chatroom_code: ^chatroom_code)
      |> Repo.one()

    case chatroom do
      nil -> {:error, nil}
      _ -> {:ok, chatroom}
    end
  end

  def create_chatroom(max_size) do
    uuid = generate_UUID()
    attrs = %{"max_size" => max_size, "chatroom_code" => uuid, "active_yn" => :y}

    %Chatroom{}
    |> Chatroom.changeset(attrs)
    |> Repo.insert()
  end

  def disable_chatroom(%Chatroom{} = chatroom) do
    chatroom
    |> Chatroom.changeset(%{"active_yn" => :n})
    |> Repo.update()
  end

  # def update_chatroom(%Chatroom{} = chatroom, attrs) do
  #   chatroom
  #   |> Chatroom.changeset(attrs)
  #   |> Repo.update()
  # end

  defp generate_UUID() do
    Ecto.UUID.generate()
    |> String.replace("-", "")
  end
end
