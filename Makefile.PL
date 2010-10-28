use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CouchDB::Simple',
    AUTHOR              => q{Khaled Hussein <khaled.hussein@gmail.com>},
    VERSION_FROM        => 'lib/CouchDB/Simple.pm',
    ABSTRACT_FROM       => 'lib/CouchDB/Simple.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CouchDB-Simple-*' },
);
