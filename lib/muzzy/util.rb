require 'csv'
require 'nkf'
module Muzzy
  class Util
    def self.fetch_header_and_first_row(filepath, col_sep)
      raise ArgumentError, "filepath required"  if filepath.nil?
      raise ArgumentError, "not found file" unless File.exists?(filepath)
      header_row, first_row = nil, nil

      from_fenc = 'UTF-8'
      File.open(filepath, "rt") do |f|
        s = f.readlines
        from_fenc = NKF.guess(s.join('')).to_s
      end
      open(filepath, "rb:#{from_fenc}:UTF-8", undef: :replace) do |f|
        CSV.new(f, col_sep: col_sep).each.with_index do |row, i|
          if i == 0
            header_row = row
          elsif i == 1
            first_row = row
          else
            break
          end
        end
      end

      return [header_row, first_row]
    rescue ArgumentError => e
      raise e
    rescue => e
      return [-1, -1]
    end
  end
end
