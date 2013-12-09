package Catmandu::Fix::wdata_simplify_claims;
#ABSTRACT: Simplify the claims of a Wikidata entity
#VERSION
use Catmandu::Sane;
use Moo;

# TODO: this only covers some snak types
# See https://meta.wikimedia.org/wiki/Wikidata/Data_model#Snaks for more
sub simplify_snak {
    my ($snak) = @_;
    delete $snak->{property}; # redundant
    if ($snak->{datavalue}) { # innecessary nesting
        for (keys %{$snak->{datavalue}}) {
            $snak->{$_} = $snak->{datavalue}->{$_};
        }
        #if ($snak->{type} eq 'wikibase-entityid') {
        #    $snak->{entity} = 'P'.$snak->{value}->{'numeric-id'};
        #    delete $snak->{value};
        #}
        delete $snak->{datavalue};
    }

    # TODO add value type (such as 'URL') as soon as it is included in the JSON
    # e.g. P856 in Q52 (Wikipedia)
}

sub fix {
    my ($self, $data) = @_;

    my $claims = $data->{claims} or return $data;

    while (my ($property,$cs) = each %$claims) {
        for my $c (@$cs) {
            delete $c->{id};                        # internal
            delete $c->{type};                      # always "statement"
            simplify_snak($c->{mainsnak});
            for (keys %{$c->{mainsnak}}) {          # innecessary nesting
                $c->{$_} = $c->{mainsnak}->{$_};
            }
            delete $c->{mainsnak};
            if ($c->{references}) {
                for my $r (@{$c->{references}}) {
                    delete $r->{hash};             # internal
                    next unless $r->{snaks};
                    for my $snaks (values %{$r->{snaks}}) {
                        for my $snak (@$snaks) {
                            simplify_snak($snak);
                        }
                    }
                }
            }
        }
    }

    $data;
}

1;

=head1 DESCRIPTION

This L<Catmandu::Fix> modifies a Wikidata entity JSON record by simplifying the
C<claims> entry. The simplification is highly experimental and may change in a
future release of this module!

=encoding utf8
