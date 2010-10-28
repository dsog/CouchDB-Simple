use Test::More;
use CouchDB::Simple;

my $couch = CouchDB::Simple->new();
ok $couch, 'good job';

done_testing;
