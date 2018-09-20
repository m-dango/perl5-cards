#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;
use Readonly ();
use Set::CrossProduct ();

use FindBin qw($Bin);
use lib "$Bin/../lib";
use PlayingCards::Card ();
use PlayingCards::Constants;

can_ok 'PlayingCards::Card', qw(new suit rank color full_name);

subtest 'Create all cards' => sub {
  plan tests => 52;
  foreach my $args (@FULL_DECK_ARGS) {
    new_ok(
      'PlayingCards::Card' => [$args],
      join q||, @{$args}{qw(rank suit)}
    );
  }
};

subtest 'Card full names' => sub {
  plan tests => 52;
  foreach my $args (@FULL_DECK_ARGS) {
    is(
      PlayingCards::Card->new($args)->full_name,
      sprintf('%s of %s', $RANK_FULL_NAMES{$args->{rank}}, $SUIT_FULL_NAMES{$args->{suit}}),
      join q||, @{$args}{qw(rank suit)}
    );
  }
};

subtest 'Card colors' => sub {
  plan tests => 52;
  foreach my $color_and_suits (
    ['black', \@BLACK_SUITS],
    ['red', \@RED_SUITS]
  ) {
    my ($color, $suits) = @{$color_and_suits};
    foreach my $args (@{Set::CrossProduct->new({
      rank => \@RANKS,
      suit => $suits,
    })->combinations})
    {
      is(
        PlayingCards::Card->new($args)->color,
        $color,
        sprintf '%s%s is %s', @{$args}{qw(rank suit)}, $color
      );
    }
  }
}
