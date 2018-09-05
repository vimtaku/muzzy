module Muzzy
  module DatabaseAdapter
    class AdapterBase
      def confirm_database; end
      def create_database; end
      def confirm_table; end
      def create_table; end
      def import; end
    end
  end
end
