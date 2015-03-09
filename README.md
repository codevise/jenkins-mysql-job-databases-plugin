# Jenkins MySQL Job Databases Plugin

[github.com/codevise/jenkins-mysql-job-databases-plugin](http://github.com/codevise/jenkins-mysql-job-databases-plugin)

Automatically set up test databases for Jenkins jobs.

## Usage

In the global Jenkins configuration, set up host and port of your
MySQL server and enter credentials of the MySQL user that shall be
used to create databases and grant permissions. Note that this user
needs the
[`GRANT OPTION`](http://dev.mysql.com/doc/refman/5.1/en/privileges-provided.html#priv_grant-option)
which is not included in
[`ALL PRIVILEGES`](http://dev.mysql.com/doc/refman/5.1/en/privileges-provided.html#priv_all).

Configure a database name in a job. The plugin ensures the database
exists when the job is run. It grants all permissions for the database
to a job specific user and publishes its credentials in the
environment variables $MYSQL_USER and $MYSQL_PASSWORD.

## Contributors

* [Tim Fischbach](https://github.com/tf) (`tfischbach@codevise.de`)
* [Nicolas Rodriguez](https://github.com/n-rodriguez) (`nrodriguez@jbox-web.com`)

## See also

There is also a PostgreSQL variant of this plugin:

[lmlima/jenkins-postgresql-job-databases-plugin](https://github.com/lmlima/jenkins-postgresql-job-databases-plugin)

## License

Please fork and improve.

Copyright (c) 2014 Codevise Solutions Ltd. This software is licensed under the MIT License.
