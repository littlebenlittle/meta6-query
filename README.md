
# META6::Query

Useful subs for interacting with META6-compliant directory structures.

To get the root directory relative to the current file, you would use

```raku
use META6::Query;

my $root-dir = META6::Query::root-dir $?FILE;
```


