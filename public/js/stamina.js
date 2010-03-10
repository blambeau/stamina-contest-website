function select_problem_for_submission(problem_id) {
	$('#problem-id').html(problem_id);
}
function select_cell_for_submission(cell_id) {
	$('#cell-id').html(cell_id);
}
function show_popup(url, width) {
  $('#hide').show();
	$.get(url, function(data) { $('#popup').html(data); });
  $('#popup').width(width);
	$('#popup').css("margin-left", "-" + (width/2) + "px");
	$('#popup').show();
}
function hide_popup() {
	$('#popup').hide();
  $('#hide').hide();
}
function show_login_form()     { show_popup('pages/forms/login.wtpl', 460); }
function hide_login_form()     { hide_popup(); }
function show_subscribe_form() { show_popup('pages/forms/subscribe.wtpl', 460);}
function hide_subscribe_form() { hide_popup(); }
function show_contact_form()   { show_popup('pages/forms/contact.wtpl', 460); }
function hide_contact_form()   { hide_popup(); }