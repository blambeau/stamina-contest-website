/* This file is automatically generated by Waw. Any edit will probably be lost
 * next time the application is started. */

/* Messages, from waw.resources.messages */
var messages = new Array();
messages['bad_authorize'] = "Bad value sent by your browser for a checkbox";
messages['bad_mail'] = "Invalid e-mail address";
messages['bad_nickname'] = "Your nickname should have alphanumeric characters only (max 10)";
messages['bad_password'] = "You password should contain at least 8 and maximum 15 characters";
messages['bad_user_or_password'] = "Unknown user or bad password";
messages['challenger_name_already_in_use'] = "You already have a challenger with this name";
messages['invalid_algorithm'] = "You cannot submit result for this algorithm";
messages['invalid_algorithm_name'] = "Your algorithm should have alphanumeric characters only (max 10)";
messages['invalid_binary_sequence'] = "Binary sequence should contain 1500 characters (0 or 1) without any space";
messages['invalid_binary_sequence_1'] = "Your first binary sequence is invalid";
messages['invalid_binary_sequence_2'] = "Your second binary sequence is invalid";
messages['invalid_binary_sequence_3'] = "Your third binary sequence is invalid";
messages['invalid_binary_sequence_4'] = "Your fourth binary sequence is invalid";
messages['invalid_binary_sequence_5'] = "Your fifth binary sequence is invalid";
messages['invalid_cell'] = "The cell identifier should be between 1 and 100";
messages['invalid_problem'] = "The problem identifier should be between 1 and 100";
messages['mail_already_used'] = "An account already exists for this email address";
messages['missing_binary_sequence'] = "At least one binary sequence must be provided";
messages['missing_message'] = "The message is mandatory";
messages['missing_subject'] = "The subject is mandatory";
messages['nickname_already_used'] = "This nickname has already been choosen by a competitor";
messages['passwords_dont_match'] = "Your passwords do not match";
messages['registration_mandatory'] = "All fields are mandatory";
messages['user_must_be_logged'] = "You should be logged to invoke this service.";

/* Actions contributed by WebStamina::Controllers::PeopleController, mapped to / */
function webserv_people_activate_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/activate_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
      show_popup('/messages/invalid_activation_key');
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
      show_popup('/messages/welcome');
        }
      }
    }
  });
  return false;
}  
function webserv_people_contact(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/contact", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
      show_popup('/messages/contact_ok');
        }
      }
    }
  });
  return false;
}  
function webserv_people_login(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/login", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "competition/compete";
        }
      }
    }
  });
  return false;
}  
function webserv_people_logout(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/logout", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "home";
        }
      } else {
       location.reload(true);}
    }
  });
  return false;
}  
function webserv_people_subscribe(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/subscribe", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
      show_popup('/messages/subscription_ok');
        }
      }
    }
  });
  return false;
}  
/* Actions contributed by WebStamina::Controllers::CompeteController, mapped to / */
function webserv_compete_create_challenger(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/compete/create_challenger", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/competition/compete";
        }
      }
    }
  });
  return false;
}  
function webserv_compete_submit_cell(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/compete/submit_cell", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
                show_popup('/messages/' + data[1][0], function(){
                  $('#popup .scores').html("Exact BCR score(s): " + data[1][1].join(', '));
                });
      
      } else {
       location.reload(true);}
    }
  });
  return false;
}  
function webserv_compete_submit_problem(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/compete/submit_problem", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
                show_popup('/messages/' + data[1][0], function(){
                  $('#popup .scores').html("Exact BCR score(s): " + data[1][1].join(', '));
                });
      
      } else {
       location.reload(true);}
    }
  });
  return false;
}  
