function iter$(a){ return a ? (a.toArray ? a.toArray() : a) : []; };

var WebSocketServer = require('websocket').server;
var sqlite3 = require('sqlite3').verbose();
var db = new (sqlite3.Database)(':memory:',function(err) {
	if (err) { return console.error(err.message()) } else {
		return console.log('Connected to the in-memory SQlite database.');
	};
});

var http = require('http');

var server = http.createServer();

server.listen(9091);

var wsServer = new WebSocketServer(
	{httpServer: server}
);

var clients = [];;

wsServer.on('request',function(request) {
	var client = {
		connect: request.accept(null,request.origin),
		db: new DBase()
	};
	
	var iDx = clients.push(client) - 1;
	
	client.connect.on('message',function(message) {
		message = JSON.parse(message.utf8Data);
		if (message.create) { return client.db.createElementCollection(message.create).catch(function(e) { return console.log(e); }).then(function() { return clients.forEach(function(item) {
			if (!(item.db.Id || item.db.currentPage())) { return item.db.source().catch(function(e) { return console.log(e); }).then(function(response) { return item.connect.sendUTF(JSON.stringify(response)); }) };
		}); }) } else if (message.update) { return client.db.updateElementCollection(message.update).catch(function(e) { return console.log(e); }).then(function() { return clients.forEach(function(item) {
			if (item.db.Id != iDx && item.db.isExists(message.update)) { return item.db.source().catch(function(e) { return console.log(e); }).then(function(response) { return item.connect.sendUTF(JSON.stringify(response)); }) };
		}); }) } else if (message.delete) { return client.db.deleteElementCollection(message.delete).catch(function(e) { return console.log(e); }).then(function() { return clients.forEach(function(item) {
			if (item.db.Id != iDx && item.db.isExists(message.delete)) { return item.db.source().catch(function(e) { return console.log(e); }).then(function(response) { return item.connect.sendUTF(JSON.stringify(response)); }) };
		}); }) } else {
			return client.db.source(message).catch(function(e) { return console.log(e); }).then(function(response) { return client.connect.sendUTF(JSON.stringify(response)); });
		};
	});
	
	return client.connect.on('close',function(message) {
		return console.log('close',message);
	});
});


db.run(('CREATE IF NOT EXISTS TABLE collection ( ' + 'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, ' + 'updatedAt TEXT NOT NULL, ' + 'name TEXT NOT NULL, ' + 'link TEXT NOT NULL, ' + 'title TEXT NOT NULL, ' + 'isText INTEGER NOT NULL DEFAULT 0, ' + 'isActive INTEGER NOT NULL DEFAULT 0, ' + 'viewers INTEGER NOT NULL DEFAULT 0, ' + 'data BLOB NOT NULL DEFAULT \'\', ' + 'contacts BLOB NOT NULL DEFAULT \'[]\' ' + ')'),function(err,res) { return console.log('eee',err,res); });

function DBase(){
	this._state = {
		source: {}
	};
};
DBase.prototype.Id = function (){
	return this._state.id;
};

DBase.prototype.currentPage = function (){
	return this._state.page || 0;
};

DBase.prototype.isExists = function (iD){
	return this._state.id == iD || this._state.source.collection.filter(function(item) { return item.id == iD; }).length;
};

DBase.prototype.filtrateWhereLikeString = function (like){
	return "name LIKE '%" + like + "%' OR link LIKE '%" + like + "%' OR title LIKE '%" + like + "%' OR contacts LIKE '%" + like + "%'";
};

DBase.prototype.filtrateWhereLike = function (){
	var res = [];
	for (var i = 0, items = iter$(this._state.filtrate), len = items.length; i < len; i++) {
		res.push(this.filtrateWhereLikeString(items[i].replace(/\s+/g,'%')));
	};
	return res;
};

DBase.prototype.filtrateWHERE = function (){
	if (this._state.filtrate && this._state.filtrate.length) { return ("WHERE " + this.filtrateWhereLike().join(' OR ')) } else {
		return '';
	};
};

DBase.prototype.normaliseData = function (data){
	data.updatedAt = new Date(data.updatedAt);
	data.contacs = JSON.parse(this.contacs());
	data.isText = data.isText > 0;
	data.isActive = data.isActive > 0;
	return data;
};

DBase.prototype.source = function (message){
	var self = this;
	if (message) { Object.assign(self._state,message) };
	return new Promise(function(resolve,reject) {
		if (self._state.id) { return db.get("SELECT * FROM collection WHERE id=?",self._state.id,function(err,row) {
			if (err) { return reject(err) } else if (self._state.source.document = self.normaliseData(row)) { return resolve(self._state.source) };
		}) } else {
			return db.all(("SELECT id, updatedAt, name, title, viewers, contacts FROM collection " + self.filtrateWHERE() + " ORDER BY updatedAt DESC LIMIT " + (self.currentPage() * self._state.limit) + ", " + (self._state.limit)),function(err,rows) {
				console.log(err);
				if (err) { return reject(err) } else if (self._state.source.collection = rows.map(self.normaliseData)) { return resolve(self._state.source) };
			});
		};
	});
};

DBase.prototype.deleteElementCollection = function (value){
	return new Promise(function(resolve,reject) { return db.run("DELETE FROM collection WHERE id=?",value,function(err) {
		if (err) { return reject(err) } else {
			return resolve(true);
		};
	}); });
};

DBase.prototype.createElementCollection = function (value){
	return new Promise(function(resolve,reject) { return db.run("INSERT INTO collection(name,updatedAt) VALUES(?,?)",[value,new Date().toString()],function(err) {
		if (err) { return reject(err) } else {
			return resolve(this.lastID);
		};
	}); });
};

DBase.prototype.updateElementCollection = function (value){
	var self = this;
	var propertySOL = function() { var res = [];
	for (var i = 0, items = iter$(Object(value).keys().sort()), len = items.length, property; i < len; i++) {
		property = items[i];
		if (!property(!('id'))) { continue; };
		res.push(("" + property + "=?"));
	};
	return res; };
	var valuesSOL = function() { var res = [];
	for (var i = 0, items = iter$(Object(value).keys().sort()), len = items.length, property; i < len; i++) {
		property = items[i];
		if (!property(!('id'))) { continue; };
		res.push((property == 'contacs') ? 
			JSON.stringify(value[property])
		 : (['isActive','isText'].includes(property) ? 
			Number(value[property])
		 : 
			value[property]
		));
	};
	return res; };
	
	return new Promise(function(resolve,reject) { return db.run(("UPDATE " + propertySOL().concat('updatedAt').join(', ') + " WHERE id=?"),valuesSOL().concat([new Date().toString(),self._state.id]),function(err) {
		if (err) { return reject(err) } else {
			return resolve(true);
		};
	}); });
};


