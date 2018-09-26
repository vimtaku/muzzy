module Muzzy
  module DatabaseAdapters
    class AdapterBase
      def confirm_database; end
      def create_database; end
      def confirm_table(table_name); end
      def create_table(table_name, columns); end
      def import; end
    end
  end
end
