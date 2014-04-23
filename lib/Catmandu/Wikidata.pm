use strict;
use warnings;
package Catmandu::Wikidata;
#ABSTRACT: Import from Wikidata for processing with Catmandu
#VERSION

=head1 SYNOPSIS

    catmandu convert Wikidata --items Q42,P19 to JSON --pretty 1
    catmandu convert Wikidata --site enwiki --title "Emma Goldman" to JSON --pretty 1
    catmandu convert Wkidata --title dewiki:Metadaten to JSON --pretty 1

    catmandu convert Wikidata --title "Emma Goldman" \
        --fix "wd_language('en')" to JSON --pretty 1

=head1 DESCRIPTION

B<Catmandu::Wikidata> provides modules to process data from
L<http://www.wikidata.org/> within the L<Catmandu> framework. In particular it
facilitates access to Wikidata entity record via
L<Catmandu::Importer::Wikidata>, the simplification of these records via fixes
(C<wd_language($language)>, C<wd_simple()>, C<wd_simple_strings()>, and
C<wd_simple_claims()>). Other Catmandu modules can be used to further process
the records, for instance to load them into a database.

=head1 MODULES

=over

=item L<Catmandu::Importer::Wikidata>

Imports entities from L<http://www.wikidata.org/>.

=item L<Catmandu::Fix::wd_language>

Limit string values in a Wikidata entity record to a selected language.

=item L<Catmandu::Fix::wd_simple_strings>

Simplifies labels, descriptions, and aliases of Wikidata entity record.

=item L<Catmandu::Fix::wd_simple_claims>

Simplifies claims of a Wikidata entity record.

=item L<Catmandu::Fix::wd_simple>

Applies L<Catmandu::Fix::wd_simple_strings> and
L<Catmandu::Fix::wd_simple_claims>. Further simplifies sitelinks.

=back

=head1 SEE ALSO

Background information on Catmandu can be found at L<http://librecat.org/>.

Background information on Wikidata can be found at
L<http://www.wikidata.org/wiki/Wikidata:Introduction>.

=encoding utf8

=cut

1;
