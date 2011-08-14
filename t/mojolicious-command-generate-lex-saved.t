#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use File::Copy;

use Test::More tests => 4;

use lib "$FindBin::Bin/lib";

$ENV{MOJO_APP} = 'Lexemes';

use_ok 'Mojolicious::Command::Generate::Lexicon';

my $l = new_ok 'Mojolicious::Command::Generate::Lexicon';

$l->quiet(1);

copy( "$FindBin::Bin/lib/Lexemes/I18N/es.pm.orig", "$FindBin::Bin/lib/Lexemes/I18N/es.pm" );

$l->run('es', "$FindBin::Bin/templates/test.html.ep", '-b=save');

require_ok( "$FindBin::Bin/lib/Lexemes/I18N/es.pm" );

is_deeply eval { 
        my $l = \%{Lexemes::I18N::es::Lexicon}; 
        \%{Lexemes::I18N::es::Lexicon}; # Mencioned again for avoid warn
  },
  {'lexemes' => 'lexemas', "hard\ntest" => "prueba\ndifícil", link_to => ''},
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/es.pm";
