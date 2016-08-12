#!/usr/bin/env perl

use strict;
use warnings;
no warnings 'once';

use FindBin;
use File::Copy;

use Test::More tests => 6;

use lib "$FindBin::Bin/lib";

use_ok 'Mojolicious::Command::generate::lexicon';

my $l = new_ok 'Mojolicious::Command::generate::lexicon';

$l->app(sub { Mojo::Server->new->build_app('Lexemes') });

$l->run(undef, "$FindBin::Bin/templates/test-quote.html.ep");

require_ok "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";

is_deeply \%Lexemes::I18N::Skeleton::Lexicon, {'Can\'t fix' => ''},
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";

# Save option test
copy(
    "$FindBin::Bin/lib/Lexemes/I18N/es.pm.quote",
    "$FindBin::Bin/lib/Lexemes/I18N/es.pm"
);

$l->run('es', "$FindBin::Bin/templates/test-quote.html.ep", '-b=save');

require_ok "$FindBin::Bin/lib/Lexemes/I18N/es.pm";

is_deeply \%Lexemes::I18N::es::Lexicon,
  { 'lexemes'    => 'lexemas',
    "hard\ntest" => "prueba\ndifícil",
    'Can\'t fix' => 'No puede arreglarse'
  },
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/es.pm";
