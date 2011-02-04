package Zipper::MOP;
use strictures;
use Moose;
use namespace::autoclean;

use MooseX::Types::Moose qw( Object Str ArrayRef );
use MooseX::Types::Structured qw( Tuple );

with 'Zipper';

has '+path' => (
    isa => ArrayRef[ Tuple[ Str, Object ]]
);

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
