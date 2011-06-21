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

$l->run(undef, "$FindBin::Bin/templates/test.html.ep");

require_ok 'Lexemes::I18N::Skeleton';

is_deeply eval(
    'use Lexemes::I18N::Skeleton; \%Lexemes::I18N::Skeleton::Lexicon'),
  {'lexemes' => '', "hard\ntest" => ''},
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";
copy( "$FindBin::Bin/lib/Lexemes/I18N/es.pm.orig", "$FindBin::Bin/lib/Lexemes/I18N/es.pm" );

$l->run('es', "$FindBin::Bin/templates/test.html.ep");

require_ok 'Lexemes::I18N::es';

is_deeply eval(
    'use Lexemes::I18N::es; \%Lexemes::I18N::es::Lexicon'),
  {'lexemes' => 'lexemas', "hard\ntest" => "test\nduro"},
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/es.pm";
