#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
use Statistics::R;
require "./plot.pl";


my @race_manner = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
my @races   = ('Other', 'White', 'Black', 'American-Indian', 'Chinese', 'Japanese', 'Hawaiian', 'Filipino', 'Asian-Indian', 'Korean', 'Samoan', 'Vietnamese', 'Guamanian', 'Other Asian/Pacific Islander');

plot_data("Race",\@races,"Homicides",\@race_manner,"Test.pdf");