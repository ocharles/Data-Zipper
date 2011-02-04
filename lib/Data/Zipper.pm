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

=func zipper

Create a zipper of the correct type, depending on the data given

=cut
