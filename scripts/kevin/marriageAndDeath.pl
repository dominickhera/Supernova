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
#          in relation to the deceased's marital status and determines the most common form
#          of death among married individuals. The data is outputted in text form.
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
my $meansDeath;
my $maritalStatus;
my $suffix = "MarriageData.txt";
my $yearBegin;
my $yearFinish;
my $yearCurrent;
my $record_count;
my $accident = 0;
my $selfHarmOrSuicide = 0;
my $homicide = 0;
my $notSure = 0;
my $natural = 0;
my $file_path;
my $yearDifference = 0;
my $deathTotal = 0;
my $accidentPercent;
my $selfHarmOrSuicidePercent;
my $homicidePercent;
my $notSurePercent;
my $naturalPercent;

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
        $file_path = $ARGV[2]; #File path
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

            $maritalStatus = $master_fields[0];
            $meansDeath = $master_fields[1];

            if (defined $maritalStatus)
            {
                if($maritalStatus eq 'M' || $maritalStatus eq '2') #If maritalStatus is married
                {
                    if ($meansDeath eq '1')
                    {
                        $accident ++;
                        $deathTotal ++;
                    }
                    elsif ($meansDeath eq '2')
                    {
                        $selfHarmOrSuicide ++;
                        $deathTotal ++;
                    }
                    elsif ($meansDeath eq '3')
                    {
                        $homicide ++;
                        $deathTotal ++;
                    }
                    elsif ($meansDeath eq '4' || $meansDeath eq '5')
                    {
                        $notSure ++;
                        $deathTotal ++;
                    }
                    elsif ($meansDeath eq '6')
                    {
                        $selfHarmOrSuicide ++;
                        $deathTotal ++;
                    }
                    elsif ($meansDeath eq '7')
                    {
                        $natural ++;
                        $deathTotal ++;
                    }
                    else
                    {
                        $notSure ++;
                        $deathTotal ++;
                    }
                }
            }
        }
    }
}
# Find Percentages of each manner of death
$accidentPercent = (($accident / $deathTotal) * 100);
$accidentPercent = sprintf("%.2f",$accidentPercent);
$selfHarmOrSuicidePercent = (($selfHarmOrSuicide / $deathTotal) * 100);
$selfHarmOrSuicidePercent = sprintf("%.2f",$selfHarmOrSuicidePercent);
$homicidePercent = (($homicide / $deathTotal) * 100);
$homicidePercent = sprintf("%.2f",$homicidePercent);
$notSurePercent = (($notSure / $deathTotal) * 100);
$notSurePercent = sprintf("%.2f",$notSurePercent);
$naturalPercent = (($natural / $deathTotal) * 100);
$naturalPercent = sprintf("%.2f",$naturalPercent);
#Print out all data
print "\nMarried individuals that died in an accident: ".$accident." or ".$accidentPercent."%\n";
print "Married individuals that died as a result of self harm or suicide: ".$selfHarmOrSuicide." or ".$selfHarmOrSuicidePercent."\n";
print "Married individuals that died in a homicide: ".$homicide." or ".$homicidePercent."\n";
print "Married individuals that died in undetermined or unknown circumstances: ".$notSure." or ".$notSurePercent."\n";
print "Married individuals that died naturally: ".$natural." or ".$naturalPercent."\n";

#If statmenets in case there is a change in data
if ($accident > $selfHarmOrSuicide && $accident > $homicide && $accident > $notSure && $accident > $natural)
{
    print "\nTherefore over the last ".$yearDifference." year(s), dying in an accident is the most comman way Married individuals die.\n"
}
elsif ($selfHarmOrSuicide > $accident && $selfHarmOrSuicide > $homicide && $selfHarmOrSuicide > $notSure && $accident > $natural)
{
    print "\nTherefore over the last ".$yearDifference." year(s), dying as a result of self-harm or suicide is the most comman way Married individuals die.\n"
}
elsif ($homicide > $selfHarmOrSuicide && $homicide > $accident && $homicide > $notSure && $homicide > $natural)
{
    print "\nTherefore over the last ".$yearDifference." year(s), homicide is the most comman way Married individuals die.\n"
}
elsif ($notSure > $selfHarmOrSuicide && $notSure > $accident && $notSure > $accident && $notSure > $natural)
{
    print "\nTherefore over the last ".$yearDifference." year(s), the cause of death of most married individuals cannot be determined.\n"
}
elsif ($natural > $selfHarmOrSuicide && $natural > $accident && $natural > $notSure && $natural > $accident)
{
    print "\nTherefore over the last ".$yearDifference." year(s), dying naturally is the most comman way Married individuals die.\n"
}
#
#   End of Script
#
