#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
#
#   marriageAndDeath.pl
#      Author(s): Kevin Pirabaharan (0946212)
#      Project: Marrital Status vs Means of Death
#      Date of Last Update: Saturday, March 21 2016.
#
#      Functional Summary
#         marriageAndDeath.pl takes in a CSV (comma separated version) file
#         containing death stats for the USA for a particular year
#
#      Commandline Parameters: 1
#         $ARGV[0] = year to start reading textfiles for
#         $ARGV[1] = year to stop reading textfiles for
#
#      References
#
#   Variables to be used
#
my $EMPTY = q{};
my $COMMA = q{,};
my $filename     = $EMPTY;
my $fileStart = $EMPTY;
my $fileEnd = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my $injury;
my $meansDeath;
my $education;
my $uneducatedCount = 0;
my $educatedCount = 0;
my $file_suffix = "MortUSA.txt";
my $yearBegin;
my $yearFinish;
my $yearCurrent;
my $test_flag = 0;
my $start_stamp;
my $end_stamp;
my $record_count;
my $educatedWorkDeath = 0;
my $uneducatedWorkDeath = 0;


if($#ARGV < 1) #Manage the number of arguments
{
    print "Incorrect arguments.  Please use as ./educationAndDeath <start year> <end year>\n";
    die "Argument Error\n";
    exit;
}
else
{
    $yearBegin = $ARGV[0];
    $yearFinish   = $ARGV[1];
    if($#ARGV > 1)
    {
        if($ARGV[2] eq 'test') #Use test cases right now to save time
        {
            $test_flag = 1;
            $file_suffix = "Test.txt";
        }
    }
}
#
#   Parse each line and print out the information
#
for $yearCurrent ($yearBegin..$yearFinish) #loop for all denoted years
{
    my $filename = $yearCurrent.$file_suffix;
    my @records;

    open my $textFile, '<', $filename
        or die "Cannot open file $filename\n";
    @records = <$textFile>;
    close $textFile;

    foreach my $dataRecords (@records) #parsing
    {
        if($csv->parse($dataRecords)) #if line is parsed properly
        {
            my @master_fields = $csv->fields();
            $record_count ++;

            if ($yearCurrent eq 2003) #2003 is a weird year for education as fields keep swapping
            {
                $injury = $master_fields[11];
                $meansDeath = $master_fields[12];
                $education = $master_fields[7];
                if (defined $education) #Checks so that the variable has a defined value
                {
                    if($education le '13') #If education is below post-secondary
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
                else
                {
                    $education = $master_fields[8];
                    if (defined $education) #Checks so that the variable has a defined value
                    {
                        if($education le '4') #If education is below post-secondary
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
            }
            elsif($yearCurrent > 2003)
            {
                $education = $master_fields[7];
                $injury = $master_fields[11];
                $meansDeath = $master_fields[12];

                if (defined $education)
                {
                    if($education le '4') #If education is below post-secondary
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
            elsif ($yearCurrent < 2003)
            {
                $education = $master_fields[7];
                $injury = $master_fields[10];
                $meansDeath = $master_fields[11];

                if (defined $education)
                {
                    if($education le '13') #If education is below post-secondary
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
        }
        else
        {
            if($test_flag == 1)
            {
                warn "Could not parse line $dataRecords\n";
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
    $yearGap = $yearFinish - $yearBegin;
    print "Therefore lower education correlates to highter death rates by an average of ".$difference." over ".$yearGap." years.\n";
}
else
{
    print "Therefore lower education doesn't correlate to highter death.\n";
}
#
#   End of Script
#
