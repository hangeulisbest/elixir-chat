defmodule MumulWeb.ChatLive do
  use MumulWeb, :live_view

  alias Mumul.Chatrooms

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       create_form: %{max_size: 10, nickname: ""},
       join_form: %{join_code: "", nickname: ""}
     )}
  end

  def handle_event("create_chatroom", %{"max_size" => max_size, "nickname" => nickname}, socket) do
    IO.puts("nickname is #{nickname} and max_size is #{max_size}")

    {:noreply, socket}
  end

  defp type_options do
    [
      "2명": 2,
      "4명": 4,
      "10명": 10,
      "50명": 50,
      "100명": 100,
      "1000명": 1000
    ]
  end
end
