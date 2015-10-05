use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'Web::Crawling::Sandbox',
	AUTHOR       => q{Gabor Szabo <szabgab@cpan.org>},
	VERSION      => '0.01',
	ABSTRACT     => 'A standard way to try web crawlers in a sandbox',
	PREREQ_PM => {
		'Plack::Builder'   => 0,
		'Plack::App::File' => 0,
		'Test::WWW::Mechanize'        => 1.44,
		'Test::WWW::Mechanize::PSGI'  => 0.35,
		'Test::More'                  => 1,
		'Plack::Test'                 => 0,
		'Plack::Middleware::DirIndex' => 0,
		'HTTP::Request::Common'       => 0,
		'Path::Tiny'                  => 0,


	},
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
