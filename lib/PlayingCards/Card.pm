package PlayingCards::Card;

use Moose;
use Moose::Util::TypeConstraints;
use Readonly ();
use List::MoreUtils qw(uniq any zip);
use PlayingCards::Constants;
use Carp qw(croak);

subtype 'CardSuit'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } uniq @SUITS, map {lc} @SUITS; }
  => message { "'$_' is not a valid suit" };

subtype 'CardRank'
  => as 'Str'
  => where { my $input = $_; any { $input eq $_ } uniq @RANKS, map {lc} @RANKS, '10'; }
  => message { "'$_' is not a valid rank" };

has 'suit' => ( is => 'ro', isa => 'CardSuit', required => 1 );
has 'rank' => ( is => 'ro', isa => 'CardRank', required => 1 );

sub BUILD {
  my ($self) = @_;
  if ($self->rank eq '10') {
    $self->{rank} = 'T';
  }

  foreach my $key (qw(rank suit)) {
    $self->{$key} = uc $self->$key;
  }

  return;
}

sub color {
  my ($self) = @_;
  return 'red'   if any { $self->suit eq $_ } @RED_SUITS;
  return 'black' if any { $self->suit eq $_ } @BLACK_SUITS;
  croak 'could not match ' . $self->suit . ' to a color';
}

sub full_name {
  my ($self) = @_;
  return $RANK_FULL_NAMES{$self->rank}
    . ' of ' . $SUIT_FULL_NAMES{$self->suit};
}

sub is_face_card {
  my ($self) = @_;
  return any { $_ eq $self->rank } @FACE_RANKS;
}

no Moose;
no Moose::Util::TypeConstraints;
__PACKAGE__->meta->make_immutable;
