Push = (json) ->
	$.ajax({
		url: 'http://10.16.3.17:3000/template/create',
		type: 'post'
		data: {content: json}
	});