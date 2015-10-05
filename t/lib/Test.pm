package t::lib::Test;
use strict;
use warnings;

our @pages = qw(index.html hidden/index.html hidden/protected/index.html a.html b.html c.html one.html two.html three.html);

my $pid;

sub run {
	my $port = 5001 + int rand(100);
	
	$pid = fork();
	if (not $pid) {
	    exec "plackup -p $port --access-log /dev/null   app.psgi";
	}
	
	sleep 1; # give time server to launch
	return $port;

}

END {
    kill 9, $pid if $pid;
}

1;

