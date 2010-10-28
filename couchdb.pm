package couchdb;

use JSON;
use LWP::UserAgent;

my $hostname = "localhost";
my $port = "5984";
my $dbname = "mypeople";

my $agent = LWP::UserAgent->new();

sub new
{
	my($class, $hostname, $port, $dbname) = @_;
	#TODO: Set the class parameters.
	my $self = {};
	bless $self, $class;
	return $self;
}

sub createDocument
{
	my ($self, $docName, $doc) = @_;

	my @arguments;
	push (@arguments, "PUT");
	push (@arguments, "http://$hostname:$port/$dbname/$docName");
	push (@arguments, []);
	push (@arguments, encode_json($doc));

	my $req = HTTP::Request->new(@arguments);
	return $agent->request($req)->content;
}

sub deleteDocument
{
	my ($self, $docName) = @_;
	my $res = decode_json($self->getDocument($docName));
	if (defined $res->{"_rev"})
	{
		my $rev = $res->{"_rev"}; 
		my @arguments;
		push (@arguments, "DELETE");
		push (@arguments,
		"http://$hostname:$port/$dbname/$docName?rev=$rev");

		my $req = HTTP::Request->new(@arguments);
		return $agent->request($req)->content;
	}
	else
	{
		return encode_json($res) . "\n";
	}
}

sub getDocument
{
	my ($self, $docName) = @_;

	my @arguments;
	push (@arguments, "GET");
	push (@arguments, "http://$hostname:$port/$dbname/$docName");

	my $req = HTTP::Request->new(@arguments);
	return $agent->request($req)->content;
}

sub updateDocument
{
	my ($self, $docName, $doc, $merge) = @_;
	$merge = 1 unless defined $merge;

	my $res = decode_json($self->getDocument($docName));
	$doc->{"_rev"} = $res->{"_rev"};
	my $newDoc = $doc;

	if($merge == 1)
	{
		$newDoc = { %$res, %$doc };
	}

	my @arguments;
	push (@arguments, "PUT");
	push (@arguments, "http://$hostname:$port/$dbname/$docName");
	push (@arguments, []);
	push (@arguments, encode_json($newDoc));

	my $req = HTTP::Request->new(@arguments);
	return $agent->request($req)->content;
}

sub getAllDocuments
{
	my ($self) = @_;

	my @arguments;
	push (@arguments, "GET");
	push (@arguments, "http://$hostname:$port/$dbname/_all_docs");

	my $req = HTTP::Request->new(@arguments);
	return $agent->request($req)->content;
}
