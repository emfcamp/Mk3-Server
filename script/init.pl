#! /usr/bin/env perl

use strict;
use warnings;

use Daemon::Control;
use FindBin qw/ $Bin /;

exit Daemon::Control->new(
    name        => 'MK3 AppServer',
    lsb_start   => '$syslog $remote_fs',
    lsb_stop    => '$syslog',
    lsb_sdesc   => 'MK3 AppServer init',
    lsb_desc    => 'Init script for the MK3 Appserver fo EMF Camp',
 
    program     => "su -l $ENV{USER} $Bin/mk3_appserver_server.pl",
    program_args => [ qw/ -p 5000 -h localhost / ],
 
    pid_file    => "$Bin/../../mk3appserver.pid",
    stderr_file => "$Bin/../../mk3appserver.err",
    stdout_file => "$Bin/../../mk3appserver.out",
 
    fork        => 2,
 
)->run;
