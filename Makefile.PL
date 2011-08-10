#!/usr/bin/env perl

use 5.008007;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'mojolicious-lexicon',
    VERSION_FROM => 'lib/Mojolicious/Command/Generate/Lexicon.pm',
    AUTHOR       => 'Sergey Zasenko <undef@cpan.org>',
    PREREQ_PM    => {
        'File::Find'   => 0,
        'Getopt::Long' => 0,
        'Mojolicious'  => '1.0',
    },
    test => {TESTS => 't/*.t t/*/*.t t/*/*/*.t'}
);
