package Data::Zipper::MOP;
# ABSTRACT: A zipper for MOP based objects

use warnings FATAL => 'all';
use Moose;
use namespace::autoclean;

use MooseX::Types::Moose qw( Object Str ArrayRef );
use MooseX::Types::Structured qw( Tuple );

with 'Data::Zipper::API' => { type => Tuple[ Str, Object ] };

sub traverse {
    my ($self, $path) = @_;
    return (
        $self->focus->$path,
        [ $path, $self->focus ],
    );
}

sub reconstruct {
    my ($self, $value, $path) = @_;
    my ($key, $object) = @$path;
    $object->meta->clone_object(
        $object,
        $key => $value
    );
}

__PACKAGE__->meta->make_immutable;
1;

=method traverse

Traverse into the object under focus, by moving into the value of an attribute
with a given name. Currently assumes the reader is the same as the name.

=method reconstruct

(internal)

=cut
