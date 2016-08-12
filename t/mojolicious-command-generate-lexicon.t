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

$l->run(undef, "$FindBin::Bin/templates/test.html.ep");

require_ok "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";

is_deeply \%Lexemes::I18N::Skeleton::Lexicon, {
    'lexemes'             => '',
    "hard\ntest"          => '',
    link_to               => '',
    'variables test [_1]' => ''
  },
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/Skeleton.pm";


copy(
    "$FindBin::Bin/lib/Lexemes/I18N/es.pm.orig",
    "$FindBin::Bin/lib/Lexemes/I18N/es.pm"
);

$l->run('es', "$FindBin::Bin/templates/test.html.ep", '-b=reset');

require_ok "$FindBin::Bin/lib/Lexemes/I18N/es.pm";

is_deeply \%Lexemes::I18N::es::Lexicon, {
    'lexemes'             => '',
    "hard\ntest"          => '',
    link_to               => '',
    'variables test [_1]' => ''
  },
  'correct lexemes';

unlink "$FindBin::Bin/lib/Lexemes/I18N/es.pm";
