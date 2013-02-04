require 'stringio'

class MysqlJobDatabaseWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Create a MySQL databse for the job"

  attr_reader :jenkins_mysql_user, :jenkins_mysql_password
  attr_reader :database
  attr_reader :job_mysql_user, :job_mysql_password

  def initialize(attrs)
    # TODO: Figure out how to make these configurable in global settings
    @jenkins_mysql_user = 'jenkins' # fix_empty(attrs['jenkins_mysql_user'])
    @jenkins_mysql_password = 'jenkins' # fix_empty(attrs['jenkins_mysql_password'])

    @database = fix_empty(attrs['database'])
    @job_mysql_user = fix_empty(attrs['job_mysql_user']) || default_job_mysql_user
    @job_mysql_password = fix_empty(attrs['job_mysql_password']) || default_job_mysql_password
  end

  def setup(build, launcher, listener)
    mysql = MySQL.new(launcher, jenkins_mysql_user, jenkins_mysql_password)
    listener << "Ensuring MySQL databse for job exists"

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
    build.env['MYSQL_USER'] = job_mysql_user
    build.env['MYSQL_PASSWORD'] = job_mysql_password
  rescue MySQL::Error => e
    listener << "MySQL command failed:\n\n#{e.out}"
    build.abort
  end

  private

  def fix_empty(s)
    s == "" ? nil : s
  end

  def default_job_mysql_user
     "#{database}_user"
  end

  def default_job_mysql_password
    "#{database}_jenkins_password"
  end

  class MySQL
    class Error < RuntimeError;
      attr_reader :out

      def initialize(out)
        @out = out
      end
    end

    attr_reader :launcher, :user, :password

    def initialize(launcher, user, password)
      @launcher = launcher
      @user = user
      @password = password
    end

    def execute(command)
      out = StringIO.new()

      if launcher.execute("bash", "-c", "mysql -u '#{user}' -p'#{password}' --execute \"#{command}\"", {:out => out}) != 0
        raise Error.new(out.string), 'MySQL command failed'
      end

      out.string
    end
  end
end
