use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Mk3::AppServer';
use Mk3::AppServer::Controller::Logout;

ok( request('/logout')->is_redirect, 'Request should redirect' );
done_testing();
