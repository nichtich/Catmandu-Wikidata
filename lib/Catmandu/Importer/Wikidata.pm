package Catmandu::Importer::Wikidata;
#ABSTRACT: Import from Wikidata
#VERSION
use Catmandu::Sane;
use Moo;
use JSON;
use Furl;
use URI::Escape;

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
    } elsif(defined $self->title) {
        my ($site, $title);
        if ($self->title =~ /^([a-z]+([_-][a-z])*):(.+)$/) {
            ($site, $title) = ($1,$3);
        } else {
            ($site, $title) = ($self->site,$self->title);
        }
        die "invalid site $site" if $site !~ /^[a-z]+([_-][a-z])*$/;
        $site =~ s/-/_/g;
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

=head1 DESCRIPTION

This L<Catmandu::Importer> queries Wikidata for entities, given by their
Wikidata identifier (C<Q...>, C<P...>) or by a title in some know Wikidata
site, such as the English Wikipedia (C<enwiki>).

See L<Catmandu::Wikidata> for a synopsis.

By default, the raw JSON structure of each Wikidata entity is returned one by
one. Future versions of this module may further expand the entity data to make
more easily use of it.

=head1 CONFIGURATION

=over

=item api

Wikidata API base URL. Default is C<http://www.wikidata.org/w/api.php>.

=item ids

A list of Wikidata entitiy/property ids, such as C<Q42> and C<P19>. Use
comma, vertical bar, or space as separator.

=item site

Wiki site key for referring to Wikidata entities by title. Default is
C<enwiki> for English Wikipedia. A list of supported site keys can be
queried as part of
L<https://www.wikidata.org/w/api.php?action=paraminfo&modules=wbgetentities>
(unless L<https://bugzilla.wikimedia.org/show_bug.cgi?id=58200> is fixed).

=item title

Title of a page for referring to Wikidata entities. A title is only unique
within a selected C<site>. One can also prepend the site key to a title
separated by colon, e.g. C<enwiki:anarchy> for the entity that is titled
"anarchy" in the English Wikipedia.

=back

=encoding utf8
