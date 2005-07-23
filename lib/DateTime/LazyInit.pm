package DateTime::LazyInit;

use strict;
use warnings;

use DateTime;
use vars qw/$AUTOLOAD $VERSION/;

$VERSION = '0.10';

sub new {
	my $class = shift;

	# NO VALIDATION
	# We'll accept your grandmother if you pass her to us.
	my %args = @_;

	return bless \%args, $class;
}

sub AUTOLOAD {

	my $attr = $AUTOLOAD;
	$attr =~ s/.*:://;
    return unless $attr =~ /[^A-Z]/;  # skip DESTROY and all-cap methods

	# Anything else, we need to inflate into a DateTime object.
	return shift->__inflate($attr, @_);
}

# Simple set and get for year

sub set_year {
        $_[0]->{year} = $_[1];
        return $_[0];
}

sub year {
        return $_[0]->{year} if $_[0]->{year};
        return 0;
}



# Simple set and get for month

sub set_month {
        $_[0]->{month} = $_[1];
        return $_[0];
}

sub month {
        return $_[0]->{month} if $_[0]->{month};
        return 1;
}



# Simple set and get for day

sub set_day {
        $_[0]->{day} = $_[1];
        return $_[0];
}

sub day {
        return $_[0]->{day} if $_[0]->{day};
        return 1;
}



# Simple set and get for hour

sub set_hour {
        $_[0]->{hour} = $_[1];
        return $_[0];
}

sub hour {
        return $_[0]->{hour} if $_[0]->{hour};
        return 0;
}



# Simple set and get for minute

sub set_minute {
        $_[0]->{minute} = $_[1];
        return $_[0];
}

sub minute {
        return $_[0]->{minute} if $_[0]->{minute};
        return 0;
}



# Simple set and get for second

sub set_second {
        $_[0]->{second} = $_[1];
        return $_[0];
}

sub second {
        return $_[0]->{second} if $_[0]->{second};
        return 0;
}



# Simple set and get for nanosecond

sub set_nanosecond {
        $_[0]->{nanosecond} = $_[1];
        return $_[0];
}

sub nanosecond {
        return $_[0]->{nanosecond} if $_[0]->{nanosecond};
        return 0;
}



# Simple set for locale

sub set_locale {
        $_[0]->{locale} = $_[1];
        return $_[0];
}



# Simple set for time_zone

sub set_time_zone {
        $_[0]->{time_zone} = $_[1];
        return $_[0];
}



sub set {
	my $self = shift;
	my %attr = @_;
	foreach (keys %attr) {
		$self->{$_} = $attr{$_}
	}
	return $self;
}



sub clone {
	return ref($_[0])->new( %{$_[0]} );
}



# These methods inflate, they're just here so that UNVERSAL::can will work
# if you find any other methods that need to be here, please email
# the author <rickm@cpan.org> or the mailing list <datetime@perl.org>

sub utc_rd_values {
	shift->__inflate('utc_rd_values',@_);
}


# This is the inflator
sub __inflate {
	$_[0] = bless \%{new DateTime(%{$_[0]})}, 'DateTime';
	# And call the method on that
	my $self = shift;
	my ($method) = shift;
	return $self->$method( @_ );
}


1;
__END__

=head1 NAME

DateTime::LazyInit - DateTime objects with deferred validation B<DO NOT USE UNLESS YOU UNDERSTAND>

=head1 SYNOPSIS

  use DateTime::LazyInit;

  my $dt = new DateTime::LazyInit( year=>2005, month=>7, day=>23 );

=head1 DESCRIPTION

LazyInit is designed to quickly create objects that have the potential to
become DateTime objects. It does this by accepting anything you pass to it as
being a valid parameter and value for a DateTime object.

Once a method is called that is beyond the simple set and get methods, the
object will automatically inflate itself into a full DateTime object and then
full validation will take place.

=head1 JUSTIFICATION

When working with a database or logs or many other data sources, it can be
quite handy to have all the dates as DateTimes, however this can be slow as
DateTime objects are large and need to do a lot of validation.

LazyInit defers that validation until it needs it.

=head1 WARNING

Because validation is deferred, this module assumes you will B<only ever give
it valid data>. If you try to give it anything else, it will happily accept it
and then die once it needs to inflate into a DateTime object.

=head1 SIMPLE METHODS

As mentioned, this module supports simple set and get methods without inflating
into a full DateTime object.

=over 4

=head2 Set Methods

These methods simply set the parameter that will later be handed to datetime
and care should be take to ensure that they are valid. For example, LazyInit
will not complain if you set C<day> to C<32>, but DateTime will fail once the
object inflates.

=over 4

=item * year

=item * month

=item * day

=item * hour

=item * minute

=item * second

=item * nanosecond

=item * time_zone

=item * locale

=back

=head2 Get Methods

These methods simply return the values set in the i<Set Methods> or a default
value for any that aren't set. This default value is the same as DateTime's
default value: month and day return 1, others return 0.

B<Note> that there are no Get Methods for locale and time_zone. If you request
either of these, the object will inflate.

=over 4

=item * year

=item * month

=item * day

=item * hour

=item * minute

=item * second

=item * nanosecond

=back

=head1 SEE ALSO

It is important to know DateTime before using LazyInit.

Any problems or queries should be directed to the mailing list: datetime@perl.org

For more information on the DateTime suite of modules, please see the website:
http://datetime.perl.org/

=head1 AUTHOR

Rick Measham, E<lt>rickm@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Rick Measham

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.

=cut
