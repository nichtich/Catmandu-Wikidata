package Catmandu::Fix::wd_simple_strings;
#ABSTRACT: Simplify labels, descriptions, and aliases of Wikidata entity records
#VERSION
use Catmandu::Sane;
use Moo;

sub fix {
    my ($self, $data) = @_;

    foreach my $what (qw(labels descriptions)) {
        my $hash = $data->{$what};
        if ($hash) {
            foreach my $lang (keys %$hash) {
                $hash->{$lang} = $hash->{$lang}->{value};
            };
        }
    }

    if (ref $data->{aliases} and ref $data->{aliases} eq 'HASH') {
        if (my $hash = $data->{aliases}) {
            foreach my $lang (keys %$hash) {
                $hash->{$lang} = [ map { $_->{value} } @{$hash->{$lang}} ];
            }
        }
    }

    $data;
}

1;

=head1 DESCRIPTION

This L<Catmandu::Fix> modifies a Wikidata entity record by simplifying the
labels, aliases, and descriptions. In particular it converts

    "en": { "language: "en", "value": "foo" }

    "en": [ { "language: "en", "value": "foo" }, 
            { "language: "en", "value": "bar" } ]

to

    "en": "foo"

    "en": ["foo","bar"]

=head1 SEE ALSO

L<Catmandu::Fix::wd_simple> applies both L<Catmandu::Fix::wd_simple_strings>
and L<Catmandu::Fix::wd_simple_claims>.

=encoding utf8
