package Data::Zipper::Hash;
# ABSTRACT: A zipper for hash references

use warnings FATAL => 'all';
use Moose;
use namespace::autoclean;

use MooseX::Types::Moose qw( Str HashRef );
use MooseX::Types::Structured qw( Tuple );

with 'Data::Zipper' => { type => Tuple[ Str, HashRef ] };

sub traverse {
    my ($self, $path) = @_;
    return (
        $self->focus->{$path},
        [ $path, $self->focus ],
    );
}

sub reconstruct {
    my ($self, $value, $path) = @_;
    my ($key, $object) = @$path;
    return {
        %{ $object },
        $key => $value
    };
}

__PACKAGE__->meta->make_immutable;
1;

=method traverse

Traverse into the currently focused hash reference by moving into
the value of L<$key>.

=method reconstruct

(internal)

=cut
