package Mojo::Promise::Role::Any;
use Mojo::Base '-role';

use strict;
use v5.26;

use warnings;
no warnings;

use subs qw();
use vars qw($VERSION);

$VERSION = '0.001_01';

=encoding utf8

=head1 NAME

Mojo::Promise::Role::Any - Fulfill with the first fulfilled promise

=head1 SYNOPSIS

	use Mojo::Promise;

	my $any_promise = Mojo::Promise
		->with_roles( '+Any' )
		->any( @promises );



=head1 DESCRIPTION

Make a new promise that fulfills with the first fulfilled promise, and
rejects otherwise. This is handy, for instance, for asking for several
servers to provide the same resource and taking the first one that
responds.

=over 4

=item any

Takes a lists of promises (or thenables) and returns another promise
that fulfills. If any of the promises fulfills,

=cut

sub any {
	my( $self, @promises ) = @_;
	my( $resolved, $results ) = ( 0, [] );
	my $any = $self->new;

	foreach my $i ( 0 .. $#promises ) {
		my $seq = $i;
		$promises[$seq]->then(
			sub {
				say "Resolving $seq";
				$results->[ $resolved = $seq ] = [ @_ ];
				$any->resolve( $results->@* );
				}
			);
		}

	return @promises ? $any : $any->reject;
	}

=back

=head1 SEE ALSO

L<Mojolicious>, L<Mojo::Promise>, L<Role::Tiny>

=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/mojo-promise-role-any/

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2018, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;
