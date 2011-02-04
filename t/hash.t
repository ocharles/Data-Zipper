use strictures;
use Test::More;

use Zipper::Hash;

my $input = {
    what => {
        goes => 'in'
    },
    LEAVE => [qw( ME ALONE )],
};

my $output = Zipper::Hash->new( focus => $input )
    ->traverse('what')
      ->traverse('goes')
        ->set('out')
      ->up
    ->up
    ->focus;

is_deeply($output, {
    what => {
        goes => 'out'
    },
    LEAVE => [qw( ME ALONE )],
});

is($output->{LEAVE}, $input->{LEAVE});

done_testing;
