use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Mk3::AppServer';
use Mk3::AppServer::Controller::Register;

ok( request('/register')->is_success, 'Request should succeed' );
done_testing();
