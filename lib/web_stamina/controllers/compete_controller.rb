module WebStamina
  module Controllers
    class CompeteController < ::Waw::ActionController
      
      signature {
        validation :algorithm, mandatory,                :missing_challenger_name
        validation :algorithm, (size>=2) & (size <= 10), :bad_challenger_name
      }
      routing {
        upon 'validation-ko' do form_validation_feedback                 end
        upon 'success/ok'    do redirect(:url => '/competition/compete') end
      }
      def create_challenger(params)
        resources.db.transaction do |t|
          t.default.challengers << {:people        => session.current_user[:id], 
                                    :algorithm     => params[:algorithm],
                                    :creation_time => Time.now}
        end
        :ok
      end
      
      signature { 
        validation :problem, Integer & isin(1..100),  :invalid_problem
        validation :binseq,  String & mandatory,      :invalid_binary_sequence
      }
      routing   { 
        upon 'validation-ko' do form_validation_feedback                      end
        upon '*' do refresh end 
      }
      def submit_problem(params)
        puts params.inspect
        :ok
      end
      
      signature {
        validation :cell, Integer & isin(1..20), :invalid_cell
      }
      routing   { 
        upon 'validation-ko' do form_validation_feedback                      end
        upon '*' do refresh end 
      }
      def submit_cell(params)
        puts params.inspect
        :ok
      end
      
    end # class CompeteController
  end # module Controller
end # module WebStamina