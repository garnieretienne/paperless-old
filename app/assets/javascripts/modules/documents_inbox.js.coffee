# Allow to unclassify documents using simple button
$(document).ready ->

  $(".documents-inbox-document-label-remove").click (e) ->
    e.preventDefault()
    $label = $(this)
    $document = $label.closest(".documents-inbox-document")
    $.ajax $document.data("document-path"),
      method: "PATCH",
      data: {document: {label_id: null}},
      dataType: "script"