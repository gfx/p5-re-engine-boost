package re::engine::boost;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

sub import
{
    $^H{regcomp} = ENGINE();
}

sub unimport
{
    delete $^H{regcomp}
        if $^H{regcomp} == ENGINE();
}

1;
__END__

=head1 NAME

re::engine::boost - Perl extention to do something

=head1 VERSION

This document describes re::engine::boost version 0.01.

=head1 SYNOPSIS

    use re::engine::boost;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Fuji, Goro (gfx) E<lt>gfuji@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, Fuji, Goro (gfx). All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
