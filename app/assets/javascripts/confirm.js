$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}
//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  message = link.attr('data-confirm');
  $('.modal-body').html("<p> "+message+" </p>");
  $("#confirmation-modal").modal();
  $('#ok-button').on('click', function(){
    $.rails.confirmed(link);
  });
}