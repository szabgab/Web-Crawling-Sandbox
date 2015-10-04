use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET);

plan tests => 1;

my $app = do 'app.psgi';

my $test = Plack::Test->create($app);
my $res = $test->request(GET "/");
diag $res->content;

ok 1;
