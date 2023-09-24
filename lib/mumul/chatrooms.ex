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

  def create_chatroom(attrs \\ %{}) do
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
end
