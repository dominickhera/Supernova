#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
#
#   educationAndDeath.pl
#      Author(s): Kevin Pirabaharan (0946212)
#      Project: Level of Education vs. Death Rate
#      Date of Last Update: Saturday, March 21 2016.
#
#      Functional Summary
#         educationAndDeath.pl takes in a CSV (comma separated version) file
#         containing death stats for the USA for a particular year
#
#      Commandline Parameters: 1
#         $ARGV[0] = name of the input file
#
#      References
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
my $count;
my $injury;
my $mod;
my $education;
my $uneducatedCount = 0;
my $educatedCount = 0;
my $file_suffix = "MortUSA.txt";
my $start_year;
my $end_year;
my $current_year;
my $test_flag = 0;
my $start_stamp;
my $end_stamp;
my $record_count;
my $educatedWorkDeath;
my $uneducatedWorkDeath;


if($#ARGV < 1)
{
    print "Incorrect arguments.  Please use as ./readHomicideAndRace <start year> <end year>\n";
    die "Argument Error\n";
    exit;
}
else
{
    $start_year = $ARGV[0];
    $end_year   = $ARGV[1];
    if($#ARGV > 1)
    {
        if($ARGV[2] eq 'test')
        {
            $test_flag = 1;
            $file_suffix = "Test.txt";
        }
    }
}
#
#   Parse each line and print out the information
#
for $current_year ($start_year..$end_year)
{
    my $filename = $current_year.$file_suffix;
    my @records;

    open my $year_file, '<', $filename
        or die "Cannot open file $filename\n";

    @records = <$year_file>;
    close $year_file;

    foreach my $year_record (@records)
    {
        if($csv->parse($year_record)) # the line was parsed correctly.
        {
            my @master_fields = $csv->fields();
            $record_count ++;

            if ($current_year eq 2003)
            {
                $injury = $master_fields[11];
                $mod = $master_fields[12];
                $education = $master_fields[7];
                if (defined $education)
                {
                    #does nothing if it this field is populated else it will look in anohter field
                }
                else
                {
                $education = $master_fields[8];
                }
            }
            elsif($current_year > 2003)
            {
                $education = $master_fields[7];
                $injury = $master_fields[11];
                $mod = $master_fields[12];
            }
            elsif ($current_year < 2003)
            {
                $education = $master_fields[7];
                $injury = $master_fields[10];
                $mod = $master_fields[11];
            }

            if (defined $education)
            {
                if($education le '13')
                {
                    $uneducatedCount ++;
                    if (defined $injury)
                    {
                        if ($injury eq 'Y')
                        {
                            $uneducatedWorkDeath ++;
                            $educatedWorkDeath ++;
                        }
                        else
                        {
                            $educatedWorkDeath ++;
                        }
                    }
                }
                else
                {
                    $educatedCount ++;
                    $educatedWorkDeath ++;
                }
            }
        }
        else # there is an unparseable line.
        {
            if($test_flag == 1)
            {
                warn "Could not parse line $year_record\n";
            }
        }
    }
}

print "Total Deaths With Low-Education Level: ".$uneducatedCount."\n";
print "Total Deaths With Higher-Education Level: ".$educatedCount."\n";
print "Total Work Related Deaths: ".$educatedWorkDeath."\n";
print "Total Work Related Deaths As A Result of Low-Education: ".$uneducatedWorkDeath."\n";

if ($uneducatedCount > $educatedCount)
{
    my $difference;
    my $yearGap;
    $difference = $uneducatedCount - $educatedCount;
    $yearGap = $end_year - $start_year;
    print "Therefore lower-education correlates to highter death rates by an average of ".$difference." over ".$yearGap." years \n";
}
else
{
    print "Therefore lower-education doesn't correlate to highter death \n";
}
#
#   End of Script
#
