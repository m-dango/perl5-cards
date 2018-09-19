package PlayingCards::Card;

use Moose;
use Moose::Util::TypeConstraints;
use Readonly ();
use List::MoreUtils qw(any zip);
use PlayingCards::Constants;
use Carp qw(croak);

subtype 'CardSuit'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } @PlayingCards::Constants::SUITS; }
  => message { "'$_' is not a valid suit" };

subtype 'CardRank'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } @PlayingCards::Constants::RANKS; }
  => message { "'$_' is not a valid rank" };

has 'suit' => ( is => 'ro', isa => 'CardSuit', required => 1 );
has 'rank' => ( is => 'ro', isa => 'CardRank', required => 1 );

sub color {
  my ($self) = @_;
  return 'red'   if any { $self->suit eq $_ } @PlayingCards::Constants::RED_SUITS;
  return 'black' if any { $self->suit eq $_ } @PlayingCards::Constants::BLACK_SUITS;
  croak 'could not match ' . $self->suit . ' to a color';
}

sub full_name {
  my ($self) = @_;
  return $PlayingCards::Constants::RANK_FULL_NAMES{$self->rank};
}

no Moose;
no Moose::Util::TypeConstraints;
__PACKAGE__->meta->make_immutable;
