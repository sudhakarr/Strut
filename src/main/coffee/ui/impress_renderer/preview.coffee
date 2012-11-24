define(["ui/impress_renderer/ImpressRenderer"],
(ImpressRenderer, Deck) ->
  class Preview
    update: (json) ->
      requirejs(["ui/editor/Editor", "model/presentation/Deck", "storage/FileStorage", "model/common_application/UndoHistory"], (Editor, Deck, FileStorage, UndoHistory)  ->
        window.impressStarted = false
        deck = new Deck()
        deck.import(JSON.parse(json))
        html = ImpressRenderer.render(deck.attributes)

        document.getElementsByTagName("html")[0].innerHTML = html
        window.startImpress(window.document, window)
        imp = window.impress()
        imp.init()
        current = imp.goto(0)
      )

  setInterval ( -> 
    window.impress().next()
  ), 10000

  setInterval ( ->
    window.preview.update()
  ), 600000

  window.preview = new Preview()
)
