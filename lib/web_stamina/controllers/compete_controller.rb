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
            
      # Makes some submissions
      def make_submissions(people, algorithm, subs)
        tuples = subs.collect do |problem, binseq|
          {:people          => people,
           :algorithm       => algorithm,
           :problem         => problem,
           :submission_time => Time.now,
           :binary_sequence => binseq,
           :score           => score(binseq, problem)}
        end
        resources.db.transaction do |t|
          t.default.valid_submissions.send(:underlying_table).filter(
            :people => people, 
            :algorithm => algorithm,
            :problem => tuples.collect{|tuple| tuple[:problem]}
          ).delete
          t.default.submissions << tuples
          t.default.valid_submissions << tuples
        end
        case tuples.collect{|t| t[:score]}.select{|s| s >= 0.99}.size
          when 0
            :no_broken
          when subs.size
            :all_broken
          else 
            :some_broken
        end
      end
            
      # Challenger creation
      signature {
        validation :algorithm, logged,                   :user_must_be_logged
        validation :algorithm, valid_algorithm_name,     :invalid_algorithm_name
        validation :algorithm, algorithm_not_in_use,     :challenger_name_already_in_use
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
        validation :algorithm, logged,                         :user_must_be_logged
        validation :algorithm, valid_algorithm_name,           :invalid_algorithm_name
        validation :algorithm, valid_algorithm_for_submission, :invalid_algorithm
        validation :problem,   Integer & isin(1..100),         :invalid_problem
        validation :binseq,    valid_binary_sequence,          :invalid_binary_sequence
      }
      routing   { 
        upon 'validation-ko'       do form_validation_feedback           end
        upon 'success/no_broken'   do popup_message(:no_broken)          end
        upon 'success/all_broken'  do popup_message(:all_broken)         end
        upon 'success/some_broken' do popup_message(:some_broken)        end
        upon '*'                   do refresh                            end 
      }
      def submit_problem(params)
        people, algo, submissions = session.user_id, params[:algorithm], [[params[:problem], params[:binseq]]]
        make_submissions(people, algo, submissions)
      end
      
      # Submission of a whole cell
      signature {
        validation :algorithm, logged,                         :user_must_be_logged
        validation :algorithm, valid_algorithm_name,           :invalid_algorithm_name
        validation :algorithm, valid_algorithm_for_submission, :invalid_algorithm
        validation :cell,      Integer & isin(1..20),          :invalid_cell
        validation :sequences, valid_binary_sequences,         :invalid_binary_sequence
      }
      routing   { 
        upon 'validation-ko'       do form_validation_feedback           end
        upon 'success/no_broken'   do popup_message(:no_broken)          end
        upon 'success/all_broken'  do popup_message(:all_broken)         end
        upon 'success/some_broken' do popup_message(:some_broken)        end
        upon '*'                   do refresh                            end 
      }
      def submit_cell(params)
        range = resources.grid_tools.cell_token_to_range(params[:cell])
        people, algo, submissions = session.user_id, params[:algorithm], range.to_a.zip(params[:sequences])
        make_submissions(people, algo, submissions)
      end
      
      # Free submission
      signature {
        validation :algorithm, logged,                         :user_must_be_logged
        validation :algorithm, valid_algorithm_name,           :invalid_algorithm_name
        validation :algorithm, valid_algorithm_for_submission, :invalid_algorithm
        validation :cell,      Integer & isin(1..20),          :invalid_cell
        validation :cellfile,  valid_cellfile,                 :invalid_cellfile
      }
      routing   { 
        upon 'validation-ko'       do form_validation_feedback           end
        upon 'success/no_broken'   do popup_message(:no_broken)          end
        upon 'success/all_broken'  do popup_message(:all_broken)         end
        upon 'success/some_broken' do popup_message(:some_broken)        end
        upon '*'                   do refresh                            end 
      }
      def free_submit(params)
        people, algo, submissions = session.user_id, params[:algorithm], params[:cellfile]
        make_submissions(people, algo, submissions)
      end
      
    end # class CompeteController
  end # module Controller
end # module WebStamina