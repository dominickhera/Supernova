#!/usr/bin/perl
use strict;
use warnings;

#
#  readBirth2014.pl
#     Author: Deborah Stacey
#     Date of Last Update: Sunday, February 21, 2016.
#
#     Summary
#
#     Parameters on the commandline:
#        $ARGV[0] = name of the input file, i.e. the Birth file
#
#     References
#        Tested on 2014 data.
#

my $birthRecord;
#
#  Check that you have the right number of parameters
#
if ($#ARGV != 0 ) {
   print "Usage: readBirth2014.pl <file name>\n";
   exit;
}

#
#  Open the input file - assign a file handle
#
open my $birthFH, '<', $ARGV[0]
   or die "Unable to open the file: $ARGV[0]";

#
#  Read in each record (one per line) until the end of the file
#
my $MotherAge        = "";
my $MotherMStatus     = "";
my $ofname;
my $out_file_suffix = "MotherBirthData.txt";
$ofname = $out_file_suffix;

open my $ofile, '>', $ofname
   or die "ubable to open $ofname\n";

while ( $birthRecord = <$birthFH> ) {
#
#  Chop off the end of line character(s)
#
   chomp ( $birthRecord );

#
#  Extract each field from the record as delimited by column position
#

    $MotherAge         = substr( $birthRecord, 69, 2 );
    $MotherMStatus     = substr( $birthRecord, 86, 1 );

    print $ofile $MotherAge.",".$MotherMStatus."\n";

}

#
#  Close the file
#
close ($birthFH);

#
#  End of Script
#
