# Originally solved by Tim Branyen in his drop file plugin
# http://dev.aboutnerd.com/jQuery.dropFile/jquery.dropFile.js
jQuery.event.props.push('dataTransfer')

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

  # Allow Drag and Drop file on the app to start upload
  $filesDragAndDrop = $(".drag-and-drop-files")
  $(document).on "dragover", (e) ->
    e.preventDefault()
    e.stopPropagation()
  $(document).on "dragenter", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-active")
  $(document).on "dragleave", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-active")
  $filesDragAndDrop.on "drop", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-active")
    files = e.dataTransfer.files
    $.each files, (index, file) ->
      data = new FormData()
      data.append 'file', file
      $.ajax $filesDragAndDrop.data("documents-path"),
        method: "POST",
        data: data,
        dataType: "script",
        processData: false, 
        contentType: false,
        success: (data) ->
          alert(data)