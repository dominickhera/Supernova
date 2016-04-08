#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
#
#      Author(s): Kevin Pirabaharan (0946212)
#      kpirabah@mail.uoguelph.ca
#      Date of Last Update: Thursday, April 7 2016.
#
#      Functional Summary
#          The script produces data related to the death data files
#          CDC in the United States.  The program tracks data in
#          in relation to the deceased's education and determines if lower levels of
#          education correlate to a higher death rate. The data is outputted in text form.
#
#      Commandline Parameters:
#         $ARGV[0] = year to start reading textfiles for
#         $ARGV[1] = year to stop reading textfiles for
#         $ARGV[2]: The path to the data files.
#
#      Errors:
#         Pass in the correct number of arguments, or the
#         script will complain and exit.
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
my $suffix = "EducationData.txt";
my $yearBegin;
my $yearFinish;
my $yearCurrent;
my $yearDifference;
my $test_flag = 0;
my $record_count;
my $educatedWorkDeath = 0;
my $uneducatedWorkDeath = 0;


if($#ARGV < 2) #Manage the number of arguments
{
    print "Incorrect arguments.  Please use as marriageAndDeath.pl <start year> <end year> ./<path>/\n";
    die "Argument Error\n";
    exit;
}
else
{
    $yearBegin = $ARGV[0];
    $yearFinish   = $ARGV[1];
    $yearDifference = $yearFinish - $yearBegin;
    if ($yearDifference le 0)
    {
        print "Invalid input of years, starting year must be less than end year and they can't be the same\n";
        die "Input Error\n";
        exit;
    }
    else
    {
        $file_path = $ARGV[2];
    }
}
#
#   Parse each line and print out the information
#
for $yearCurrent ($yearBegin..$yearFinish) #loop for all denoted years
{
    my $filename = $file_path.$yearCurrent.$suffix;
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

            $injury = $master_fields[2];
            $meansDeath = $master_fields[1];
            $education = $master_fields[0];

            if ($yearCurrent eq 2003) #2003 is a weird year for education as fields keep swapping
            {
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
                if (defined $education)
                {
                    if($education le '13') #If education is below post-secondary
                    {
                        $uneducatedCount ++;
                        if (defined $injury)
                        {
                            if ($injury eq 'Y' || $injury eq '1')
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
