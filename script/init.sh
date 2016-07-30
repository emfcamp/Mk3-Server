#! /bin/sh

eval $(perl -I $HOME/perl5/lib/perl5/ -Mlocal::lib)

perl script/init.pl $1
