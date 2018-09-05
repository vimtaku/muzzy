module Muzzy
  class HeaderDetector
    # true: first row is header
    # false: first row is not header
    # nil: could not detect
    def self.detect(rows)
      first_row, second_row = rows || []
      return nil if first_row.empty?

      if first_row.any?{|str| str.to_s.match(/_id/i) }
        return true
      elsif first_row.any?{|str| str.to_s.match(/NULL/) }
        return false
      elsif first_row.any?{|str| str.to_s == '' }
        return false
      end

      return nil if second_row.empty?

      # I can't detect first_row is header or not, so guess now.

      # general header row is not contain numbers
      first_row_number_count = first_row.select{|str| str.to_f > 0}.length
      return false if first_row_number_count > 0

      # If number col count is different, I guess first_row is header.
      if first_row_number_count != second_row.select{|x| x.to_f > 0}.count
        return true
      end

      return nil
    end
  end
end
