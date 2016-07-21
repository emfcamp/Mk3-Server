use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/lib";
use Mk3::AppServer;

my $app = Mk3::AppServer->apply_default_middlewares(Mk3::AppServer->psgi_app);
$app;

