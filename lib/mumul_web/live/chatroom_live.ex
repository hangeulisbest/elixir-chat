defmodule MumulWeb.ChatroomLive do
  use MumulWeb, :live_view

  alias Mumul.Chatrooms
  alias Mumul.Chats
  alias Mumul.Members
  alias MumulWeb.Presence

  def mount(params, _session, socket) do
    set_up_chatroom(params, socket)
  end

  defp set_up_chatroom(%{"chatroom_code" => chatroom_code, "member_id" => member_id}, socket) do
    with {:ok, chatroom} <- Chatrooms.get_chatroom_by_chatroom_code(chatroom_code),
         {:ok, member} <- Members.get_member(member_id) do
      if chatroom.active_yn == :n do
        socket = put_flash(socket, :error, "만료된 방입니다!")
        {:ok, push_navigate(socket, to: ~p"/")}
      else
        Phoenix.PubSub.subscribe(Mumul.PubSub, chatroom.chatroom_code)

        {:ok, _} =
          Presence.track(self(), chatroom.chatroom_code, member.id, %{
            nickname: member.nickname,
            typing: false
          })

        presences = Presence.list(chatroom.chatroom_code)

        chats =
          Chats.get_chats(%{
            sort_order: :asc,
            sort_by: :inserted_at,
            chatroom_code: chatroom.chatroom_code
          })

        socket =
          socket
          |> stream(:chats, chats)
          |> assign(
            chatroom_code: chatroom.chatroom_code,
            chats: chats,
            nickname: member.nickname,
            member_id: member.id,
            presences: simple_presence_map(presences),
            input_message: ""
          )

        {:ok, socket}
      end
    else
      _ ->
        socket = put_flash(socket, :error, "잘못된 접근입니다!")
        {:ok, push_navigate(socket, to: ~p"/")}
    end
  end

  defp set_up_chatroom(_, socket) do
    socket = put_flash(socket, :error, "잘못된 접근입니다!")
    {:ok, push_navigate(socket, to: ~p"/")}
  end

  def simple_presence_map(presences) do
    Enum.into(presences, %{}, fn {member_id, %{metas: [meta | _]}} ->
      {member_id, meta}
    end)
  end

  def handle_event("typing", %{"input_message" => input_message}, socket) do
    IO.puts("타이핑중 : #{input_message}")

    {:noreply, socket}
  end

  def handle_event("save", %{"input_message" => input_message}, socket) do
    IO.puts("submit : #{socket.assigns.input_message}")

    attr = %{
      "chatroom_code" => socket.assigns.chatroom_code,
      "member_id" => to_string(socket.assigns.member_id),
      "nickname" => socket.assigns.nickname,
      "message" => input_message
    }

    {:ok, _chat} = Chats.create_chat(attr, socket.assigns.chatroom_code)

    {:noreply, update(socket, :input_message, fn _im -> "" end)}
  end

  def handle_info({:created_chat, chat}, socket) do
    socket = socket |> stream_insert(:chats, chat)
    {:noreply, socket}
  end

  # Presence에서 일어나는 모든 변화를 받는 콜백함수
  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    socket =
      socket
      |> remove_presences(diff.leaves)
      |> add_presences(diff.joins)

    {:noreply, socket}
  end

  defp remove_presences(socket, leaves) do
    member_ids = Enum.map(leaves, fn {member_id, _} -> member_id end)
    presences = Map.drop(socket.assigns.presences, member_ids)

    assign(socket, :presences, presences)
  end

  defp add_presences(socket, joins) do
    presences = Map.merge(socket.assigns.presences, simple_presence_map(joins))
    assign(socket, :presences, presences)
  end

  def render(assigns) do
    ~H"""
    <h1>Chatroom</h1>

    <p :if={@chatroom_code}> Chatroom code : <%= @chatroom_code %>  </p>
    <p :if={@member_id}> Who am i = <%= @member_id %> : <%= @nickname %>  </p>

    <%!-- https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#stream/4 여기에 phx-update 나옴. --%>
    <div id="chats" phx-update="stream">
      <.chats_template
          :for={ {chat_id,chat } <- @streams.chats}
           chat={chat} id={chat_id}
      />
    </div>
    <%!-- id={Enum.at(@streams.chats.inserts,-1) |> elem(0)} --%>
    <form phx-submit="save" phx-change="typing">
      <.input type="text"
        name="input_message"
        value={@input_message}
        placeholder="채팅입력"
        class="input w-full"
        minlength="1"
        autofocus
        required
        />
      <button class="btn">보내기</button>
    </form>

    <%= inspect(@presences)%>

    """
  end

  def chats_template(assigns) do
    ~H"""
     <div id={@id}>
        <div> <%= @chat.member_id %> </div>
        <div> <%= @chat.nickname %> </div>
        <div> <%= @chat.message %> </div>
     </div>
    """
  end
end
