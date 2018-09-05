module Muzzy
  # read file content and detect filetype is csv or tsv or others
  class FiletypeDetector
    attr_reader :filepath
    attr_reader :first_row, :second_row
    attr_reader :filetype

    def initialize(filepath)
      @filepath = filepath
    end

    def tsv?
      detect || @filetype == 'tsv'
    end

    def csv?
      detect || @filetype == 'csv'
    end

    def unknown?
      detect || @filetype == 'unknown'
    end

    private

    def tsv_ext?
      File.basename(@filepath) =~ /\.tsv\z/
    end

    def detect
      return unless @filetype.nil?

      if tsv_ext?
        @first_row, @second_row = Muzzy::Util.fetch_header_and_first_row(@filepath, "\t")
        @filetype = 'tsv'
        return
      end

      ## csv(,) or csv(\t) or something

      csv_header_row, csv_first_row = Muzzy::Util.fetch_header_and_first_row(@filepath, ",")
      tsv_header_row, tsv_first_row = Muzzy::Util.fetch_header_and_first_row(@filepath, "\t")
      if csv_header_row == -1 && tsv_header_row == -1
        @first_row, @second_row, @filetype = -1, -1, 'unknown'
        return
      end

      if csv_header_row == -1
        @first_row, @second_row, @filetype = tsv_header_row, tsv_first_row, 'tsv'
        return
      end
      if tsv_header_row == -1
        @first_row, @second_row, @filetype = csv_header_row, csv_first_row, 'csv'
        return
      end

      ## rare case

      if csv_header_row.length > tsv_header_row.length
        @first_row, @second_row, @filetype = csv_header_row, csv_first_row, 'csv'
        return
      else
        @first_row, @second_row, @filetype = tsv_header_row, tsv_first_row, 'tsv'
        return
      end

      if csv_header_row.length == 1 && tsv_first_row.length == 1
        # single col file treat as csv
        @first_row, @second_row, @filetype = csv_header_row, csv_first_row, 'csv'
        return
      end

      @first_row, @second_row, @filetype = -1, -1, 'unknown'
    end
  end
end
