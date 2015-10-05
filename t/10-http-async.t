use strict;
use warnings;

use t::lib::Test;
my ($port) = t::lib::Test::run();


eval "use Test::More";
eval "use HTTP::Async";
eval "use HTTP::Request";
eval "use Path::Tiny qw(path)";

plan(tests => 2);

my $async = HTTP::Async->new;
my $URL = "http://127.0.0.1:$port/";

subtest(pages => sub {
	plan(tests => 3 * @t::lib::Test::pages);
	
	foreach my $page (@t::lib::Test::pages) {
		my $url = "$URL$page";
		$async->add( HTTP::Request->new( GET => $url ) );
	}
	
	while ( my $response = $async->wait_for_next_response ) { # HTTP::Response
		#diag($response->base); # though it might not be the original request
		my $file = substr($response->base, length($URL));
		my $content = path("www/$file")->slurp_utf8;
		is($response->code, 200);
		is($response->message, 'OK');
		is($response->content, $content);
	}
});


subtest(redir => sub {
	plan(tests => 4);
	$async->add( HTTP::Request->new( GET => $URL . 'a' ) );
	my $response = $async->wait_for_next_response;
	is($response->code, 200);
	is($response->message, 'OK');
	is($response->base, $URL . 'a.html'); # the URL where we got redirected to
	my $content = path("www/a.html")->slurp_utf8;
	is($response->content, $content);
});

