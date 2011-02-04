package Data::Zipper::API;

use warnings FATAL => 'all';
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
    return $self->meta->new_object(
        path => [ $self->path ],
        focus => $new_value
    )
}

sub set_via {
    my ($self, $code) = @_;
    local $_ = $self->focus;
    $self->set($code->($self->focus));
}

sub up {
    my $self = shift;
    my ($path, @rest) = $self->path;
    return $self->meta->new_object(
        focus => $self->reconstruct($self->focus, $path),
        path => \@rest
    );
}

sub zip {
    my $zipper = shift;

    while ($zipper->path) {
        $zipper = $zipper->up;
    }
    return $zipper->focus;
}

};

1;

=head1 SYNOPSIS

    package Person;
    use Moose;

    has name => ( is => 'ro' );

    package MyApp;
    use Data::Zipper::MOP;

    my $person = Person->new( name => 'John' )
    my $sally = Data::Zipper::MOP->new( focus => $person)
        ->traverse('name')->set('Sally')
        ->up
        ->focus;

=attr focus

Get the value of the current point in the data structure being focused on (as
navigated to by L<traverse>)

=method traverse

Traverse deeper into the data structure under focus.

=method up

Move "up" a level from the current traversal. Has the effect of unwinding
the last traversal.

=method set

Replace the value of the current node with a new value.

=method set_via

Replace the value of the current node by executing a code reference.

C<$_> will be bound to the current value of the node during execution, and
the code reference will also be passed this via the first argument.

=method zip

Repeatedly moves back up the paths traversed, which has the effect of
returning back to the same structure as the original input.

=cut
