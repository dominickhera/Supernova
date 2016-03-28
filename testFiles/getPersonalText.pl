#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32; 

my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $filename     = $EMPTY;
my $suffix = ".txt";
my $baseName = "Test";

print "Script started at ".$startTime."\n";

#
#   Check that you have the right number of parameters
#
my $firstArg = $ARGV[0];
my $secondArg = $ARGV[1];

if ($#ARGV != 1 ) 
{
    print "Usage: readStats.pl <input csv file>\n" or
        die "Print failure\n";
    exit;
} 
else
{

    $filename = "$firstArg"."$baseName"."$suffix";
    $secondFilename = "$secondArg"."$baseName"."$suffix";
}