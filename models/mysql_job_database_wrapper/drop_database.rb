module MysqlJobDatabaseWrapper
  class DropDatabase < Jenkins::Tasks::Publisher

    display_name "Drop a MySQL database for the job"

    # Global MySQL account to delete job account
    attr_reader :jenkins_mysql_user
    attr_reader :jenkins_mysql_password

    # Job MySQL account
    attr_reader :database
    attr_reader :job_mysql_user


    def initialize(attrs)
      @jenkins_mysql_user     = 'jenkins'
      @jenkins_mysql_password = 'jenkins'

      @database       = fix_empty(attrs['database'])
      @job_mysql_user = fix_empty(attrs['job_mysql_user']) || default_job_mysql_user
    end


    def perform(build, launcher, listener)
      mysql = MySQL.new(launcher, jenkins_mysql_user, jenkins_mysql_password)

      drop_database(listener, mysql)
      drop_user(listener, mysql)
    end


    private


      def drop_database(listener, mysql)
        listener << "Drop MySQL database for job if exists"

        if database.strip.empty?
          listener << "No database name configured for job.\n"
        else
          mysql.execute("DROP DATABASE IF EXISTS #{database};")
        end
      rescue MySQL::Error => e
        listener << "MySQL command failed:\n\n#{e.out}"
      end


      def drop_user(listener, mysql)
        listener << "Drop MySQL user for job if exists"
        mysql.execute("REVOKE ALL PRIVILEGES, GRANT OPTION FROM '#{job_mysql_user}'@'localhost';")
        mysql.execute("DROP USER '#{job_mysql_user}'@'localhost';")
      rescue MySQL::Error => e
        listener << "MySQL command failed:\n\n#{e.out}"
      end


      def fix_empty(s)
        s == "" ? nil : s
      end


      def default_job_mysql_user
        "#{database}_user"
      end

  end
end
