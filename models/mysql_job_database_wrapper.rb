require_relative 'unprotected_root_action'
require_relative 'mysql_job_database_wrapper_descriptor'

include Java

class MysqlJobDatabaseWrapper < Jenkins::Model::UnprotectedRootAction
  include Jenkins::Model
  include Jenkins::Model::DescribableNative
  describe_as Java.hudson.model.Descriptor, :with => MysqlJobDatabaseWrapperDescriptor
end

Jenkins::Plugin.instance.register_extension(MysqlJobDatabaseWrapper)
