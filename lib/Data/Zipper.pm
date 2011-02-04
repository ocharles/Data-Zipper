package Data::Zipper;
use strictures;
use MooseX::Role::Parameterized;
use namespace::autoclean;

parameter 'type' => (
    required => 1
);

role {

use MooseX::Types::Moose qw( ArrayRef );

my $params = shift;

requires 'traverse', 'reconstruct';

has path => (
    is => 'bare',
    isa => ArrayRef[ $params->type ],
    default => sub { [] },
    traits => [ 'Array' ],
    handles => {
        path => 'elements'
    }
);

has focus => (
    is => 'ro',
    required => 1
);

around traverse => sub {
    my ($traverser, $self, @args) = @_;
    my ($focus, $path) = $self->$traverser(@args);
    return $self->meta->new_object(
        focus => $focus,
        path => [
            $path,
            $self->path
        ]
    );
};

sub set {
    my ($self, $new_value) = @_;
    return $self->meta->clone_object(
        $self,
        focus => $new_value
    )
}

sub up {
    my $self = shift;
    my ($path, @rest) = $self->path;
    return $self->meta->new_object(
        focus => $self->reconstruct($self->focus, $path),
        path => \@rest
    );
}

};

1;
