use strict;
use warnings;
use v5.10;

print `make`;

# use ExtUtils::MakeMaker;

# WriteMakefile(
#     NAME                => 'SimpleAlbum',
#     AUTHOR              => q{Zeuxis.Lo <seekstudio@gmail.com>},
#     VERSION_FROM        => 'lib/SimpleAlbum.pm',
#     ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
#     ($ExtUtils::MakeMaker::VERSION >= 6.3002
#       ? ('LICENSE'=> 'perl')
#       : ()),
#     PL_FILES            => {},
#     PREREQ_PM => {
#         'Test::More'                      => 0,
#         'YAML'                            => 0,
#         'Dancer'                          => 1.311,
#         'Plack::Runner'                   => 0,
#         'Template::Toolkit'               => 0,
#         'Dancer::Plugin::FlashMessage'    => 0,
#         'Dancer::Plugin::DBIC'            => 0,
#         'DBIx::Class::Schema::Loader'     => 0,
#         'Dancer::Plugin::EscapeHTML'      => 0,
#         'Text::Trim'                      => 0,
#         'Email::Valid'                    => 0,
#         'Plack::Middleware::Session'      => 0,
#         'Plack::Middleware::CSRFBlock'    => 0,
#         'Plack::Handler::Starman'         => 0,
#         'Plack::Middleware::ReverseProxy' => 0,
#         'Plack::Middleware::Debug'        => 0,
#         'JavaScript::Minifier::XS'        => 0,
#         'CSS::Minifier::XS'               => 0,
#         'Image::Resize'                   => 0,
#         'Image::Size'                     => 0
#     },
#     dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
#     clean               => { FILES => 'SimpleAlbum-*' },
# );
