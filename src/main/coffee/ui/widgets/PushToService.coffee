Push = (json) ->
	$.ajax({
		url: window.DATA_CREATE_URL,
		type: 'post'
		data: {content: json}
	});