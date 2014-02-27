$(document).ready ->

  # Allow to classify documents using Drag and Drop
  $(".label-draggable").draggable
    start: (e, ui) ->
      $(ui.helper).addClass("is-dragging")
    helper: "clone"
  $(".document-droppable-area").droppable
    hoverClass: "is-hover"
    drop: ( event, ui ) ->
      $document = $(event.target)
      $label = $(ui.draggable)
      $.ajax $document.data("document-path"),
        method: "PATCH",
        data: {document: {label_id: $label.data("label-id")}},
        dataType: "script"

  # Allow to unclassify documents using simple button
  $(".documents-inbox-document-label-remove").click (e) ->
    e.preventDefault()
    $label = $(this)
    $document = $label.closest(".documents-inbox-document")
    $.ajax $document.data("document-path"),
      method: "PATCH",
      data: {document: {label_id: null}},
      dataType: "script"
      