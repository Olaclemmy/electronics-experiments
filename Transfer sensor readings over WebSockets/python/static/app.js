// connect to websocket
var ws = new WebSocket('ws://localhost:9090/ws');

// when a new message has been received
ws.onmessage = function(event){
   var data = JSON.parse(event.data);

   var span = document.getElementById('distance');
   span.innerHTML = data.value;
}
