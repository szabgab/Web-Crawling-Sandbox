use strict;
use warnings;

use t::lib::Test;
my ($port) = t::lib::Test::run();


eval "use Test::More";
eval "use HTTP::Async";
eval "use HTTP::Request";
eval "use Path::Tiny qw(path)";

plan(tests => 1);

my $async = HTTP::Async->new;

subtest(pages => sub {
	plan(tests => 3 * @t::lib::Test::pages);
	
	foreach my $page (@t::lib::Test::pages) {
		my $url = "http://127.0.0.1:$port/$page";
		$async->add( HTTP::Request->new( GET => $url ) );
	}
	
	while ( my $response = $async->wait_for_next_response ) { # HTTP::Response
		#diag($response->base); # though it might not be the original request
		my $file = substr($response->base, length("http://127.0.0.1/$port/"));
		my $content = path("www/$file")->slurp_utf8;
		is($response->code, 200);
		is($response->message, 'OK');
		is($response->content, $content);
	}
});


#{
#	$async->add( HTTP::Request->new( GET => 'http://127.0.0.1/a' ) );
#	my $response = $async->wait_for_next_response;
#	say $response->base;
#	say $response->content;
#}

