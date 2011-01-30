package MojoX::I18N::Lexemes;

use strict;
use warnings;

use base 'Mojo::Base';

use Mojo::Template;
use Mojo::Server;

our $VERSION = 0.91;

__PACKAGE__->attr(renderer => sub { Mojo::Template->new });

sub parse {
    my ($self, $template) = @_;

    my $mt = $self->renderer;
    $mt->parse($template);

    my $lexemes = [];

    my $multiline = 0;
    my $args      = '';
    foreach my $line (@{$mt->tree}) {
        for (my $j = 0; $j < @{$line}; $j += 2) {
            my $type  = $line->[$j];
            my $value = $line->[$j + 1];

            if ($multiline) {
                if ($type eq 'expr' || $type eq 'escp') {
                    $args .= $value;
                }
                else {
                    $multiline = 0;
                }
            }
            elsif (($type eq 'expr' or $type eq 'escp')
                && $value
                && substr($value, 0, 2) eq 'l ')
            {
                $args = substr $value, 2;

                unless (($line->[$j + 2] || '') eq 'text') {

                    $multiline = 1;
                }

            }

            if ($args && !$multiline) {
                my $lexem = eval $args;
                push @$lexemes, $lexem;

                $args = '';
            }

        }
    }
    return $lexemes;
}

=head1 NAME

TODO

=head1 SYNOPSIS

TODO

=head1 DESCRIPTION

TOOD

=head1 COPYRIGHT

Copyright (C) 2011, Sergey Zasenko

This program is free software, you can redistribute it and/or modify it
under the terms of the Artistic License version 2.0.

=cut

1;
