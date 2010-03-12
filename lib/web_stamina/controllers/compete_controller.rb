module WebStamina
  module Controllers
    class CompeteController < ::Waw::ActionController

      # Computes the harmonic BCR givent the four variables
      def harmonic_bcr(tp, fn, fp, tn)
        sensitivity = (1.0*tp)/(tp + fn)
        specificity = (1.0*tn)/(tn + fp)
        (2.0*(sensitivity*specificity))/(sensitivity+specificity)
      end

      # Computes a score for a given problem given a binary sequence
      def score(binseq, problem)
        reference = resources.sequel_db[:competition_data].filter(:problem => problem).first[:binary_sequence]
        return -1.0 if binseq.length != reference.length
        tp, fn, fp, tn = 0, 0, 0, 0
        (0...reference.length).each do |i|
          return -2.0 unless binseq[i..i]=='1' or binseq[i..i]=='0'
          positive, labeled_as = reference[i..i]=='1', binseq[i..i]=='1'
          if positive==labeled_as
            positive ? (tp += 1) : (tn += 1)
          else
            positive ? (fn += 1) : (fp += 1)
          end
        end
        harmonic_bcr(tp, fn, fp, tn)
      end
      
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
        validation :problem,   Integer & isin(1..100),  :invalid_problem
        validation :algorithm, String & mandatory,      :invalid_algorithm
        validation :binseq,    String & mandatory,      :invalid_binary_sequence
      }
      routing   { 
        upon 'validation-ko'      do form_validation_feedback           end
        upon 'success/not_broken' do popup_message(:problem_not_broken) end
        upon 'success/broken'     do popup_message(:problem_broken)     end
        upon '*'                  do refresh                            end 
      }
      def submit_problem(params)
        the_score = score(params[:binseq], params[:problem])
        resources.db.transaction do |t|
          tuple = {:people          => session.current_user[:id],
                   :algorithm       => params[:algorithm],
                   :problem         => params[:problem],
                   :submission_time => Time.now,
                   :binary_sequence => params[:binseq],
                   :score           => the_score}
          t.default.submissions << tuple
          t.default.valid_submissions.send(:underlying_table).filter(tuple.keep(:people, :algorithm, :problem)).delete
          (t.default.valid_submissions << tuple) if the_score >= 0.0
        end
        case the_score
          when -2.0
            raise ::Waw::Validation::KO, [:invalid_binary_sequence]
          when -1.0
            raise ::Waw::Validation::KO, [:invalid_binary_sequence_size]
          when (0.0...0.99)
            :not_broken
          when (0.99..1.0)
            :broken
          else
            raise "Unexpected situation"
        end
      end
      
      signature {
        validation :cell, Integer & isin(1..20),   :invalid_cell
        validation :algorithm, String & mandatory, :invalid_algorithm
      }
      routing   { 
        upon 'validation-ko' do form_validation_feedback end
        upon '*' do refresh end 
      }
      def submit_cell(params)
        puts params.inspect
        :ok
      end
      
    end # class CompeteController
  end # module Controller
end # module WebStamina