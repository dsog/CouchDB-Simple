use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CouchDB::Simple',
    AUTHOR              => 'Khaled Hussein <khaled.hussein@gmail.com>',
    VERSION_FROM        => 'lib/CouchDB/Simple.pm',
    ABSTRACT_FROM       => 'lib/CouchDB/Simple.pm',
    PREREQ_PM => {
        'JSON'           => 0,
        'LWP::UserAgent' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CouchDB-Simple-*' },
);
