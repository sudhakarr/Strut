Push = (json) ->
	socket = io.connect('http://localhost:3000')
	socket.emit('create', {content: json})
	socket.on('error', error_toast)
	socket.on('success_callback', success_toast)
success_toast = -> 
	$().toastmessage('showToast', {
    	text     : 'Slide(s) has been added successfully !!!',
    	sticky   : false,
    	type     : 'success',
    	position : 'top-center'
	});
error_toast = -> 
	$().toastmessage('showToast', {
    	text     : 'Oops Something went wrong :(',
    	sticky   : false,
    	type     : 'error',
    	position : 'top-center'
	});
