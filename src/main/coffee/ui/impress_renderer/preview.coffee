define(["ui/impress_renderer/ImpressRenderer"],
(ImpressRenderer, Deck) ->
  class Preview
    update: (json) ->
      requirejs(["ui/editor/Editor", "model/presentation/Deck", "storage/FileStorage", "model/common_application/UndoHistory"], (Editor, Deck, FileStorage, UndoHistory)  ->
        window.impressStarted = false
        deck = new Deck()
        deck.import(JSON.parse(json))
        html = ImpressRenderer.render(deck.attributes)

        console.log(html)
        document.getElementsByTagName("html")[0].innerHTML = html
        window.startImpress(window.document, window)
        imp = window.impress()
        imp.init()
        current = imp.goto(0)
      )

   new Preview()
)
