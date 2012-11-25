###
@author Tantaman
###
requirejs.config(
	paths:
		"css": "vendor/amd_plugins/css"
		"text": "vendor/amd_plugins/text"
	shim: 
		'vendor/amd/jszip': 
			exports: 'JSZip'
		'vendor/amd/jszip-deflate': ['vendor/amd/jszip']
)

window.browserPrefix = ""
if $.browser.mozilla
	window.browserPrefix = "-moz-"
else if $.browser.msie
	window.browserPrefix = "-ms-"
else if $.browser.opera
	window.browserPrefix = "-o-"
else if $.browser.webkit
	window.browserPrefix = "-webkit-"

window.URL = window.webkitURL or window.URL
window.Blob = window.Blob or window.WebKitBlob or window.MozBlob
window.BASE_URL = "http://chennai-dashboard.thoughtworks.com:3000"
window.DATA_READ_URL = window.BASE_URL + "/template/index"

if not window.localStorage?
	window.localStorage =
		setItem: () ->
		getItem: () ->
		length: 0

if not Function.bind? or Function.prototype.bind?
	Function.prototype.bind = (ctx) ->
		fn = this
		() ->
			fn.apply(ctx, arguments)

if window.location.href.indexOf("preview=true") isnt -1
		window.slideConfig =
			size:
				width: 1024
				height: 768

  requirejs(["ui/impress_renderer/preview"], (Preview) ->
    $.get(window.DATA_READ_URL, (data) ->
      Preview.update(data)
    )
  )
else
	continuation = () ->
		requirejs(["ui/editor/Editor",
				"model/presentation/Deck",
				"storage/FileStorage",
				"model/common_application/UndoHistory"],
		(Editor, Deck, FileStorage, UndoHistory) ->
			window.undoHistory = new UndoHistory(20)
			deck = new Deck()
			editor = new Editor({model: deck})

			window.zTracker =
				z: 0
				next: () ->
					++@z

			$("body").append(editor.render())

			$.get(window.DATA_READ_URL, (data) ->
        deck.import(JSON.parse(data))
      )
		)
	
	requirejs(["vendor/amd/backbone",
			"state/DefaultState",
			"vendor/amd/etch",
			"ui/etch/Templates",
			"css!ui/etch/css/etchOverrides.css"],
	(Backbone, DefaultState, etch, EtchTemplates) ->
		Backbone.sync = (method, model, options) ->
			if options.keyTrail?
				options.success(DefaultState.get(options.keyTrail))

			# slightly better than what we were doing before.
			# we need to roll the slide config up into the model.
		window.slideConfig =
			size:
				width: 1024
				height: 768

		_.extend(etch.config.buttonClasses,
			default: [
				'<group>', 'bold', 'italic', '</group>',
				'<group>', 'unordered-list', 'ordered-list', '</group>',
				'<group>', 'justify-left', 'justify-center', '</group>',
				'<group>', 'link', '</group>',
				'font-family', 'font-size',
				'<group>', 'color', '</group>']
		)

		etch.buttonElFactory = (button) ->
			viewData =
				button: button
				title: button.replace('-', ' ')
				display: button.substring(0, 1).toUpperCase()

			if button is 'link' or button is 'clear-formatting' or button is 'ordered-list' or button is 'unordered-list'
				viewData.display = ''

			switch button
				when "font-size" then EtchTemplates.fontSizeSelection viewData
				when "font-family" then EtchTemplates.fontFamilySelection viewData
				when "color" then EtchTemplates.colorChooser viewData
				else 
					if button.indexOf("justify") isnt -1
						viewData.icon = button.substring button.indexOf('-')+1, button.length
						EtchTemplates.align viewData
					else
						EtchTemplates.defaultButton(viewData)

		etch.groupElFactory = () ->
			return $('<div class="btn-group">')
			
		continuation()
	)

	###
	switch (button) {
      case 'font-size':
        return $('<a class="etch-editor-button dropdown-toggle disabled" data-toggle="dropdown" title="'
           + button.replace('-', ' ') + 
           '"><span class="text">Lato</span></a><ul class="dropdown-menu etch-'
            + button + '"><li><a href="#">Wee2</a></li></ul>');
      case 'font-family':
       return $('<a class="etch-editor-button dropdown-toggle disabled" data-toggle="dropdown" title="'
           + button.replace('-', ' ') + 
           '"><span class="text">Lato</span></a><ul class="dropdown-menu etch-'
            + button + '"><li><a href="#">Wee</a></li></ul>');
      break;
      default:
	###
