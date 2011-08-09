#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use File::Copy;

use Test::More tests => 6;

use lib "$FindBin::Bin/lib";

$ENV{MOJO_APP} = 'Lexemes';

use_ok 'Mojolicious::Command::Generate::Lexicon';

my $l = new_ok 'Mojolicious::Command::Generate::Lexicon';

$l->quiet(1);

$l->run(undef, "$FindBin::Bin/templates/test-quote.html.ep");

require_ok 'Lexemes::I18N::Skeleton';

is_deeply eval ( 
    'use Lexemes::I18N::Skeleton; \%Lexemes::I18N::Skeleton::Lexicon'),
  {'Can\'t fix' => ''},
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";

# Save option test
copy( "$FindBin::Bin/lib/Lexemes/I18N/es.pm.quote", "$FindBin::Bin/lib/Lexemes/I18N/es.pm" );

$l->run('es', "$FindBin::Bin/templates/test-quote.html.ep", '--save');

require_ok( "$FindBin::Bin/lib/Lexemes/I18N/es.pm" );

is_deeply eval { 
        my $l = \%{Lexemes::I18N::es::Lexicon}; 
        \%{Lexemes::I18N::es::Lexicon}; # Mencioned again for avoid warn
  },
  {'lexemes' => 'lexemas', "hard\ntest" => "prueba\ndifícil", 'Can\'t fix' => 'No puede arreglarse' },
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/es.pm";
