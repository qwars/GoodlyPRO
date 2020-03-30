
window:WebSocket = window:WebSocket or window:MozWebSocket

const Connection = WebSocket.new "ws://{ window:location:hostname }:9091"

Connection:onopen = do Imba.commit

Connection:onmessage = do|request|
	Imba.commit if Connection:condition = JSON.parse request:data

Connection:onclose = do|request|
	console.log 'onclose', request

Connection:onerror = do|request|
	console.log 'onerror', request

extend tag element
	def condition
		Connection:condition

window.addEventListener 'resize', do Imba.commit

export tag Application < output

	def setup
		Connection:filtrate = Object.defineProperty ( Object.defineProperty Array.new, 'create',
			value: do |value| if this.push value then self.accomplish ), 'remove',
				value: do |idx| if this.splice idx, 1 then self.accomplish

		extend tag element
			def filtrate
				Connection:filtrate

	def mount
		const computed = do window.getComputedStyle dom
		Object.defineProperty params, 'limit',
			enumerable: true
			get: do computed():gridTemplateColumns.split(/\s+/):length * computed():gridTemplateRows.split(/\s+/):length

		Object.defineProperty params, 'filtrate',
			enumerable: true
			get: do Connection:filtrate

	def transmission
		Promise.new do |resolve, reject|
			@interval = clearInterval( @interval ) || setInterval( &, 0 ) do
				resolve true if Connection:readyState === 1 and not clearInterval @interval
				reject false if Connection:readyState > 1 and not clearInterval @interval

	def accomplish
		transmission.then do |allowed| Connection.send Connection:candidate = JSON.stringify params if allowed

	def isStateHasChanged
		Connection:candidate !== JSON.stringify params

	def render
		<self>
			accomplish if isStateHasChanged