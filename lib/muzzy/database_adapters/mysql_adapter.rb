module Muzzy
  module DatabaseAdapters
    class MysqlAdapter < AdapterBase
      def initialize(config, verbose: false)
        @filepath = config[:filepath]
        @cmd_path = config[:cmd_path]
        @import_cmd_path = config[:mysqlimport_path]
        @user = config[:user]
        @host = config[:host]
        @password = config[:password]
        @use_password = config[:use_password]
        @database_name = config[:database_name]
        @verbose = verbose
      end

      # [Bool] true: exists, false: nothing
      def confirm_database
        confirm_database_cmd_list = mysql_cmd_list + ['-e', '"' + "SHOW DATABASES LIKE '#{@database_name}'" + '"']
        confirm_database_cmd = confirm_database_cmd_list.join(' ')
        if @verbose
          $stderr.puts confirm_database_cmd
        end
        `#{confirm_database_cmd}`.chomp != ''
      end

      # [Bool] true: created, false: error happened
      def create_database
        $stderr.puts "creating database #{@database_name}"

        create_database_cmd_list = [*mysql_cmd_list, '-e', "'CREATE DATABASE #{@database_name}'"]
        create_database_cmd = create_database_cmd_list.join(' ')

        if @verbose
          $stderr.puts create_database_cmd
        end

        std_out = Open3.capture2(create_database_cmd)[0]
        if std_out == ''
          $stderr.puts "creating database #{@database_name} done"
        else
          $stderr.puts "error: #{std_out}"
        end

        std_out == ''
      end

      # [Bool] true: table exists, false: no table
      def confirm_table(table_name)
        confirm_table_cmd_list = [*mysql_cmd_list, @database_name, '-e', "'SHOW CREATE TABLE #{table_name}'"]
        confirm_table_cmd = confirm_table_cmd_list.join(' ')

        if @verbose
          $stderr.puts confirm_table_cmd
        end
        o, e, status = Open3.capture3(confirm_table_cmd)
        return status.success?
      end

      # [Bool] true: table created, false: some error happened
      def create_table(table_name, columns)
        create_table_sql = "CREATE TABLE #{table_name} (#{columns.map{|x| "#{x.name} #{x.datatype}"}.join(', ')})"
        create_table_cmd_list = [*mysql_cmd_list, @database_name, '-e', '"', "#{create_table_sql}", '"']
        create_table_cmd = create_table_cmd_list.join(' ')
        if @verbose
          $stderr.puts create_table_cmd
        end
        std_out, status = Open3.capture2(create_table_cmd)
        return status.success?
      end

      # {fields_terminated_by: '', delete: false,}
      def import(table_name, option)
        cmds = [*mysqlimport_cmd_list, @database_name, '--local', @filepath]
        cmds.push "--ignore-lines=#{option[:first_row_is_header] ? 1 : 0}"
        cmds.push('--fields_enclosed_by="')
        cmds.push('--default-character-set=sjis')

        if option[:fields_terminated_by]
          cmds.push("--fields_terminated_by=#{option[:fields_terminated_by]}")
        end
        if option[:delete]
          cmds.push('--delete')
        end

        if @verbose
          $stderr.puts cmds.join(' ')
        end

        # mysqlimport data
        system(*cmds)
      end

      private

      def mysql_cmd_list
        return @mysql_cmd_list if defined?(@mysql_cmd_list)
        @mysql_cmd_list = [@cmd_path] + common_param
      end

      def mysqlimport_cmd_list
        return @mysqlimport_cmd_list if defined?(@mysqlimport_cmd_list)
        @mysqlimport_cmd_list = [@import_cmd_path] + common_param
      end

      def common_param
        list = ['-u', @user, '-h', @host]
        if @use_password
          @list.push('-p')
        end
        list
      end
    end
  end
end
