Push = (json) ->
	socket = io.connect('http://localhost:3000')
	socket.emit('create', {content: json})
