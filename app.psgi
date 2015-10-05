use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;
use Plack::App::File;

sub redirect_to {
	my $url = shift;
	return sub {
		my $env = shift;
		my $req = Plack::Request->new($env);
		my $res = Plack::Response->new;
		$res->redirect($url, 301);
		return $res->finalize;
	};
}


my $app = Plack::App::File->new(root => "www")->to_app;

builder {
	mount '/a'   => builder { redirect_to('/a.html') },
	mount '/'    => builder {
		enable "DirIndex", dir_index => 'index.html';
		$app;
	}
}

