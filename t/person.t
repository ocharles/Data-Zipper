use strictures;
use Test::More;

use Zipper::MOP;

{
    package Person;
    use Moose;

    has name => ( is => 'ro' );
}

my $john = Person->new( name => 'John' );
my $sally = Zipper::MOP->new( focus => $john )
    ->traverse('name')
      ->set('Sally')
    ->up
    ->focus;

isa_ok($sally => 'Person');
is($sally->name => 'Sally');

done_testing;
