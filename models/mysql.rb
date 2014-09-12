require 'stringio'

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
