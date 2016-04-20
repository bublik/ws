// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

var token = $('meta[name=channel_token]').attr('content');
let socket = new Socket("/ws", {params: {token: token}})
socket.connect()

var dialog_chanel = socket.channel('houses:dialog');
let lobby = $("#lobby")
let messagesContainer = $("#messages")
let chatInput         = $("#chat-input")


dialog_chanel.on('lobby_update', function (response) {
  lobby.html('')
  $.each(response.users, function(num, user_name) {
    lobby.append(`<a onclick="invitePlayer('${user_name}')">${user_name}</a>`)
  });
  //lobby.text(JSON.stringify(response.users))
  console.log(response.users);
  console.log(JSON.stringify(response.users));
});

dialog_chanel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

chatInput.on("keypress", event => {
  if(event.keyCode === 13){
  dialog_chanel.push("new_post", {body: chatInput.val()});
  chatInput.val("");
}
})

dialog_chanel.on("new_chat", response => {
  console.log(response)
  messagesContainer.append(`<div><strong>new_chat</strong> [${response.user_id}][${response.dialog_id}] ${response.message}</div>`)
});
dialog_chanel.on("new_post", response => {
  console.log(response)
  messagesContainer.append(`<div><strong>new_post</strong>[${response.user_id}] [${response.dialog_id}] ${response.message}</div>`)
});

export default socket
