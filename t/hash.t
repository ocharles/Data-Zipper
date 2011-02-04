use strictures;
use Test::More;

use Data::Zipper::Hash;

my $input = {
    what => {
        goes => 'in'
    },
    LEAVE => [qw( ME ALONE )],
};

my $output = Data::Zipper::Hash->new( focus => $input )
    ->traverse('what')
      ->traverse('goes')
        ->set('out')
   ->zip;

is_deeply($output, {
    what => {
        goes => 'out'
    },
    LEAVE => [qw( ME ALONE )],
});

is($output->{LEAVE}, $input->{LEAVE});

done_testing;
