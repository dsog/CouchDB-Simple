#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CouchDB::Simple' ) || print "Bail out!
";
}

diag( "Testing CouchDB::Simple $CouchDB::Simple::VERSION, Perl $], $^X" );
