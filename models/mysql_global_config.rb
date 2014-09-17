require_relative 'mysql_global_config_descriptor'

include Java

class MysqlGlobalConfig < Jenkins::Model::RootAction
  include Jenkins::Model
  include Jenkins::Model::DescribableNative
  describe_as Java.hudson.model.Descriptor, :with => MysqlGlobalConfigDescriptor
end

Jenkins::Plugin.instance.register_extension(MysqlGlobalConfig)
