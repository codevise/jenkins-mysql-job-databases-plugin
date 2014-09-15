module MysqlBuilder
  class CreateDatabase < Jenkins::Tasks::BuildWrapper

    display_name "Create a MySQL database for the job"

    # Global MySQL account to create job account
    attr_reader :jenkins_mysql_user
    attr_reader :jenkins_mysql_password
    attr_reader :mysql_server_host
    attr_reader :mysql_server_port

    # Job MySQL account
    attr_reader :database
    attr_reader :job_mysql_user
    attr_reader :job_mysql_password


    def initialize(attrs)
      @database           = fix_empty(attrs['database'])
      @job_mysql_user     = fix_empty(attrs['job_mysql_user']) || default_job_mysql_user
      @job_mysql_password = fix_empty(attrs['job_mysql_password']) || default_job_mysql_password
    end


    def setup(build, launcher, listener)
      ## Get global config here as it's called for each build
      ## whereas in initialize it's called only once...
      mysql = get_mysql_connection(launcher)

      listener << "Ensuring MySQL database for job exists"

      if database.strip.empty?
        listener << "No database name configured for job.\n"
        build.abort
        return
      end

      mysql.execute("CREATE DATABASE IF NOT EXISTS #{database};")
      mysql.execute("GRANT ALL ON #{database}.*" +
                    " TO '#{job_mysql_user}'@'localhost'" +
                    " IDENTIFIED BY '#{job_mysql_password}';")

      build.env['MYSQL_DATABASE'] = database
      build.env['MYSQL_USER']     = job_mysql_user
      build.env['MYSQL_PASSWORD'] = job_mysql_password
    rescue MySQL::Error => e
      listener << "MySQL command failed:\n\n#{e.out}"
      build.abort
    end


    private


      def fix_empty(s)
        s == "" ? nil : s
      end


      def get_mysql_connection(launcher)
        get_db_config
        MySQL.new(launcher, jenkins_mysql_user, jenkins_mysql_password, mysql_server_host, mysql_server_port)
      end


      def get_db_config
        global_config = Java.jenkins.model.Jenkins.getInstance().getDescriptor(MysqlJobDatabaseWrapperDescriptor.java_class)

        @jenkins_mysql_user     = fix_empty(global_config.jenkins_mysql_user) || 'jenkins'
        @jenkins_mysql_password = fix_empty(global_config.jenkins_mysql_password) || 'jenkins'

        @mysql_server_host = fix_empty(global_config.jenkins_mysql_server_host) || '127.0.0.1'
        @mysql_server_port = fix_empty(global_config.jenkins_mysql_server_port) || '3306'
      end


      def default_job_mysql_user
        "#{database}_user"
      end


      def default_job_mysql_password
        "#{database}_jenkins_password"
      end

  end
end
