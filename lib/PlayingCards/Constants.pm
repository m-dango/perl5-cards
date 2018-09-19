package PlayingCards::Constants;

use strict;
use warnings;

use Readonly ();
use List::MoreUtils qw(zip);

Readonly::Array our @NUMBER_RANKS => 2..10;
Readonly::Array our @FACE_RANKS   => qw(J Q K);
Readonly::Array our @BLACK_SUITS  => qw(C S);
Readonly::Array our @RED_SUITS    => qw(D H);

Readonly::Array our @RANKS => @NUMBER_RANKS, @FACE_RANKS, 'A';
Readonly::Array our @SUITS => @BLACK_SUITS, @RED_SUITS;

Readonly::Hash  our %RANK_FULL_NAMES => zip @RANKS, @{[qw(
  two three four five six
  seven eight nine ten
  jack queen king ace
)]};
Readonly::Hash  our %SUIT_FULL_NAMES => zip @SUITS, @{[qw(clubs spades diamonds hearts)]};

1;
