#!/usr/bin/perl
use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Text::CSV   1.32;

my $EMPTY = q{};
my $COMMA = q{,};

#
#
#
my $RACE_POS = 5; # this is the index that race is stored at.
my $MANNER_POS = 12 # this is the index that manner of death is stored at.

my $filename;
my $csv = Text::CSV->new({sep_char => $COMMA});
my @records;
my $record_count;

my @races = ();
my @race_manner;
my @manners = ('Not Specified', 'Accident', 'Suicide', 'Homicide', 'Pending Investigation', 'Could not determine', 'Self-Inflicted', 'Natural');
my @races   = ('Other', 'White', 'Black', 'American-Indian', 'Chinese', 'Japanese', 'Hawaiian', 'Filipino', 'Asian-Indian', 'Korean', 'Samoan', 'Vietnamese', 'Guamanian', 'Other Asian/Pacific Islander'); 

#
#Race is masterfields[]? TODO
#Homicide is encoded as 3.
#
#Race is masterfields[5]
#
