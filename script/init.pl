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
 
    init_code   => "eval \$(perl -I $ENV{HOME}/perl5/lib/perl5/ -Mlocal::lib)",
    program     => "plackup",
    program_args => [ qw/
      --server Gazelle
      --port 5000
      --host localhost
      --max-workers 32
      /,
      "$Bin/../mk3_appserver.psgi"
    ],
 
    pid_file    => "$Bin/../../mk3appserver.pid",
    stderr_file => "$Bin/../../mk3appserver.err",
    stdout_file => "$Bin/../../mk3appserver.out",
 
    fork        => 2,
 
)->run;
