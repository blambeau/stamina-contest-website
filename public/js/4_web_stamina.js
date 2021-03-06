function switch_page(url) {
	window.location = url;
}
function show_popup(url, width, contd) {
	$.get(url, function(data) { 
		$('#popup').html(data); 
	  $('#popup').width(width);
		$('#popup').css("margin-left", "-" + (width/2) + "px");
		$('#popup').css("top", (50+$(window).scrollTop()) + "px");
		inside_height = $('#inside').height()+100;
		window_height = $(window).height();
		$('#hide').height(inside_height > window_height ? inside_height : window_height);
		$('#hide').width($(window).width());
	  $('#hide').show();
		$('#popup').show();
    if (contd != null) { contd(); }
	});
}
function hide_popup(refresh) {
	$('#popup').hide();
  $('#hide').hide();
  if (refresh) { location.reload(true); }
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
function show_help(what) {
	show_popup('pages/help/' + what, 460);
}
function random_binary_sequence() {
	var s = "";
	for (i=0; i<1500; i++) {
		if (Math.random() <= 0.5) {
			s += "0";
		} else {
		  s += "1";
		}
	}
	return s;
}
function randbinary() {
	$('#binseq').val(random_binary_sequence());
}
function randbinaries() {
	for (var i=1; i<=5; i++) {
		$('#binseq_' + i).val(random_binary_sequence());
	}
}
