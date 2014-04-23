package Catmandu::Fix::wd_simple;
#ABSTRACT: Simplify Wikidata entity records
#VERSION
use Catmandu::Sane;
use Moo;

use Catmandu::Fix::wd_simple_strings;
use Catmandu::Fix::wd_simple_claims;

sub fix {
    my ($self, $data) = @_;

    Catmandu::Fix::wd_simple_strings::fix($self,$data);
    Catmandu::Fix::wd_simple_claims::fix($self,$data);

    if (my $hash = $data->{sitelinks}) {
        foreach my $lang (keys %$hash) {
            delete $hash->{$lang}->{site};
        }
    }

    $data;
}

1;

=head1 DESCRIPTION

This L<Catmandu::Fix> simplifies a Wikidata entity record by applying both
L<Catmandu::Fix::wd_simple_strings> and L<Catmandu::Fix::wd_simple_claims>. It
further simplifies sitelinks by removing redundant fields.

=encoding utf8
