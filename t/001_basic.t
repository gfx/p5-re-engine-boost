#!perl -w
use strict;
use Test::More;

use re::engine::boost;

is ref(qr/foo/), 're::engine::boost';

like   "foo", qr/foo/;
unlike "foo", qr/bar/;

like   "foo", qr/foo|bar/;
like   "bar", qr/foo|bar/;
unlike "baz", qr/foo|bar/;

like "foo", qr/./, '/./';
like "foo", qr/[a-z]/, '/[a-z]/';

my $s = <<'T';
Hello, world!
for bar baz
The quick brown fox jumps over the lazy dog.
T
my $r = qr/foo|bar/;

ok $s =~ /$r/;
ok $s =~ /$r/;

done_testing;
