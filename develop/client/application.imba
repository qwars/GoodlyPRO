
window:WebSocket = window:WebSocket or window:MozWebSocket

const Connection = WebSocket.new "ws://{ window:location:hostname }:9091"

Connection:onopen = do|request|
	console.log 'onopen', request
	Connection.send JSON.stringify { yee: true }

Connection:onmessage = do|request|

	console.log 'onmessage', JSON.parse request:data

Connection:onclose = do|request|
	console.log 'onclose', request

Connection:onerror = do|request|
	console.log 'onerror', request

export tag Application < output

	def render
		<self>