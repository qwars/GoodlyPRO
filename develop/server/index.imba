import server as WebSocketServer from 'websocket'

const http = require 'http'

const server = http.createServer

server.listen 9091

const wsServer = WebSocketServer.new
	httpServer: server

wsServer.on 'request', do|request|

	let connection = request.accept null, request:origin

	connection.on 'message', do|message|
		connection.sendUTF JSON.stringify
			e: message

	connection.on 'close', do|message|
		console.dir message
