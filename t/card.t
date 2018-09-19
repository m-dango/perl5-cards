#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use PlayingCards::Card ();

can_ok 'PlayingCards::Card', qw(new suit rank color full_name);
