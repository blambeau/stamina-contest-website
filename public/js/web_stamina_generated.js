/* This file is automatically generated by Waw. Any edit will probably be lost
 * next time the application is started. */

/* Messages, from waw.resources.messages */
var messages = new Array();
messages['bad_authorize'] = "Bad value sent by your browser for a checkbox";
messages['bad_challenger_name'] = "Your challenger name must contain between 2 and 10 characters";
messages['bad_mail'] = "Invalid e-mail address";
messages['bad_nickname'] = "Your nickname must contain between 2 and 10 characters";
messages['bad_password'] = "You password should contain at least 8 and maximum 15 characters";
messages['bad_user_or_password'] = "Unknown user or bad password";
messages['invalid_algorithm'] = "You cannot submit result for this algorithm";
messages['invalid_binary_sequence'] = "The binary sequence should contain '1' and '0' characters only and no spaces";
messages['invalid_binary_sequence_size'] = "The binary sequence you provided should contain 1500 characters";
messages['invalid_cell'] = "The cell identifier should be between 1 and 100";
messages['invalid_problem'] = "The problem identifier should be between 1 and 100";
messages['missing_challenger_name'] = "The challenger name is mandatory";
messages['missing_message'] = "The message is mandatory";
messages['missing_subject'] = "The subject is mandatory";
messages['passwords_dont_match'] = "Your passwords do not match";
messages['registration_mandatory'] = "All fields are mandatory";

/* Actions contributed by WebStamina::Controllers::PeopleController, mapped to / */
function webserv_people_activate_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/activate_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      window.location = '/feedback?mkey=server_error';
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
      
      } else {
       location.reload(true);}
    }
  });
  return false;
}  
function webserv_compete_submit_problem(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/compete/submit_problem", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
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
        if (data[1] == 'not_broken') {
      show_popup('/messages/problem_not_broken');
        } else if (data[1] == 'broken') {
      show_popup('/messages/problem_broken');
        }
      } else {
       location.reload(true);}
    }
  });
  return false;
}  