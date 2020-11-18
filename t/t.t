use v6;

use Test;

use META6::Query;

# class Unit {
# 	has $.name;
# }
# 
# my @units = [
#     Unit.new(name => 'not implemented'),
# ];
# 
# plan @units.elems;
# 
# ok False, .name for @units;

my $root = META6::Query::root-dir($?FILE);
is $root.absolute, $?FILE.IO.dirname.IO.dirname.IO.absolute, 'root-dir';

my $fixture-dir = $root.add('resources').add('fixtures');
for $fixture-dir.dir {
    is META6::Query::root-dir($_.add: 'lib'), $_, $_.IO.basename;
}

done-testing;

