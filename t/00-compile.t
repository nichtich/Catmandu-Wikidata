use strict;
use warnings;
use Test::More;

use_ok 'Catmandu::Importer::Wikidata';
use_ok 'Catmandu::Fix::wdata_retain_language';
use_ok 'Catmandu::Fix::wdata_simplify_claims';
use_ok 'Catmandu::Wikidata';

done_testing;
