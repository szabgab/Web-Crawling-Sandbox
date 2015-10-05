use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET);
use Path::Tiny qw(path);

plan tests => 5;

my $app = do 'app.psgi';
isa_ok $app, 'CODE';

my $test = Plack::Test->create($app);

subtest main => sub {
	my @pages = qw(index.html hidden/index.html hidden/protected/index.html);
	plan tests => 5 * @pages;
	foreach my $page (@pages) {
		my $main = path("www/$page")->slurp_utf8;
		$page =~ s/index.html//;
		my $res = $test->request(GET "/$page");
		is $res->code, 200;
		is $res->message, 'OK';
		#diag $res->headers; #HTTP::Headers
		#diag explain [ $res->headers->header_field_names ];
		is $res->header('Content-Length'), length $main;
		is $res->header('Content-Type'), 'text/html; charset=utf-8';
		#diag $res->header('Last-Modified');
		is $res->content, $main;
	}
};

subtest abc => sub {
	plan tests => 3;

	my $res = $test->request(GET "/abc");
	is $res->code, 404; 
	is $res->message, 'Not Found';
	is $res->content, 'not found';
};

subtest img => sub {
	plan tests => 5;

	my $res = $test->request(GET "/img/code_maven.png");
	is $res->code, 200; 
	is $res->message, 'OK';
	is $res->header('Content-Length'), 4271;
	is $res->header('Content-Type'), 'image/png';
	is length $res->content, 4271;
};

subtest robots => sub {
	plan tests => 5;

	my $res = $test->request(GET "/robots.txt");
	is $res->code, 200; 
	is $res->message, 'OK';
	is $res->header('Content-Length'), -s 'www/robots.txt';
	is $res->header('Content-Type'), 'text/plain; charset=utf-8';
	is $res->content, path('www/robots.txt')->slurp_utf8;
}


