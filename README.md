# Mk3::AppServer

App server for the Mk3 EMFCamp badge.

# Deployment

To set up and run the server, run the following commands:

```
./vendor/bin/carton install --deployment
./vendor/bin/carton exec script/mk3_appserver_server.pl
```

This will start the application up, listening on http://0:3000/

# Testing

To run the tests, run the following commands:

```
./vendor/bin/carton install --deployment
./vendor/bin/carton exec prove -l
```
