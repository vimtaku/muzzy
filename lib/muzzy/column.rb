module Muzzy
  class Column
    attr_reader :name
    attr_reader :datatype
    def initialize(datatype, name)
      @datatype = datatype
      @name = name
    end
  end
end
