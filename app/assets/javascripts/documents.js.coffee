$(document).ready ->

  # Allow to classify documents using Drag and Drop
  $(".document-draggable").draggable
    start: (e, ui) ->
      $(ui.helper).addClass("is-dragging")
    opacity: 0.8
    helper: "clone"

  $(".document-droppable-area" ).droppable
    hoverClass: "is-hover"
    drop: ( event, ui ) ->
      console.log "TODO"