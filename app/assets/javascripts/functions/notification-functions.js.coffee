# Manage app notifications
window.notification = {}

window.notification.notify = (html, forever=false) ->
  $notification = $("<p>").addClass "notify"
  $notification.html html
  $("#notification-area").append $notification
  if !forever
    notification.hide $notification
  return $notification

window.notification.hide = ($notification, delay=5000) ->
  $notification.delay(delay).fadeOut(500)