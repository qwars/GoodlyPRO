import server as WebSocketServer from 'websocket'

const sqlite3 = require('sqlite3').verbose

const db = sqlite3.Database.new( ':memory:', do|err|
	if err then console.error err.message
	else this.run( "CREATE TABLE IF NOT EXISTS collection ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, updatedAt TEXT NOT NULL, name TEXT NOT NULL, link TEXT, title TEXT, isText INTEGER DEFAULT 0, isActive INTEGER DEFAULT 0, viewers INTEGER DEFAULT 0, data BLOB, contacts BLOB, params BLOB)" , do console.log 'Connected to the in-memory SQlite database.' ))

const http = require 'http'

const server = http.createServer

server.listen 9091

const wsServer = WebSocketServer.new
	httpServer: server

const clients = [];

wsServer.on 'request', do|request|
	let client =
		connect: request.accept( null, request:origin )
		db: DBase.new

	let iDx = clients.push( client ) - 1

	client:connect.on 'message', do|message|
		message = JSON.parse message:utf8Data
		if message:create then client:db.createElementCollection( message:create ).catch( do |e| console.log e ).then do clients.forEach do |item|
			unless item:db.currentPage then item:db.source.catch( do |e| console.log e )
				.then do |response| item:connect.sendUTF JSON.stringify response
		else if message:update then client:db.updateElementCollection( message:update ).catch( do |e| console.log e )
		else if message:delete then client:db.deleteElementCollection( message:delete ).catch( do |e| console.log e ).then do clients.forEach do |item|
			if item:db.current != iDx and item:db.isExists message:delete then item:db.source.catch( do |e| console.log e )
				.then do |response| item:connect.sendUTF JSON.stringify response
		else client:db.source( message ).catch( do |e| console.log e )
			.then do |response| client:connect.sendUTF JSON.stringify response

	client:connect.on 'close', do|message|
		console.log 'close', message

class DBase

	def current
		@state:id

	def currentPage
		@state:page || 0

	def isExists iD
		@state:id == iD or not @state:source:collection or @state:source:collection.filter( do |item| item:id == iD ):length

	def filtrateWhereLikeString like
		"name LIKE '%" + like+ "%' OR link LIKE '%" +like+ "%' OR title LIKE '%" +like+ "%' OR contacts LIKE '%" +like+ "%'"

	def filtrateWhereLike
		for item in @state:filtrate
			filtrateWhereLikeString item.replace /\s+/g, '%'

	def filtrateWHERE
		if @state:filtrate and @state:filtrate:length then "WHERE { filtrateWhereLike().join( ' OR ' ) }"
		else ''

	def normaliseData data
		if data
			data:updatedAt = Date.new data:updatedAt
			data:contacts = JSON.parse data:contacts or '[]'
			data:params = JSON.parse data:params or '{}'
			data:data = '' unless data:data
			data:isText = data:isText > 0
			data:isActive = data:isActive > 0
		data

	def source message
		Object.assign @state,  message if message isa Object
		Promise.new do | resolve, reject |
			if @state:id and message == @state:id then db.get "SELECT * FROM collection WHERE id=?", @state:id , do |err, row|
				if err then reject err
				else if @state:source:document = normaliseData row then resolve @state:source
			else db.all "SELECT id, updatedAt, name, title, viewers, contacts FROM collection { filtrateWHERE() } ORDER BY updatedAt DESC LIMIT { currentPage * @state:limit }, { @state:limit }", do |err, rows|
				if err then reject err
				else if @state:source:collection = rows.map self:normaliseData  then resolve @state:source

	def deleteElementCollection value
		Promise.new do | resolve, reject | db.run "DELETE FROM collection WHERE id=?", value, do |err|
			if err then reject err
			else resolve true

	def createElementCollection value
		Promise.new do | resolve, reject | db.run "INSERT INTO collection(name,updatedAt) VALUES(?,?)", [ value, Date.new.toString], do |err|
			if err then reject err
			else resolve this:lastID

	def updateElementCollection value
		let propertySOL = do for property in Object.keys( value ).sort when property != 'id'
			"{ property }=?"

		let valuesSOL = do for property in Object.keys( value ).sort when property != 'id'
			if property == 'contacts' then JSON.stringify value[ property ] or []
			else if property == 'params' then JSON.stringify value[ property ] or {}
			else if property == 'updateAt' then Date.new.toString
			else if property == 'data' then value[ property ] or ''
			else if ['isActive', 'isText'].includes property then Number value[ property ]
			else value[ property ] or ''

		Promise.new do | resolve, reject |
			let sets = propertySOL();
			let vals = valuesSOL().concat( value:id );
			db.run "UPDATE collection SET { sets } WHERE id=?", vals , do |err|
				if err then reject err
				else resolve true

	def initialize
		@state =
			source: {}