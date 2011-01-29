package Mojolicious::Command::Generate::Lexemes;
use Mojo::Base 'Mojo::Command';

use MojoX::I18N::Lexemes;
use Carp 'croak';

has description => <<'EOF';
Generate lexemes file from templates.
EOF
has usage => <<"EOF";
usage: $0 generate lexemes <language> <templates>
EOF

sub run {
    my ($self, $language, @templates) = @_;

    unless ($language && @templates) {
        print $self->usage;
        return;
    }

    my $s   = Mojo::Server->new;
    my $app = $s->app;

    my $app_class = $s->app_class;
    $app_class =~ s!::!/!g;

    my $lexem_file = $app->home->rel_file("lib/$app_class/I18N/$language.pm");

    if (-e $lexem_file) {
        print "Lexem file \"$lexem_file\" already exists\n";
        return;
    }

    my $l = MojoX::I18N::Lexemes->new(renderer => $self->renderer);

    my %lexemes = ();

    foreach my $file (@templates) {
        open F, $file or die "Unable to open $file: $!";
        my $t = do { local $/; <F> };
        close F;

        # get lexemes
        my $parsed_lexemes = $l->parse($t);

        # add to all lexemes
        $lexemes{$_} = '' foreach (@$parsed_lexemes);
    }

    # Output lexem
    $self->render_to_file('package', $lexem_file, $app_class, $language,
        \%lexemes);
}

1;

__DATA__
@@ package
% my ($app_class, $language, $lexicon) = @_;
package <%= $app_class %>::I18N::<%= $language %>;
use Mojo::Base '<%= $app_class %>::I18N';

# Uncoment to use non-latin symbols
# use utf8;

our %Lexicon = (
% foreach my $lexem (keys %$lexicon) {
    % $lexem=~s/'/\\'/g;
    % unless ($lexem=~s/\n/\\n/g) {
    '<%= $lexem %>' => '',
    % } else {
    "<%= $lexem %>" => '',
    % };
% }
);

1;

__END__

=head1 NAME

MojoliciousX::Command::Generate::Lexemes - Generate Lexemes Command

=head1 SYNOPSIS

    use Mojolicious::Command::Generate::Lexemes;

    my $l = Mojolicious::Command::Generate::Lexemes->new;
    $inflate->run(@files);

=head1 SEE ALSO

L<MojoX::I18N::Lexemes>

=head1 COPYRIGHT

Copyright (C) 2011, Sergey Zasenko

This program is free software, you can redistribute it and/or modify it
under the terms of the Artistic License version 2.0.

=cut

1;
