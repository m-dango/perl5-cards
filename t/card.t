#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;
use Readonly ();
use Set::CrossProduct ();

use FindBin qw($Bin);
use lib "$Bin/../lib";
use PlayingCards::Card ();
use PlayingCards::Constants ();

can_ok 'PlayingCards::Card', qw(new suit rank color full_name);

subtest 'Create all cards' => sub {
  plan tests => 52;
  foreach my $params (@{Set::CrossProduct->new({
    rank => \@PlayingCards::Constants::RANKS,
    suit => \@PlayingCards::Constants::SUITS,
  })->combinations})
  {
    new_ok(
      'PlayingCards::Card' => [$params],
      join q||, @{$params}{qw(rank suit)}
    );
  }
};

foreach my $color_and_suits (
  ['black', \@PlayingCards::Constants::BLACK_SUITS],
  ['red', \@PlayingCards::Constants::RED_SUITS]
) {
  my ($color, $suits) = @{$color_and_suits};
  subtest "$color cards" => sub {
    plan tests => 26;
    foreach my $params (@{Set::CrossProduct->new({
      rank => \@PlayingCards::Constants::RANKS,
      suit => $suits,
    })->combinations})
    {
      is(
        PlayingCards::Card->new($params)->color,
        $color,
        sprintf '%s%s is %s', @{$params}{qw(rank suit)}, $color
      );
    }
  }
}
