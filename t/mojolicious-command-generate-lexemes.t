#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use Test::More tests => 4;

use lib "$FindBin::Bin/lib";

$ENV{MOJO_APP} = 'Lexemes';

use_ok 'Mojolicious::Command::Generate::Lexemes';

my $l = new_ok 'Mojolicious::Command::Generate::Lexemes';

$l->quiet(1);

$l->run(undef, "$FindBin::Bin/templates/test.html.ep");

require_ok 'Lexemes::I18N::Skeleton';

is_deeply \%Lexemes::I18N::Skeleton::Lexicon,
    {'lexemes' => '', "hard\ntest" => ''},
    'correct lexemes';
