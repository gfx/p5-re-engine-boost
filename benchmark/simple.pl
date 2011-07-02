#!perl
use 5.12.0;
use strict;
use warnings;
use Benchmark qw(:all);

my $s = `perldoc -m perlreapi`;

foreach my $p(qw(NAME  FETCH|STORE perl.*guts)) {
    say "for /$p/";
    cmpthese -1, {
        builtin => sub {
            my $r = qr/$p/;
            $s =~ /$p/ or die $_ for 1 .. 100;
        },
        RE2 => sub {
            use re::engine::RE2;
            my $r = qr/$p/;
            $s =~ $r or die $_ for 1 .. 100;
        },
        boost => sub {
            use re::engine::boost;
            my $r = qr/$p/;
            $s =~ $r or die $_ for 1 .. 100;
        },
    };
}


