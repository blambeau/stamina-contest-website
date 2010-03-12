require 'digest/md5'
module WebStamina
  module Controllers
    class PeopleController < ::Waw::ActionController
      
      # Returns the mail agent to use
      def mail_agent
        @mail_agent = resources.business.mail_agent unless @mail_agent
        
        template = @mail_agent.add_template(:activation)
        template.from         = "The StaMiNA competition <stamina@listes.uclouvain.be>"
        template.subject      = "Your competitor account for StaMinA"
        template.content_type = 'text/html'
        template.charset      = 'UTF-8'
        template.body         = File.read(File.join(File.dirname(__FILE__), 'activation_mail.wtpl'))
        
        template = @mail_agent.add_template(:contact)
        template.to           = ["stamina@listes.uclouvain.be"]
        template.subject      = "${subject}"
        template.content_type = 'text/html'
        template.charset      = 'UTF-8'
        template.body         = File.read(File.join(File.dirname(__FILE__), 'contact_mail.wtpl'))
        
        @mail_agent
      end
      
      # Generates an activation key
      def generate_activation_key
        "%0#{128 / 4}x" % rand(2**128 - 1)
      end

      # Login
      signature {
        validation :mail, mandatory & mail, :bad_user_or_password
        validation :password, (size>=8) & (size<=15), :bad_user_or_password
        validation [:mail, :password], authorized_user, :bad_user_or_password
      }
      routing {
        upon 'validation-ko' do feedback end
        upon 'success/ok'    do redirect(:url => 'competition/compete')  end
      }
      def login(params)
        session_set(:user, params[:mail]) and :ok
      end
      
      # Logout
      signature {}
      routing { 
        upon 'success/ok' do redirect(:url => 'home') end
        upon '*'          do refresh                  end 
      }
      def logout(params)
        session_unset(:user)
        :ok
      end
      
      signature {
        validation [:mail, :nickname, :password, :password_confirm, :last_name, :first_name], mandatory, :registration_mandatory
        validation :mail, mail, :bad_mail
        validation :password, (size>=8) & (size<=15), :bad_password
        validation [:password, :password_confirm], (mandatory & same), :passwords_dont_match
        validation :authorize_submission_usage, (boolean | default(false)), :bad_authorize
      }
      routing {
        upon 'validation-ko' do form_validation_feedback                      end
        upon 'success/ok'    do popup_message(:subscription_ok)               end
      }
      def subscribe(params)
        activation_key = generate_activation_key
        resources.db.transaction do |t|
          tuple = params.keep(t.default.people.attribute_names)
          tuple[:password] = Digest::MD5.hexdigest(tuple[:password])
          tuple.merge!(:activation => activation_key, :id => t.default.people.tuple_count+1)
          t.default.people << tuple
        end
        context = {:first_name      => params[:first_name], 
                   :hosting_site    => config.web_base, 
                   :activation_link => config.web_base + "webserv/people/activate_account?key=#{activation_key}"}
        mail_agent.send_mail(:activation, context, params[:mail])
        :ok
      end
      
      # Activates an account
      signature { validation :key, valid_activation_key, :invalid_activation_key }
      routing {
        upon 'validation-ko' do popup_message(:invalid_activation_key) end
        upon 'success/ok'    do popup_message(:welcome)                end
      }
      def activate_account(params)
        result = resources.db.transaction do |t|
          t.default.people.send(:underlying_table).filter(:activation => params[:key]).update(:activation => "", :admin_level => 0)
        end
        :ok
      end
      
      # Login
      signature {
        validation :mail, mandatory & mail, :bad_mail
        validation :subject, mandatory, :missing_subject
        validation :message, mandatory, :missing_message
      }
      routing {
        upon 'validation-ko' do form_validation_feedback    end
        upon 'success/ok'    do popup_message(:contact_ok)  end
      }
      def contact(params)
        mail = mail_agent.to_mail(:contact, params)
        mail.from = params[:mail]
        mail_agent.send_mail(mail)
        :ok
      end
      
    end # class PeopleController
  end # module Controllers
end # module WebStamina