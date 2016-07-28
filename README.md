# Mk3::AppServer

App server for the Mk3 EMFCamp badge.

# Initial Setup

## Environment

First step, is to set up your environment. For this, you will need:

* curl
* build-essential (or whatever your distro has for make etc.)

And then just run the following commands:

```
curl -L https://cpanmin.us/ | perl - App::cpanminus local::lib --local-lib=~/perl5
echo 'eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)' >> ~/.bashrc
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

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
./script/deploy.pl install -c <connection string>

# With username and password
./script/deploy.pl install -c <connection string> -u <username> -p <password>
```

## Config File

For the config file, create a file called 'mk3_appserver_local.conf', and add
the following to it:

```
<Model::DB>
  <connect_info>
    dsn <connection string from above>
    user <username, if applicable>
    password <pass, if applicable>
  </connect_info>
  storage_path /path/to/filestore
</Model::DB>
```

Replacing the dsn, user, password, and storage path as required.

# Deployment

To deploy the app, first set up your environment, database, and config file,
and then run the following commands:

```
cpanm --installdeps .
./script/deploy.pl install -c <connection string>
```

and then you can start the server as one of the following methods.

## Production

To start a production server, run the following:

```
./script/init.pl start
```

This will start the application up, listening on http://localhost:5000/

## Development

To set up for development, run the following commands:

```
CATALYST_DEBUG=1 ./script/mk3_appserver_server.pl -r
```

This will start up a local testing server in debug mode, which will
automatically reload on any changes to the codebase, listening on
http://0:3000/

# Postgres support

To install the required postgres modules, run the following:

```
cpanm --installdeps --with-feature postgres .
```
