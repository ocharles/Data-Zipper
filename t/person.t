use strictures;
use Test::More;

use Zipper::MOP;

{
    package Person;
    use Moose;

    has name => ( is => 'ro' );
}

{
    package Container;
    use Moose;

    has person => ( is => 'ro' );
}

my $john = Person->new( name => 'John' );
my $sally = Zipper::MOP->new( focus => $john )
    ->traverse('name')
      ->set('Sally')
    ->up
    ->focus;

isa_ok($sally => 'Person');
is($sally->name => 'Sally');

my $container = Container->new( person => Person->new( name => 'Ollie' ));
my $new_container = Zipper::MOP->new( focus => $container )
    ->traverse('person')
      ->traverse('name')
        ->set('STEEEEVE')
      ->up
    ->up
    ->focus;

isa_ok($new_container, 'Container');
isa_ok($new_container->person, 'Person');
is($new_container->person->name, 'STEEEEVE');

done_testing;
