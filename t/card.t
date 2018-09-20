#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use Readonly ();
use Set::CrossProduct ();
use List::AllUtils qw(all pairs);

use FindBin qw($Bin);
use lib "$Bin/../lib";
use PlayingCards::Card ();
use PlayingCards::Constants;

can_ok 'PlayingCards::Card', qw(new suit rank color full_name is_face_card);

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
  foreach my $color_and_suits (pairs black => \@BLACK_SUITS, red => \@RED_SUITS) {
    foreach my $args (@{Set::CrossProduct->new({
      rank => \@RANKS,
      suit => $color_and_suits->value,
    })->combinations})
    {
      is(
        PlayingCards::Card->new($args)->color,
        $color_and_suits->key,
        sprintf '%s%s is %s', @{$args}{qw(rank suit)}, $color_and_suits->key
      );
    }
  }
};

subtest 'Face cards' => sub {
  plan tests => 52;
  foreach my $args (@{Set::CrossProduct->new({
    rank => \@FACE_RANKS,
    suit => \@SUITS,
  })->combinations})
  {
    cmp_ok(
      PlayingCards::Card->new($args)->is_face_card, q(==), 1,
      sprintf '%s%s is a face card', @{$args}{qw(rank suit)}
    );
  }

  foreach my $args (@{Set::CrossProduct->new({
    rank => [grep { my $rank = $_; all {$_ ne $rank} @FACE_RANKS; } @RANKS],
    suit => \@SUITS,
  })->combinations})
  {
    cmp_ok(
      PlayingCards::Card->new($args)->is_face_card, q(==), 0,
      sprintf '%s%s is not a face card', @{$args}{qw(rank suit)}
    );
  }
};
