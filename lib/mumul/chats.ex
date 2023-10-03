defmodule Mumul.Chats do
  import Ecto.Query, warn: false
  alias Mumul.Repo
  alias Mumul.Chats.Chat

  def get_chats(options) do
    from(Chat)
    |> filter_by(options)
    # sort_by = inserted_at , sort_order = asc
    |> sort(options)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_order: sort_order}) do
    order_by(query, {^sort_order, ^sort_by})
  end

  defp sort(query, _options), do: query

  defp filter_by(query, %{chatroom_code: chatroom_code}) do
    where(query, chatroom_code: ^chatroom_code)
  end

  defp filter_by(query, _options), do: query

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  # attr = chatroom_code , member_id, nickname , meesage
  def create_chat(attr, topic) do
    %Chat{}
    |> Chat.changeset(attr)
    |> Repo.insert()
    |> broadcast(topic, :created_chat)
  end

  def broadcast({:ok, chat}, topic, tag) do
    Phoenix.PubSub.broadcast(Mumul.PubSub, topic, {tag, chat})
    {:ok, chat}
  end

  def boradcast({:error, _changeset} = error, _tag), do: error
end
