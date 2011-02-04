package Data::Zipper;
# ABSTRACT: Easily traverse and transform immutable data

use warnings FATAL => 'all';

use Carp 'confess';
use Class::MOP;
use Scalar::Util 'blessed';
use Sub::Exporter -setup => {
    exports => [qw( zipper )]
};

sub zipper {
    my %args = @_ == 1
        ? ( focus => shift() )
            : @_;

    my $data = $args{focus};
    my $class;
    if(blessed($data)) {
        $class = 'Data::Zipper::MOP';
    }
    elsif(ref($data) eq 'HASH') {
        $class = 'Data::Zipper::Hash'
    }
    else {
        die 'Cannot zip ' . ref($data) . ' objects';
    }

    Class::MOP::load_class($class);
    return $class->new(%args);
}

1;

=head1 SYNOPSIS

    package Person;
    use Moose;

    has name => ( is => 'ro' );

    package MyApp;
    use Data::Zipper 'zipper';

    my $person = Person->new( name => 'John' )
    my $sally = zipper($person)
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

=method zip

Repeatedly moves back up the paths traversed, which has the effect of
returning back to the same structure as the original input.

=cut
