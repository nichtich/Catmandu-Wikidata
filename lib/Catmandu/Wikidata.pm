use strict;
use warnings;
package Catmandu::Wikidata;
#ABSTRACT: Import from Wikidata for processing with Catmandu
#VERSION

=head1 SYNOPSIS

    catmandu convert Wikidata --items Q42,P19 to JSON --pretty
    catmandu convert Wikidata --site enwiki --title "Emma Goldman" to JSON --pretty
    catmandu convert Wkidata --title dewiki:Metadaten to JSON --pretty

    catmandu convert Wikidata --title "Emma Goldman" \
        --fix "wdata_limit_language('en')" to JSON --pretty

=head1 DESCRIPTION

Catmandu::Wikidata provides modules to process data from L<http://www.wikidata.org/> 
within the L<Catmandu> framework.

=head1 MODULES

=over

=item L<Catmandu::Importer::Wikidata>

Import entities from L<http://www.wikidata.org/>.

=item L<Catmandu::Fix::wdata_limit_language>

Provides the fix C<wdata_limit_language($language)> to limit the values of
field C<aliases>, C<labels>, and C<descriptions> to a selected language. 

=back

=head1 SEE ALSO

Background information on Catmandu can be found at <http://librecat.org/>.

Background information on Wikidata can be found at
<http://www.wikidata.org/wiki/Wikidata:Introduction>.

=encoding utf8

=cut

1;
