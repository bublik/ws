defmodule Ws.DialogChannel do
  use Ws.Web, :channel
  #alias Ws.ChannelMonitor
  require Logger

  def join("houses:dialog", _payload, socket) do
   # current_user = socket.assigns.current_user
  #  users = ChannelMonitor.user_joined("houses:dialog", current_user)["houses:dialog"]
  #  send self, {:after_join, users}
    {:ok, socket}
  end

  def terminate(_reason, socket) do
   # user_id = socket.assigns.current_user.id
    ##users = ChannelMonitor.user_left("houses:dialog", user_id)["houses:dialog"]
    #lobby_update(socket, users)
    :ok
  end

  def handle_info({:after_join, users}, socket) do
   # lobby_update(socket, users)
    {:noreply, socket}
  end

#  defp lobby_update(socket, users) do
#    broadcast! socket, "lobby_update", %{ users: get_usernames(users) }
#  end

#  defp get_usernames(nil), do: []
#  defp get_usernames(users) do
#    Enum.map users, &(&1.first_name)
#  end

#  def handle_in("game_invite", %{"username" => username}, socket) do
#    data = %{"username" => username, "sender" => socket.assigns.current_user.first_name }
#    broadcast! socket, "game_invite", data
#    {:noreply, socket}
#  end
#
#  intercept ["game_invite", "new_msg"]
#  def handle_out("game_invite", %{"username" => username, "sender" => sender}, socket)do
#    if socket.assigns.current_user.first_name == username && sender != username do
#      push socket, "game_invite", %{username: sender}
#    end
#    {:noreply, socket}
#  end

 def handle_in("new_post", %{"body" => body}, socket) do
    data = Poison.encode!(%{message: body, "user_id": socket.assigns.current_user.id})
    #Logger.debug "> handle_in new_post body #{inspect body}"
    #Logger.debug "> handle_in new_post data #{inspect data}"
    broadcast! socket, "new_post", %{body: data}
    {:noreply, socket}
  end

  intercept ["new_chat", "new_post"]

  def handle_out("new_chat", response, socket) do
    data = Poison.decode!(response[:body])
    if socket.assigns.current_user.id == data["user_id"] do
      Logger.debug "[new_chat]> push to user [#{data["user_id"]}] -> #{inspect data}"
      # Add users to online hash
      push socket, "new_chat", data
    end
    {:noreply, socket}
  end

  def handle_out("new_post", response, socket) do
    data = Poison.decode!(response[:body])
    #Logger.debug "> handle_out new_post data #{inspect data}"
    if socket.assigns.current_user.id == data["user_id"] do
      #Logger.debug "[new_post]> push to user [#{data["user_id"]}] -> #{inspect data}"
      push socket, "new_post", data
    end
    {:noreply, socket}
    end
end
