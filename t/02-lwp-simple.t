use strict;
use warnings;

use t::lib::Test;
my ($port) = t::lib::Test::run();

# LWP::Simple can only download a page. It does not 'understand' the HTML it fetched nor would it
# abide by the rules of robots.txt

eval "use Test::More";
eval "use LWP::Simple qw(get)";
eval "use Path::Tiny qw(path)";


plan(tests => 1 * @t::lib::Test::pages);
diag("Port $port");

foreach my $page (@t::lib::Test::pages) {
    my $url = "http://127.0.0.1:$port/$page";
    $url =~ s/index.html//;
	my $content = path("www/$page")->slurp_utf8;
    #diag($url);
    my $html = get($url);
    is($html, $content);
    #diag($html);
}



