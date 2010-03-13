require 'tempfile'
module WebStamina
  class CellFileValidator < ::Waw::Validation::Validator 
    
    def validate(cellfile)
      convert_and_validate(cellfile)[0]
    end
    
    def convert_and_validate(cellfile)
      return [false, [cellfile]] unless Hash===cellfile
      return [false, [cellfile]] unless Tempfile===cellfile[:tempfile]
      return [false, [cellfile]] unless File.exists?(cellfile[:tempfile].path) and File.readable?(cellfile[:tempfile].path)
      lines = File.readlines(cellfile[:tempfile].path).collect{|l| l.strip}.reject{|l| l.empty?}
      return [false, [cellfile]] unless (lines.size % 2 == 0)
      cells = []
      cells << [lines.shift, lines.shift] until lines.empty?
      cells.each{|cell|
        return [false, [cellfile]] unless /\d+/ =~ cell[0]
        return [false, [cellfile]] unless /^[01]+$/ =~ cell[1]
        cell[0] = cell[0].to_i
      }
      return [true, [cells]]
    end
      
  end
end