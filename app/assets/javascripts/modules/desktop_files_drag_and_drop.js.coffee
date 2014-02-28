# Allow Drag and Drop file on the app to start upload
$(document).ready ->

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