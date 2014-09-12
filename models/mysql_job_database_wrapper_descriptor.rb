include Java

java_import Java.hudson.BulkChange
java_import Java.hudson.model.listeners.SaveableListener

# java_import Java.java.util.logging.Logger
# java_import Java.java.util.logging.Level

class MysqlJobDatabaseWrapperDescriptor < Jenkins::Model::DefaultDescriptor

  # LOGGER = Logger.getLogger(MysqlJobDatabaseWrapperDescriptor.class.name)

  attr_accessor :jenkins_mysql_user
  attr_accessor :jenkins_mysql_password
  attr_accessor :jenkins_mysql_server_host
  attr_accessor :jenkins_mysql_server_port


  def initialize(*)
    super
    load

    # LOGGER.info "=========== GitlabWebHookRootActionDescriptor initialize ==================="
    # LOGGER.info "jenkins_mysql_user        : #{jenkins_mysql_user}"
    # LOGGER.info "jenkins_mysql_password    : #{jenkins_mysql_password}"
    # LOGGER.info "jenkins_mysql_server_host : #{jenkins_mysql_server_host}"
    # LOGGER.info "jenkins_mysql_server_port : #{jenkins_mysql_server_port}"
  end


  # @see hudson.model.Descriptor#load()
  def load
    return unless configFile.file.exists()
    from_xml(File.read(configFile.file.canonicalPath))
  end


  def from_xml(xml)
    @jenkins_mysql_user = xml.scan(/<jenkins_mysql_user>(.*)<\/jenkins_mysql_user>/).flatten.first
    @jenkins_mysql_password = xml.scan(/<jenkins_mysql_password>(.*)<\/jenkins_mysql_password>/).flatten.first
    @jenkins_mysql_server_host = xml.scan(/<jenkins_mysql_server_host>(.*)<\/jenkins_mysql_server_host>/).flatten.first
    @jenkins_mysql_server_port = xml.scan(/<jenkins_mysql_server_port>(.*)<\/jenkins_mysql_server_port>/).flatten.first
  end


  def configure(req, form)
    parse(form)

    # LOGGER.info "=========== GitlabWebHookRootActionDescriptor configure ==================="
    # LOGGER.info "form: #{form.inspect}"
    # LOGGER.info "getId: #{getId()}"
    # LOGGER.info "getConfigFile: #{getConfigFile()}"

    save
    true
  end


  def parse(form)
    @jenkins_mysql_user     = form["jenkins_mysql_user"]
    @jenkins_mysql_password = form["jenkins_mysql_password"]

    @jenkins_mysql_server_host = form["jenkins_mysql_server_host"]
    @jenkins_mysql_server_port = form["jenkins_mysql_server_port"]
  end


  # @see hudson.model.Descriptor#save()
  def save
    return if BulkChange.contains(self)

    begin
      File.open(configFile.file.canonicalPath, 'wb') { |f| f.write(to_xml) }
      SaveableListener.fireOnChange(self, configFile)
    rescue IOError => e
      puts "ERROR!"
      # LOGGER.log(Level::SEVERE, "Failed to save #{configFile}: #{e.message}", e)
    end
  end


  def to_xml
"<?xml version='1.0' encoding='UTF-8'?>
<#{id} plugin=\"mysql-job-databases\">
  <jenkins_mysql_user>#{@jenkins_mysql_user}</jenkins_mysql_user>
  <jenkins_mysql_password>#{@jenkins_mysql_password}</jenkins_mysql_password>
  <jenkins_mysql_server_host>#{@jenkins_mysql_server_host}</jenkins_mysql_server_host>
  <jenkins_mysql_server_port>#{@jenkins_mysql_server_port}</jenkins_mysql_server_port>
</#{id}>"
  end

end
