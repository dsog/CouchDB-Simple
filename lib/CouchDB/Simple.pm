package CouchDB::Simple;

use warnings;
use strict;
use JSON qw(from_json to_json);
use LWP::UserAgent;

our $VERSION = 0.0001;

sub new {
    my($class, %args) = @_;
    my $host  = $args{host}  || 'localhost';
    my $port  = $args{port}  || 5984;
    my $db    = $args{db}    || 'sampledb';
    my $agent = $args{agent} || LWP::UserAgent->new();
    my $self = {
        agent    => $agent,
        base_uri => "http://$host:$port/$db",
    };
    bless $self, $class;
    return $self;
}

sub create_document {
    my ($self, $id, $doc) = @_;
    my $json = to_json($doc);
    my $req = HTTP::Request->new(PUT => "$self->{base_uri}/$id", [], $json);
    return $self->{agent}->request($req)->content;
}

sub delete_document {
    my ($self, $id) = @_;
    my $json = $self->get_document($id);
    my $data = from_json($json);

    return $json if $data->{error};

    my $uri = "$self->{base_uri}/$id?rev=$data->{_rev}";
    my $req = HTTP::Request->new(DELETE => $uri);
    return $self->{agent}->request($req)->content;
}

sub get_document {
    my ($self, $id) = @_;
    my $req = HTTP::Request->new(GET => "$self->{base_uri}/$id");
    return $self->{agent}->request($req)->content;
}

sub update_document {
    my ($self, $id, $doc, $merge) = @_;
    $merge = 1 unless defined $merge;

    my $data = from_json($self->get_document($id));
    $doc->{_rev} = $data->{_rev};
    $doc = { %$data, %$doc } if $merge;

    my $req = HTTP::Request->new(PUT => "$self->{base_uri}/$id",
        [], to_json($doc));
    return $self->{agent}->request($req)->content;
}

sub get_all_documents {
    my ($self) = @_;
    my $req = HTTP::Request->new(GET => "$self->{base_uri}/_all_docs");
    return $self->{agent}->request($req)->content;
}

=head1 NAME

CouchDB::Simple - A simple interface to CouchDB

=head1 VERSION

Version 0.0001

=head1 SYNOPSIS

This class implements the functionality needed to interact with CouchDB.

Example usage:

    use CouchDB::Simple
    my $couch = CouchDB::Simple->new(
        db   => 'some_db',
        host => 'localhost', # defaults to 'localhost'
        port => 5984, # defaults to 5984
    );

=head1 METHODS

=head2 create_document($id, \%document)

Add a new document with the given id.

=head1 AUTHORS

=over

=item *

Khaled Hussein <khaled.hussein@gmail.com>

=item *

Naveed Massjouni <naveed.massjouni@rackspace.com>

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CouchDB::Simple

