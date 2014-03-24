# Browse documents
$(document).on "page:change", ->
  
  # Unload previously loaded event binding
  $(".documents-browser-list-entry").off "click"

  # Display the document summary when user select one document
  $(".documents-browser-list-entry").click (e) ->
    e.preventDefaultBehavior
    $previouslySelected = $('.is-selected')
    $previouslySelected.removeClass 'is-selected'
    $selected = $(this)
    $selected.addClass 'is-selected'
    $selected.addClass 'is-processing'
    $.ajax $selected.data("document-display-summary-path"),
      dataType: "script",
      complete: ->
        $selected.removeClass 'is-processing'