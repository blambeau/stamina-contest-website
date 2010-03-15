require 'digest/md5'
module WebStamina
  module Controllers
    class PeopleController < ::Waw::ActionController
      
      #############################################################################################
      # Initialization and tools
      #############################################################################################

      # Returns the mail agent to use
      def mail_agent
        @mail_agent = resources.business.mail_agent unless @mail_agent
        
        template = @mail_agent.add_template(:activation)
        template.from         = "The StaMinA competition <stamina@listes.uclouvain.be>"
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
        "%0#{256 / 4}x" % rand(2**256 - 1)
      end
      alias :generate_sid :generate_activation_key

      #############################################################################################
      # Login & logout
      #############################################################################################

      # Login action
      signature {
        validation :mail, mandatory & mail, :bad_user_or_password
        validation :password, (size>=8) & (size<=15), :bad_user_or_password
        validation [:mail, :password], authorized_user, :bad_user_or_password
        validation :remember_me, (boolean | default(false)), :bad_remember_me 
      }
      routing {
        upon 'validation-ko' do form_validation_feedback                 end
        upon 'success/ok'    do redirect(:url => 'competition/compete')  end
      }
      def login(params)
        resources.db.transaction do |t|
          t.users(params.keep(:mail)).update(:remember_me => generate_sid)
        end if params[:remember_me]
        session_set(:user, params[:mail])
        :ok
      end
      
      # Logout action
      signature {}
      routing { 
        upon 'success/ok' do redirect(:url => 'home') end
        upon '*'          do refresh                  end 
      }
      def logout(params)
        resources.db.transaction do |t|
          t.users(:mail => session.user).update(:remember_me => '')
        end if session.logged?
        session_unset(:user)
        :ok
      end
      

      #############################################################################################
      # Subscription
      #############################################################################################
      
      # Subscribe action
      signature {
        validation [:mail, :nickname, :password, :password_confirm, :last_name, :first_name], mandatory, :registration_mandatory
        validation :mail, mail, :bad_mail
        validation :mail, mail_not_in_use, :mail_already_used
        validation :password, (size>=8) & (size<=15), :bad_password
        validation :nickname, (size>=2) & (size <= 10), :bad_nickname
        validation :nickname, nickname_not_in_use, :nickname_already_used
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
          tuple.merge!(:id            => t.default.people.tuple_count+1, 
                       :activation    => activation_key, 
                       :password      => Digest::MD5.hexdigest(tuple[:password]),
                       :creation_time => Time.now)
          t.default.people << tuple
        end
        context = {:first_name      => params[:first_name], 
                   :hosting_site    => config.web_base, 
                   :activation_link => config.web_base + "activate?key=#{activation_key}"}
        mail_agent.send_mail(:activation, context, params[:mail])
        :ok
      end
      
      # Activate action
      signature { validation :key, valid_activation_key, :invalid_activation_key }
      routing {
        upon 'validation-ko' do popup_message(:invalid_activation_key) end
        upon 'success/ok'    do popup_message(:welcome)                end
      }
      def activate_account(params)
        resources.db.transaction do |t|
          user = t.user_tuple(:activation => params[:key])
          t.users(:id => user[:id]).update(:activation => "", :admin_level => 0)
          session_set(:user, user[:mail])
        end
        :ok
      end
      
      #############################################################################################
      # Contact with the organizers
      #############################################################################################
      
      # Contact action
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