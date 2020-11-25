use v6;

use Test;

use META6::Query;

my $root = META6::Query::root-dir($?FILE);
is $root.absolute, $?FILE.IO.dirname.IO.dirname.IO.absolute, 'root-dir';

my $fixture-dir = $root.add('resources').add('fixtures');
for $fixture-dir.dir {
    is META6::Query::root-dir($_.add: 'lib'), $_, $_.IO.basename;
}

done-testing;

