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
my $meansDeath;
my $maritalStatus;
my $suffix = "MortUSA.txt";
my $yearBegin;
my $yearFinish;
my $yearCurrent;
my $test_flag = 0;
my $record_count;
my $accident = 0;
my $suicide = 0;
my $homicide = 0;
my $notSure = 0;
my $Self_Inflicted = 0;
my $natural = 0;


if($#ARGV < 1) #Manage the number of arguments
{
    print "Incorrect arguments.  Please use as ./marriageAndDeath.pl <start year> <end year>\n";
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
            $suffix = "Test.txt";
        }
    }
}
#
#   Parse each line and print out the information
#
for $yearCurrent ($yearBegin..$yearFinish) #loop for all denoted years
{
    my $filename = $yearCurrent.$suffix;
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

            if($yearCurrent > 2002)
            {
                $maritalStatus = $master_fields[6];
                $meansDeath = $master_fields[12];
            }
            elsif ($yearCurrent < 2003)
            {
                $maritalStatus = $master_fields[7];
                $meansDeath = $master_fields[11];
            }
            if (defined $maritalStatus)
            {
                if($maritalStatus eq 'M') #If maritalStatus is below post-secondary
                {
                    if ($meansDeath eq '1')
                    {
                        $accident ++;
                    }
                    elsif ($meansDeath eq '2')
                    {
                        $suicide ++;
                    }
                    elsif ($meansDeath eq '3')
                    {
                        $homicide ++;
                    }
                    elsif ($meansDeath eq '4' || $meansDeath eq '5')
                    {
                        $notSure ++;
                    }
                    elsif ($meansDeath eq '6')
                    {
                        $Self_Inflicted ++;
                    }
                    elsif ($meansDeath eq '7')
                    {
                        $natural ++;
                    }
                    else
                    {
                        $notSure ++;
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

print "Married individuals that died in an accident: ".$accident."\n";
print "Married individuals that died from suicide: ".$suicide."\n";
print "Married individuals that died in a homicide: ".$homicide."\n";
print "Married individuals that died in undetermined or unknown circumstances: ".$notSure."\n";
print "Married individuals that died from self-inflicted wounds: ".$Self_Inflicted."\n";
print "Married individuals that died naturally: ".$natural."\n";

#
#   End of Script
#
