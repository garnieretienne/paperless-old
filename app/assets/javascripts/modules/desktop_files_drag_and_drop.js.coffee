# Allow Drag and Drop file on the app to start upload
$(document).on "page:change", ->

  # Unlock the dataTransfer property in JQuery
  # Originally solved by Tim Branyen in his drop file plugin
  # http://dev.aboutnerd.com/jQuery.dropFile/jquery.dropFile.js
  jQuery.event.props.push('dataTransfer')

  $filesDragAndDrop = $(".drag-and-drop-files")

  $(document).on "dragover", (e) ->
    e.preventDefault()
    e.stopPropagation()

  $(document).on "dragenter", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-drag-and-drop-files-active")

  $(document).on "dragleave", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-drag-and-drop-files-active")
    
  $filesDragAndDrop.on "drop", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $filesDragAndDrop.toggleClass("is-drag-and-drop-files-active")
    files = e.dataTransfer.files
    $.each files, (index, file) ->
      console.log file
      $notification = notification.notify "<strong>Uploading</strong> \"#{file.name}\"...", true
      data = new FormData()
      data.append 'file', file
      $.ajax $filesDragAndDrop.data("documents-path"),
        method: "POST",
        data: data,
        dataType: "script",
        processData: false, 
        contentType: false,
        complete: ->
          notification.hide $notification, 1