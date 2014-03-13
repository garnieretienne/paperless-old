# Allow to classify documents using Drag and Drop
$(document).on "page:change", ->

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
      $document.addClass 'is-processing'
      $.ajax $document.data("document-path"),
        method: "PATCH",
        data: {document: {label_id: $label.data("label-id")}},
        dataType: "script",
        complete: ->
          $document.removeClass 'is-processing'

  # Allow to unclassify documents using simple button
  $(".inbox-document .label-action").click (e) ->
    e.preventDefault()
    $labelAction = $(this)
    $document = $labelAction.closest(".inbox-document")
    $label = $labelAction.closest(".label")
    $label.addClass 'is-processing'
    $.ajax $document.data("document-path"),
      method: "PATCH",
      data: {document: {label_id: null}},
      dataType: "script",
      complete: ->
        $label.removeClass 'is-processing'