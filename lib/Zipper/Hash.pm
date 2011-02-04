package Zipper::Hash;
use strictures;
use Moose;
use namespace::autoclean;

use MooseX::Types::Moose qw( Str HashRef );
use MooseX::Types::Structured qw( Tuple );

with 'Zipper' => { type => Tuple[ Str, HashRef ] };

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
