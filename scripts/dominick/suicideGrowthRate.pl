#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)


#
# Author: Dominick Hera
# dhera@mail.uoguelph.ca
#
# This script produces the total amount of suicides for teenagers aged 13-19 for the
# start and ending year and then uses the information to find the growth rate over
# the difference in years and displays the percentage growth rate to the user.
#
#   ARGS:
#       ARGV[0]: The starting year that will be used
#       ARGV[1]: The ending year that will be used
#
#   Errors:
#       pass in the correct number of arguments, or the 
#       script will complain and exit.
#

#
#   Variables to be used
#
my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $filename     = $EMPTY;
my $secondFilename = $EMPTY;
my $fileStart = $EMPTY;
my $fileEnd = $EMPTY;
my $fileInc = $EMPTY;
my $fileCIS = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my $startTime = localtime;
my @records;
my @secondRecords;
my $record_count = 0;
my $record_count2 = 0;
my $record2 = 0;
my $record3 = 0;
my $count;
my @date;
my @gender;
my @mod;
my @age;
my @second_date;
my @second_gender;
my @second_mod;
my @second_age;
my @month;
my $path = "./assets/";
my $suffix = ".txt";
my $baseName = "dat";
my $firstSuicideCount = 0;
my $secondSuicideCount = 0;

print "Script started at ".$startTime."\n";

#
#   Check that you have the right number of parameters
#
my $firstYear = $ARGV[0];
my $secondYear = $ARGV[1];
my $yearDifference = ($secondYear - $firstYear);
if ($#ARGV != 1 ) 
{
    print "Usage: readStats.pl <input csv file>\n" or
        die "Print failure\n";
    exit;
} 
else
{

    $filename = "$path.$firstYear"."$baseName"."$suffix";
    $secondFilename = "$path.$secondYear"."$baseName"."$suffix";
}

#
#   Open the input file and load the contents into records array
#

open my $names_fh, '<', $filename
or die "Unable to open names file: $filename\n";

open my $secondNames_fh, '<', $secondFilename
or die "Unable to open names file: $secondFilename\n";

@records = <$names_fh>;
@secondRecords = <$secondNames_fh>;

close $names_fh or
die "Unable to close: $ARGV[0]\n";   # Close the input file

close $secondNames_fh or
die "Unable to close: $ARGV[1]\n";  

#
#   Parse each line and print out the information
#
foreach my $name_record ( @records ) 
{
    if ( $csv->parse($name_record) ) 
    {
        my @master_fields = $csv->fields();
        $record2++;
        $date[$record2] = $master_fields[0];
        $mod[$record2] = $master_fields[1];
        $age[$record2] = $master_fields[2];
        $gender[$record2] = $master_fields[3];
    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
    $record_count++;
}

foreach my $second_name_record ( @secondRecords ) 
{
    if ( $csv->parse($second_name_record) ) 
    {
        my @master_fields = $csv->fields();
        $record3++;
        $second_date[$record3] = $master_fields[0];
        $second_mod[$record3] = $master_fields[1];
        $second_age[$record3] = $master_fields[2];
        $second_gender[$record3] = $master_fields[3];
    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
    $record_count2++;
}

for (my $c = 1; $c <= 12; $c++)
{
    if ($c < 10)
    {
        $month[$c] = "0".$c;
    }
    if ($c >= 10)
    {
        $month[$c] = $c;
    }
}

#FOR 2003+
#age format is changed to 1013 - 1019
#
#Race is masterfields[5]
#
#
#FOR 2002-
#age is a different format so it's 013 - 019
#

if ($firstYear > 2002)
{
    for (my $b = 1; $b <= 12; $b++)
    {
        $count = 0;
        for (my $i = 1; $i < $record2; $i++)
        {
            if ($mod[$i] eq '2' && $date[$i] eq $month[$b] && $age[$i] > '1012' && $age[$i] < '1020')
            {
                $count++;
                $firstSuicideCount++;
            }
        }
    }
}
else
{
    for (my $b = 1; $b <= 12; $b++)
    {
        $count = 0;
        for (my $i = 1; $i < $record2; $i++)
        {
            if ($mod[$i] eq '2' && $date[$i] eq $month[$b] && $age[$i] > '012' && $age[$i] < '020')
            {
                $count++;
                $firstSuicideCount++;
            }
        }
    }  
}

if ($secondYear > 2002)
{
    for (my $b = 1; $b <= 12; $b++)
    {
        $count = 0;
        for (my $i = 1; $i < $record3; $i++)
        {
            if ($second_mod[$i] eq '2' && $second_date[$i] eq $month[$b] && $second_age[$i] > '1012' && $second_age[$i] < '1020')
            {
                $count++;
                $secondSuicideCount++;
            }
        }
    }
}
else
{
    for (my $b = 1; $b <= 12; $b++)
    {
        $count = 0;
        for (my $i = 1; $i < $record2; $i++)
        {
            if(defined($second_mod[$i]))
            {
            if ($second_mod[$i] eq '2' && $second_date[$i] eq $month[$b] && $second_age[$i] > '012' && $second_age[$i] < '020')
            {
                $count++;
                $secondSuicideCount++;
            }
        }
        }
    }  
}

my $subYearDifference = (1/$yearDifference);
my $subPercentGrowthRate = ((($secondSuicideCount - $firstSuicideCount)/$firstSuicideCount) * 100);
my $percentGrowthRate = ($subPercentGrowthRate / $yearDifference);
my $endTime = localtime;

print "Script finished at ".$endTime."\n";
print "Total Teen Suicides in ".$firstYear.": ".$firstSuicideCount."\n";
print "Total Teen Suicides in ".$secondYear.": ".$secondSuicideCount."\n";
print "The growth rate of suicides between ".$firstYear." and ".$secondYear." is ".$percentGrowthRate."%\n";

#
#   End of Script
#
