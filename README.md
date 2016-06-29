# Mk3::AppServer

App server for the Mk3 EMFCamp badge.

# Initial Setup

## Database

For any deployment, whether this be Production, Testing or Development, you
will need to create a database. You have the options of using PostgreSQL,
MySQL, or SQLite for the database. here are some example connection strings for
each:

```
# SQLite
dbi:SQLite:dbname=mydb.db

# MySQL
dbi:mysql:database=mydb;host=localhost

# PostgreSQL
dbi:Pg:dbname=mydb;host=localhost
```

With this you can deploy the schema to the database (for PostgreSQL and MySQL
you may need a username and password, if it is set up that way). To deploy to
each of these databases, run the following:

```
# Without username or password
./vendor/bin/carton exec script/deploy.pl install -c <connection string>

# With username and password
./vendor/bin/carton exec script/deploy.pl install -c <connection string> \
    -u <username> -p <password>
```

# Deployment

To set up and run the server, run the following commands:

```
./vendor/bin/carton install --deployment
# The database deployment string (see previous section)
./vendor/bin/carton exec script/mk3_appserver_server.pl
```

This will start the application up, listening on http://0:3000/

# Testing

To run the tests, run the following commands:

```
./vendor/bin/carton install --deployment
./vendor/bin/carton exec prove -l
```
