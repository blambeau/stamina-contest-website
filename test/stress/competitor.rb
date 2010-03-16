module WebStamina
  module StressTest
    class Competitor
      include ::WebStamina::StressTest::Commons
      
      # The static locations
      STATIC_LOCATIONS = ["home", "protocol", "participate", "download", "baseline", "committee"]
      
      # What is the user able to do
      COMPETITOR_CHOICES = [:login_logout, :visit_static_page, :problem_based_submission, :cell_based_submission]
      
      # Creates a competitor instance
      def initialize(kernel, id, url)
        @kernel, @id, @base_url = kernel, id, url
        @browser = Waw::WSpec::Browser.new(url)
        @logged = false
      end
      
      # Logs the competitor in
      def login_logout
        if @logged
          puts "Competitor #{@id} is going to log out"
          @browser.invoke_action(@kernel.resources.controllers.people.logout)
          raise "Logout action failed" unless @browser.last_action_result == ["success", "ok"]
          @logged = false
        else
          puts "Competitor #{@id} is going to log in"
          @browser.invoke_action(
            @kernel.resources.controllers.people.login, 
            user_tuple(@id, false).keep(:mail, :password)
          )
          raise "Login action failed" unless @browser.last_action_result == ["success", "ok"]
          @logged = true
        end
      end
      
      # Visits a static page
      def visit_static_page
        visiting = STATIC_LOCATIONS[Kernel.rand(STATIC_LOCATIONS.size)]
        puts "Competitor #{@id} is visiting #{visiting}"
        @browser.location = @base_url + visiting
        raise "Visiting #{visiting} led to an error" unless @browser.is200
      end
      
      # Submitting a problem
      def problem_based_submission
        # first log in if not already logged
        login_logout unless @logged
        
        # go to the submission page
        puts "Competitor #{@id} is going to submit through the problem-based form"
        @browser.location = "competition/compete/chal#{@id}"
        raise "Visiting #{visiting} led to an error" unless @browser.is200

        # Invoke the submission action
        algo, problem = challenger_tuple(@id)[:algorithm], 1+Kernel.rand(99)
        binseq = randbinary(problem)
        @browser.invoke_action(
          @kernel.resources.controllers.compete.submit_problem,
          {:algorithm => algo, :problem => problem, :binseq => binseq}
        )
        action_result = @browser.last_action_result
        puts "Failed with #{binseq}" unless action_result[0] == "success"
        raise "Problem submit action failed #{action_result.inspect}" unless action_result[0] == "success"
      end
      
      # Submitting a cell
      def cell_based_submission
        # first log in if not already logged
        login_logout unless @logged
        
        # go to the submission page
        puts "Competitor #{@id} is going to submit through the cell-based form"
        @browser.location = "competition/compete/chal#{@id}"
        raise "Visiting #{visiting} led to an error" unless @browser.is200

        # Invoke the submission action
        algo, cell = challenger_tuple(@id)[:algorithm], 1+Kernel.rand(19)
        @browser.invoke_action(
          @kernel.resources.controllers.compete.submit_cell,
          {:algorithm => algo, 
           :cell => cell, 
           :binseq_1 => randbinary((1+(cell-1)*5)), 
           :binseq_2 => randbinary((2+(cell-1)*5)), 
           :binseq_3 => randbinary((3+(cell-1)*5)), 
           :binseq_4 => randbinary((4+(cell-1)*5)),
           :binseq_5 => randbinary((5+(cell-1)*5))}
        )
        action_result = @browser.last_action_result
        raise "Cell submit action failed #{action_result.inspect}" unless action_result[0] == "success"
      end
      
      # Run the competitor
      def run
        20.times do |i|
          begin
            self.send(COMPETITOR_CHOICES[Kernel.rand(COMPETITOR_CHOICES.size)])
          rescue => ex
            puts "FATAL ERROR, competitor #{@id} raised an error"
            puts ex.message
            puts ex.backtrace.join("\n")
            return
          end
        end
      end
      
    end # class Competitor
  end # module StressTest
end # module WebStamina