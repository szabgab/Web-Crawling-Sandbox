use strict;
use warnings;

my $port = 5001 + int rand(100);

my $pid = fork();
if (not $pid) {
    exec "plackup -p $port --access-log /dev/null   app.psgi";
}

sleep 1; # give time server to launch

eval "use Test::More";
eval "use LWP::Simple qw(get)";
eval "use Path::Tiny qw(path)";

eval "use t::lib::Test";

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


END {
    kill 9, $pid if $pid;
}

