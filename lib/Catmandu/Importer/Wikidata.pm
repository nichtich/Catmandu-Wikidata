package Catmandu::Importer::Wikidata;

use Catmandu::Sane;
use Moo;
use JSON;
use Furl;
use URI::Escape;
use experimental 'lexical_topic';

with 'Catmandu::Importer';

has api => ( 
    is => 'ro', 
    default => sub { 'http://www.wikidata.org/w/api.php' } 
);

has ids => (
    is  => 'ro',
    coerce => sub { [ split /[,| ]/, $_[0] ] }
);

has site => (
    is => 'ro',
    default => sub { 'enwiki' }
);

has title => (
    is => 'ro',
);

sub _request {
    my ($self) = @_;

    my $url = $self->api . '?action=wbgetentities&format=json&';

    if ($self->ids) {
        my @ids = map {
            $_ =~ /^[QP][0-9]+$/i or die "invalid wikidata id $_\n";
            uc($_);
        } @{$self->ids};
        $url .= 'ids=' . join '|', @ids;
    } elsif($self->title) {
        my ($site, $title);
        if ($self->title =~ /^([a-z]+):(.+)$/) {
           ($site, $title) = ($1,$2);
        } else {
           ($site, $title) = ($self->site,$self->title);
           die "invalid site $site" if $site !~ /^[a-z]+$/;
        }
        $url .= "sites=$site&titles=".uri_escape($title);
        # TODO: pass multiple sites|titles
    } else {
        die "missing ids or title";
    }
    print ">$url\n";

    my $res = Furl->new(
        agent => 'Mozilla/5.0',
        timeout => 10
    )->get($url);

    die $res->status_line unless $res->is_success;

    my $json = eval { JSON->new->decode($res->content); };
    die $@ if $@;

    unless ($json->{success} && $json->{entities}) {
        # TODO: better error handling
        #use Data::Dumper;
        #die Dumper($json)
        die "query failed";
    }

    return $json->{entities};
}

sub generator {
    my ($self) = @_;
    sub {
        state $entities = $self->_request;
        my ($id, $item) = each %$entities;
        return $item;
    }
}

1;

=encoding utf8
