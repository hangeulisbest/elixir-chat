defmodule MumulWeb.ChatLive do
  use MumulWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        create: true,
        join: true,
        join_room: false,
        create_room: false,
        nick_name: "",
        join_code: ""
      )

    {:ok, socket}
  end

  def handle_event("show_create_room", _, socket) do
    {:noreply,
     assign(socket,
       join_room: false,
       create_room: true,
       create: false,
       join: false,
       nick_name: "",
       join_code: ""
     )}
  end

  def handle_event("back", _, socket) do
    {:noreply,
     assign(
       socket,
       create: true,
       join: true,
       join_room: false,
       create_room: false,
       nick_name: "",
       join_code: ""
     )}
  end

  def handle_event("show_join_room", _, socket) do
    {:noreply,
     assign(socket,
       join_room: true,
       create_room: false,
       create: false,
       join: false,
       nick_name: "",
       join_code: ""
     )}
  end
end
