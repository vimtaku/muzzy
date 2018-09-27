module Muzzy
  # generate columns from first row data
  class ColumnsGenerator
    def initialize(kakasi_path)
      @kakasi_path = kakasi_path
    end

    def generate(first_row_is_header, first_row)
      columns = []
      # convert header row to compatible with database table columns
      # ref https://dev.mysql.com/doc/refman/5.6/ja/identifiers.html
      if first_row_is_header
        # create column names from japanese headers.
        # trim invalid chars
        # noop if data is already ascii
        coulumn_names = first_row.map do |str|
          std_out = Open3.capture2('echo', str)[0]
          Open3.capture2(
            @kakasi_path,
            '-Ja', '-Ha', '-Ka', '-Ea', '-i', 'utf8', '-o', 'utf8',
            stdin_data: std_out
          )[0]
        end.map do |x|
          # kakasi returns ko^do if 'コード' given so replace it to _
          # space changes to _
          x.chomp.strip.gsub(/[\^]/, '_').gsub(/\s/, '_')
        end || first_row.dup

        columns = coulumn_names.map.with_index do |str, i|
          Muzzy::Column.new('text', coulumn_names[i])
        end
      else
        # first row is data (not header)
        columns = first_row.map.with_index do |str, i|
          Muzzy::Column.new('text', "col#{i}")
        end
      end
      columns
    end
  end
end
