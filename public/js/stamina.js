function switch_page(url) {
	window.location = url;
}
function show_popup(url, width) {
	$('html, body').animate( { scrollTop: 0 } );
	$.get(url, function(data) { $('#popup').html(data); });
  $('#popup').width(width);
	$('#popup').css("margin-left", "-" + (width/2) + "px");
	$('#hide').height($('#inside').height()+100);
  $('#hide').show();
	$('#popup').show();
}
function hide_popup() {
	$('#popup').hide();
  $('#hide').hide();
}  
function show_login_form()                { show_popup('pages/forms/login', 460);                           }
function show_subscribe_form()            { show_popup('pages/forms/subscribe', 460);                       }
function show_contact_form()              { show_popup('pages/forms/contact', 460);                         }
function show_create_challenger_form()    { show_popup('pages/competition/create_challenger', 460);         }
function show_problem_submission_form(algo, id) { 
	show_popup('pages/competition/problem_submission/' + algo + '/' + id, 460);  
}
function show_cell_submission_form(algo, id) { 
	show_popup('pages/competition/cell_submission/' + algo + '/' + id, 460);     
}