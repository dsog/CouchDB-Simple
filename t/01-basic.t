use Test::More tests => 4;
use Test::Mock::LWP::Dispatch;

use HTTP::Request;
use HTTP::Response;
use JSON qw(from_json to_json);

use CouchDB::Simple;

my $host = 'foo.com';
my $port = 5984;
my $db = 'sampledb';
my $doc_id = 'foo_id';
my $rev = 3;
my $test_json = to_json({ foo => 'bar', _rev => $rev });
#my $base_uri = "http://$host:$port/$db";
my $base_uri = "http://$host:$port";

my $mock_agent = LWP::UserAgent->new();
my $couch = CouchDB::Simple->new(
    host => $host,
    port => $port,
    #db => $db,
    agent => $mock_agent,
);

$mock_agent->map(
    HTTP::Request->new(PUT => "$base_uri/$db/$doc_id", [], $test_json),
    HTTP::Response->new(200, '', [], $test_json)
);

is $couch->create_document($db, $doc_id, from_json($test_json)) => $test_json,
    'create_document works';

$mock_agent->map(
    HTTP::Request->new(GET => "$base_uri/$db/$doc_id"),
    HTTP::Response->new(200, '', [], $test_json)
);

is $couch->get_document($db, $doc_id) => $test_json, 'get_document works';

$mock_agent->map(
    HTTP::Request->new(DELETE => "$base_uri/$db/$doc_id?rev=$rev"),
    HTTP::Response->new(200, '', [], $test_json)
);

is $couch->delete_document($db, $doc_id) => $test_json, 'delete_document works';

$mock_agent->map(
    HTTP::Request->new(PUT => "$base_uri/$db/$doc_id", [], $test_json),
    HTTP::Response->new(200, '', [], $test_json)
);

is $couch->update_document($db, $doc_id, from_json($test_json)) => $test_json,
    'update_document works';

