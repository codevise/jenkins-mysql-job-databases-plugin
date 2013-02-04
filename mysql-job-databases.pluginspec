Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'mysql-job-databases'
  plugin.display_name = 'MySQL Job Databases'
  plugin.version = '0.0.1'
  plugin.description = 'Automatically create a MySQL database for a job.'

  plugin.url = 'https://github.com/codevise/jenkins-mysql-job-databases-plugin'
  plugin.developed_by 'Tim Fischbach', 'tfischbach@codevise.de'
  plugin.uses_repository :github => 'codevise/jenkins-mysql-job-databases-plugin'

  plugin.depends_on 'ruby-runtime', '0.10'
end
