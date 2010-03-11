module WebStamina
  class GridTools
    
    # Redblue results on the grid
    REDBLUE_RESULTS = {
      2 => {"100%" => 0.99, "50%" => 0.95, "25%" => 0.67, "12.5%" => 0.66},
      5 => {"100%" => 0.97, "50%" => 0.78, "25%" => 0.59, "12.5%" => 0.52},
      10 => {"100%" => 0.93, "50%" => 0.64, "25%" => 0.51, "12.5%" => 0.50},
      20  => {"100%" => 0.91, "50%" => 0.63, "25%" => 0.54, "12.5%" => 0.51},
      50  => {"100%" => 0.81, "50%" => 0.64, "25%" => 0.57, "12.5%" => 0.50}
    }
    
    # Sample sparsity
    SPARSITY = ['100%', '50%', '25%', '12.5%']
    
    # Alphabet sizes
    ALPHABETS = [2, 5, 10, 20, 50]
    
    ############################################################################################
    ### Initialization
    ############################################################################################

    # Creates a tools instance
    def initialize(database)
      @database = database
    end
    
    # Converts a Sequel dataset to a grid as hashes of hashes
    def to_hash_grid(dataset)
      grid = Hash.new{|h,k| h[k] = {}}
      dataset.each{|t| grid[t[:alphabet_size]][t[:sample_sparsity]] = t}
      grid
    end

    ############################################################################################
    ### Tools to generate HTML grids
    ############################################################################################

    #
    # Used by grid for rendering a cell by calling a block. This method
    # is not intended to be used by end users.
    #
    def subgrid(alph, &block)
      i = -1
      cells = SPARSITY.collect{|s|
        i += 1
        first = (1 + (ALPHABETS.index(alph)*20) + i*5)
        last = first+4
        yield(s, alph, (first..last))
      }
      cells = cells.collect {|block_result|
        case block_result
          when Hash
            "<td class=\"#{block_result[:css_class]}\">#{block_result[:label]}</td>"
          else
            "<td>#{block_result}</td>"
        end
      }
      "<th>#{alph}</th>" + cells.join
    end
    
    #
    # Generates an HTML table for the grid. This method expects a block
    # of arity 2 that will render the content of a given cell. Parameters
    # passed to the block are:
    #
    # - sparity: sparity of the sample for the cell
    # - alph: size of the alphabet for the cell
    # - range: a Range object with problem numbers for the cell
    #
    def grid(caption = nil, cssclass=nil, &block)
      cssclass = cssclass.nil? ? "" : " class=\"#{cssclass}\"" 
      caption = caption.nil? ? "" : "<caption>#{caption}</caption>"
      <<-EOF
        <table#{cssclass}>
          #{caption}
          <tr>
            <th rowspan="2" colspan="2">
              <th colspan="5">Sparsity of the training sample</th>
              <tr>
                <th>#{SPARSITY.join("</th><th>")}</th>
              </tr>
            </th>
          </tr>
          <tr>
            <th rowspan="6">Alphabet size</th>
            <tr>#{ALPHABETS.collect{|a| subgrid(a, &block)}.join('</tr><tr>')}</tr>
          </tr>
        </table>
      EOF
    end
    
    ############################################################################################
    ### About the abstract grid
    ############################################################################################

    # 
    # Creates the HTML grid that presents the problem ranges.
    #
    # ATTENTION: the HTML result is put in cache, caption and cssclass should always be the same
    # is used multiple times.
    #
    def abstract_grid(caption = nil, cssclass = nil)
      @abstract_grid ||= grid(caption, cssclass){|sparsity, alph, range| "#{range.first} - #{range.last}"}
    end
    
    ############################################################################################
    ### About the points grid
    ############################################################################################

    # Returns the number of points of a given cell
    def pointsfor(sparsity, alph) 
      case REDBLUE_RESULTS[alph][sparsity]
        when 0.9..1.0
          1
        when 0.7...0.9
          2
        when 0.6...0.7
          3
        else
          4
      end
    end
    
    # 
    # Creates the HTML grid that presents the grid with points in each cell.
    #
    # ATTENTION: the HTML result is put in cache, caption and cssclass should always be the same
    # is used multiple times.
    #
    def points_grid(caption = nil, cssclass = nil)
      @points_grid ||= grid(caption, cssclass){|sparsity, alph, range| pointsfor(sparsity, alph)}
    end
    
    ############################################################################################
    ### About the competition grid
    ############################################################################################
    
    # Returns the competition grid. Never put in cache.
    def competition_grid
      hash_grid = to_hash_grid(@database.handler[:broken_cells])
      grid(nil, "competition-grid"){ |sparsity, alph, range| 
        tuple = hash_grid[alph][sparsity]
        label = tuple ? "#{tuple[:nickname]}/#{tuple[:algorithm]}" : ""
        {:label => "<a href=''>#{label}</a>", :css_class => tuple ? tuple[:cell_status] : 'inactive'}
      }
    end
    
    ############################################################################################
    ### About the download grids
    ############################################################################################
    
    # Returns the download url for a given training set
    def training_set_download_url(sparsity, alph, problem_id)
      "downloads/training_sample_#{problem_id}.txt"
    end
    
    # Returns the download url for a given test set
    def test_set_download_url(sparsity, alph, problem_id)
      "downloads/test_sample_#{problem_id}.txt"
    end
    
    # 
    # Creates the HTML grid that presents the grid with training set downloads.
    #
    # ATTENTION: the HTML result is put in cache, caption and cssclass should always be the same
    # is used multiple times.
    #
    def training_download_grid(caption = nil, cssclass = nil)
      @training_download_grid ||= grid(caption, cssclass){|sparsity, alph, range| range.collect{|r| 
        url = training_set_download_url(sparsity, alph, r)
        "<a href='#{url}'>#{r}</a>"}.join("&nbsp;-&nbsp;") 
      }
    end
    
    # 
    # Creates the HTML grid that presents the grid with test set downloads.
    #
    # ATTENTION: the HTML result is put in cache, caption and cssclass should always be the same
    # is used multiple times.
    #
    def test_download_grid(caption = nil, cssclass = nil)
      @test_download_grid ||= grid(caption, cssclass){|sparsity, alph, range| range.collect{|r| 
        url = test_set_download_url(sparsity, alph, r)
        "<a href='#{url}'>#{r}</a>"}.join("&nbsp;-&nbsp;") 
      }
    end
    
    ############################################################################################
    ### About the submission grids
    ############################################################################################
    
    # URL when clicking a link inside the problem-based submission grid
    def problem_based_submission_url(sparsity, alph, problem_id)
      "javascript:select_problem_for_submission('#{problem_id}')"
    end
    
    # 
    # Creates the HTML grid that presents the grid with problem-based submissions.
    #
    def problem_based_submission_grid(caption = nil, cssclass = nil)
      grid(caption, cssclass){|sparsity, alph, range| range.collect{|r| 
        url = problem_based_submission_url(sparsity, alph, r)
        "<a href=\"#{url}\">#{r}</a>"}.join("&nbsp;") 
      }
    end
    
    # URL when clicking a link inside the cell-based submission grid
    def cell_based_submission_url(sparsity, alph, range)
      "javascript:select_cell_for_submission('#{range}')"
    end
    
    # 
    # Creates the HTML grid that presents the grid with cell-based submissions.
    #
    def cell_based_submission_grid(caption = nil, cssclass = nil)
      grid(caption, cssclass){|sparsity, alph, range|
        url = cell_based_submission_url(sparsity, alph, range)
        "<a href=\"#{url}\">#{range}</a>"
      } 
    end
    
  end # end GridTools
end # module WebStamina