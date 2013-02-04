# Jenkins MySQL Job Databases Plugin

[github.com/codevise/jenkins-mysql-job-databases-plugin](http://github.com/codevise/jenkins-mysql-job-databases-plugin)

Automatically set up test databases for Jenkins jobs.

## Usage

Configure database name in job. The plugin ensures the database exists
when the job is run. It grants all permissions for the database to a
job specific user and publishes its credentials in the environment
variables $MYSQL_USER and $MYSQL_PASSWORD.

## Limitations

Since I could not figure out yet how to make Jenkins persist data from
global configuration fields, this plugin requires a MySQL user
`jenkins` with password `jenkins`. Any input on how to improve this
situation is greatly appreciated. Moreover, please note that the
`jenkins` user needs the
[`GRANT OPTION`](http://dev.mysql.com/doc/refman/5.1/en/privileges-provided.html#priv_grant-option)
which is not included in
[`ALL PRIVILEGES`](http://dev.mysql.com/doc/refman/5.1/en/privileges-provided.html#priv_all).

## License

Please fork and improve.

Copyright (c) 2013 Codevise Solutions Ltd. This software is licensed under the MIT License.
