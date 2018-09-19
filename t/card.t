#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;
use Readonly ();
use Set::CrossProduct ();

use FindBin qw($Bin);
use lib "$Bin/../lib";
use PlayingCards::Card ();

Readonly::Array my @NUMBER_RANKS => 2..10;
Readonly::Array my @FACE_RANKS   => qw(J Q K);
Readonly::Array my @BLACK_SUITS  => qw(C S);
Readonly::Array my @RED_SUITS    => qw(D H);

Readonly::Array my @RANKS => @NUMBER_RANKS, @FACE_RANKS, 'A';
Readonly::Array my @SUITS => @BLACK_SUITS, @RED_SUITS;

can_ok 'PlayingCards::Card', qw(new suit rank color full_name);

subtest 'Create all cards' => sub {
  plan tests => 52;
  foreach my $params (@{Set::CrossProduct->new({
    rank => \@RANKS,
    suit => \@SUITS,
  })->combinations})
  {
    new_ok(
      'PlayingCards::Card' => [$params],
      join q||, @{$params}{qw(rank suit)}
    );
  }
};

foreach my $color_and_suits (['black', \@BLACK_SUITS], ['red', \@RED_SUITS]) {
  my ($color, $suits) = @{$color_and_suits};
  subtest "$color cards" => sub {
    plan tests => 26;
    foreach my $params (@{Set::CrossProduct->new({
      rank => \@RANKS,
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
