#!perl -w
use strict;
use Test::Requires { 'Test::LeakTrace' => 0.13 };
use Test::More;

use re::engine::boost;

no_leaks_ok {
    # use re::engine::boost here
};

done_testing;
