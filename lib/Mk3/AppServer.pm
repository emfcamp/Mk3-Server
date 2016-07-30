package Mk3::AppServer;

use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
  ConfigLoader
  Static::Simple
  Session
  Session::Store::FastMmap
  Session::State::Cookie
  Authentication
  Authorization::Roles
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in mk3_appserver.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
  name => 'Mk3::AppServer',
  # Disable deprecated behavior needed by old applications
  disable_component_resolution_regex_fallback => 1,
  enable_catalyst_header => 1, # Send X-Catalyst header

  default_view => 'TT',

  psgi_middleware => [ qw/
    XSendfile
  / ],

  'View::TT' => {
    INCLUDE_PATH => __PACKAGE__->path_to( qw/ root templates / ),
  },

  'View::Email::TT' => {
    INCLUDE_PATH => __PACKAGE__->path_to( qw/ root email-templates / ),
  },

  'Plugin::Authentication' => {
    default_realm => 'people',
    people  => {
      credential => {
        class => 'Password',
        password_field => 'password',
        password_type  => 'self_check',
      },
      store => {
        class => 'DBIx::Class',
        user_model => 'DB::User',
        role_relation => 'roles',
        role_field => 'name',
      },
    },
  },
);

__PACKAGE__->setup();

1;
