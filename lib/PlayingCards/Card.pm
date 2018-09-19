package PlayingCards::Card;

use Moose;
use Moose::Util::TypeConstraints;
use Readonly ();
use List::MoreUtils qw(any zip);

Readonly::Scalar our $SUITS => {
  D => {
    full_name => 'diamonds',
    color     => 'red',
  },
  H => {
    full_name => 'hearts',
    color     => 'red',
  },
  C => {
    full_name => 'clubs',
    color     => 'black',
  },
  S => {
    full_name => 'spades',
    color     => 'black',
  },
};

Readonly::Scalar our $RANKS => {
  zip @{[ 2..10, qw(J Q K A) ]},
  @{[map { {full_name => $_} } qw(
    two three four five six
    seven eight nine ten
    jack queen king ace
  )]}
};

subtype 'CardSuit'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } keys %{$SUITS}; }
  => message { "'$_' is not a valid suit" };

subtype 'CardRank'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } keys %{$RANKS}; }
  => message { "'$_' is not a valid rank" };

has 'suit' => ( is => 'ro', isa => 'CardSuit', required => 1 );
has 'rank' => ( is => 'ro', isa => 'CardRank', required => 1 );

sub color {
  my ($self) = @_;
  return $SUITS->{$self->suit}{color};
}

sub full_name {
  my ($self) = @_;
  return $RANKS->{$self->rank}{full_name}.' of '.$SUITS->{$self->suit}{full_name};
}

no Moose;
no Moose::Util::TypeConstraints;
__PACKAGE__->meta->make_immutable;
