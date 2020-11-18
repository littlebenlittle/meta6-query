#!env raku

use FileSystem::Helpers;
use Stache::Renderer;
use META6::Query;

my $root = META6::Query::root-dir($?FILE);
my $fixture-dir = $root.add('resources').add('fixtures');

my $LICENSE = 'test license';
my $META6 = q:to/EOO/;
{
  "meta-version": "0",
  "name": "{{ name }}",
  "version": "{{ version }}",
  "auth": "site:user",
  "description": "{{ description }}",
  "source-url": "{{ source-url }}",
  "perl": "6.d",
  "author": "Some User <some.user@someuser.tech>",
  "tags": [
    "example",
    "test",
    "meta6"
  ],
  "license": "Artistic-2.0",
  "provides": {
    {{ provides }}
  }
}
EOO
my $README = q:to/EOR/;
# {{ name }}

{{ description }}
EOR
my $MODULE = q:to/EOM/;
unit package {{ name }}:ver<{{ version }}>:auth<{{ author }}>;
sub some-sub is export { return 7 }
EOM
my $TEST = q:to/EOT/;
use v6;
use Test;
use {{ name }};
plan 1;
is some-sub, 7, 'some test';
done-testing;
EOT

temp-dir {
    for ('A', 'B', 'C') {
        my $dir = $*tmpdir.add("module$_");
        $dir.mkdir;
        my $mod-name = "Module$_";
        my %args = %(
            name => $mod-name,
            version => '0.0.0',
            description => "an example module of type $_",
            source-url  => "test.com/test-user/raku-$_",
            provides => qq:to/EOL/.trim,
            "$mod-name": "{$*SPEC.catfile: ('lib', $mod-name.split(/'::'/))}.rakumod"
            EOL
        );
        $dir.add('LICENSE'   ).spurt: Stache::Renderer::basic($LICENSE, |%args);
        $dir.add('META6.json').spurt: Stache::Renderer::basic($META6,   |%args);
        $dir.add('README.md' ).spurt: Stache::Renderer::basic($README,  |%args);
        $dir.add('lib').mkdir;
        $dir.add('t').mkdir;
        $dir.add('lib').add("$mod-name.rakumod").spurt: Stache::Renderer::basic($MODULE, |%args);
        $dir.add('t').add("t.t").spurt: Stache::Renderer::basic($TEST, |%args);
        copy-dir $*tmpdir, $fixture-dir;
    }
};

