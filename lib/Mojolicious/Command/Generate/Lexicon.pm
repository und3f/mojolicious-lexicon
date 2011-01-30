package Mojolicious::Command::Generate::Lexicon;
use base 'Mojo::Command';

use MojoX::I18N::Lexemes;
use File::Find;

__PACKAGE__->attr(description => <<'EOF');
Generate lexicon file from templates.
EOF
__PACKAGE__->attr(usage => <<"EOF");
usage: $0 generate lexicon [language] [templates]
EOF

our $VERSION = 0.991;

sub run {
    my ($self, $language, @templates) = @_;

    my $s   = Mojo::Server->new;
    my $app = $s->app;

    my $app_class = $s->app_class;
    $app_class =~ s!::!/!g;

    $language ||= 'Skeleton';

    my $handler = $app->renderer->default_handler;
    unless (@templates) {
        # Find all templates of project
        find(sub {
            push @templates, $File::Find::name if (/\.$handler/);
        }, $app->renderer->root);
    }


    my $lexem_file = $app->home->rel_file("lib/$app_class/I18N/$language.pm");

    if ($language ne 'Skeleton' && -e $lexem_file) {
        print "Lexem file \"$lexem_file\" already exists\n";
        return;
    }

    my $l = MojoX::I18N::Lexemes->new(renderer => $self->renderer);

    my %lexicon = ();

    foreach my $file (@templates) {
        open F, $file or die "Unable to open $file: $!";
        my $t = do { local $/; <F> };
        close F;

        # get lexemes
        my $parsed_lexemes = $l->parse($t);

        # add to all lexemes
        $lexicon{$_} = '' foreach (@$parsed_lexemes);
    }

    # Output lexem
    $self->render_to_file('package', $lexem_file, $app_class, $language,
        \%lexicon);
}

1;

__DATA__
@@ package
% my ($app_class, $language, $lexicon) = @_;
package <%= $app_class %>::I18N::<%= $language %>;
use base '<%= $app_class %>::I18N';

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

Mojolicious::Command::Generate::Lexicon - Generate Lexicon Command

=head1 SYNOPSIS

    $ ./script/my_mojolicious_app generate lexicon

Or as perl module

    use Mojolicious::Command::Generate::Lexicon;

    my $l = Mojolicious::Command::Generate::Lexicon->new;
    $inflate->run($language, @files);


=head1 SEE ALSO

L<MojoX::I18N::Lexemes>

=head1 SUPPORT

=head2 IRC

    #ru.pm on irc.perl.org
    
=head1 DEVELOPMENT

=head2 Repository

    http://github.com/und3f/mojolicious-lexicon

=head1 AUTHOR

Sergey Zasenko, C<undef@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2011, Sergey Zasenko

This program is free software, you can redistribute it and/or modify it
under the terms of the Artistic License version 2.0.

=cut
