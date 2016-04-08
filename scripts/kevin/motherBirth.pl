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
#          The script produces data related to the birth data files
#          CDC in the United States.  The program tracks data in
#          in relation to the Mother's age and marital status when
#          when giving birth. The data is outputted in text form.
#
#      Commandline Parameters:
#         $ARGV[0] = year to start reading textfiles for
#         $ARGV[1] = year to stop reading textfiles for
#         $ARGV[2]: The path to the data files.
#      Errors:
#         Pass in the correct number of arguments, or the
#         script will complain and exit.
#
#   Variables to be used
#
my @avgAge;
my @avgSingle;
my @avgTeen;
my @teenPregnancyRate;
my @pregnancies;
my @pregnantAge;
my @singleMother;
my @years;
my $EMPTY = q{};
my $COMMA = q{,};
my $filename     = $EMPTY;
my $fileStart = $EMPTY;
my $fileEnd = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my $motherMStatus;
my $motherAge;
my $suffix = "MotherBirthData.txt";
my $yearBegin;
my $yearFinish;
my $yearCurrent;
my $yearDifference = 0;
my $record_count;
my $file_path;


if($#ARGV < 2) #Manage the number of arguments
{
    print "Incorrect arguments.  Please use as motherBirth.pl <start year> <end year> ./<path>/\n";
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

    $teenPregnancyRate[$yearCurrent] = 0;
    $pregnancies[$yearCurrent] = 0;
    $pregnantAge[$yearCurrent] = 0;
    $singleMother[$yearCurrent] = 0;
    $years[$yearCurrent] = $yearCurrent;

    foreach my $dataRecords (@records) #parsing
    {
        if($csv->parse($dataRecords)) #if line is parsed properly
        {
            my @master_fields = $csv->fields();
            $record_count ++;

            $motherMStatus = $master_fields[1];
            $motherAge = $master_fields[0];

            if ($yearCurrent eq 2003) #2003 is a weird year so it has its own if statement
            {
                if (defined $motherAge) #Checks so that the variable has a defined value
                {
                    if($motherAge le '06') #If mother's age is below or equal 19
                    {
                        $teenPregnancyRate[$yearCurrent] ++;
                    }
                    $pregnancies[$yearCurrent] ++;
                    #$pregnantAge[$yearCurrent] = ($pregnantAge[$yearCurrent] + $motherAge);

                    if (defined $motherMStatus)
                    {
                        if ($motherMStatus eq '2' || $motherMStatus eq '9') #Aslong as it does't say that mother was married or recorded to be
                        {
                            $singleMother[$yearCurrent] ++;
                        }
                    }
                }
            }
            elsif($yearCurrent ne 2003)
            {
                if (defined $motherAge)
                {
                    if($motherAge le '19')
                    {
                        $teenPregnancyRate[$yearCurrent] ++;
                    }
                    $pregnancies[$yearCurrent] ++;
                    $pregnantAge[$yearCurrent] = ($pregnantAge[$yearCurrent] + $motherAge);

                    if (defined $motherMStatus)
                    {
                        if ($motherMStatus eq '2' || $motherMStatus eq '9')
                        {
                            $singleMother[$yearCurrent] ++;
                        }
                    }
                }
            }
        }
    }
}

for (my $b = $yearBegin; $b le $yearFinish; $b++) #Loop data to print outputs for every year
{
    $avgAge[$b] = int ($pregnantAge[$b] / $pregnancies[$b]); #record as whole number
    $avgSingle[$b] = (($singleMother[$b] / $pregnancies[$b]) * 100);
    $avgTeen[$b] = (($teenPregnancyRate[$b] / $pregnancies[$b]) * 100);
#   The percentages are rounded to nearest 2 decimal places
    $avgSingle[$b] = sprintf("%.2f",$avgSingle[$b]);
    $avgTeen[$b] = sprintf("%.2f",$avgTeen[$b]);
    print "\nYear ".$b.": \n";
    print "Number of Pregnancies: ".$pregnancies[$b]."\n";
    print "Average Age of Child Birth: ".$avgAge[$b]."\n";
    print "Number of Single Mothers: ".$singleMother[$b]." or ".$avgSingle[$b]."%\n";
    print "Number of Teen Mothers: ".$teenPregnancyRate[$b]." or ".$avgTeen[$b]."%\n";
}

print "\nUsing the birth data from ".$yearBegin." to ".$yearFinish.", we can tell that in the last ".$yearDifference." years:\n";
#   if statements to give conclusions for all scenarios
if ($avgAge[$yearBegin] < $avgAge[$yearFinish])
{
    print "*Women are having babies later. From about ".$avgAge[$yearBegin]." to ".$avgAge[$yearFinish]." years old.\n";
}
elsif($avgAge[$yearBegin] > $avgAge[$yearFinish])
{
    print "*Women are having babies earlier. From about ".$avgAge[$yearBegin]." to ".$avgAge[$yearFinish]." years old.\n";
}
if ($avgTeen[$yearBegin] < $avgTeen[$yearFinish])
{
    print "*Teen pregnancy is becoming more common. From about ".$avgTeen[$yearBegin]."% to ".$avgTeen[$yearFinish]."% of pregnancies being teen pregnancies.\n";
}
elsif ($avgTeen[$yearBegin] > $avgTeen[$yearFinish])
{
    print "*Teen pregnancy is becoming less common. From about ".$avgTeen[$yearBegin]."% to ".$avgTeen[$yearFinish]."% of pregnancies being teen pregnancies.\n";
}
if ($avgSingle[$yearBegin] < $avgSingle[$yearFinish])
{
    print "*There are more single mothers out there. From about ".$avgSingle[$yearBegin]."% to ".$avgSingle[$yearFinish]."% of pregnancies being single mothers.\n";
}
elsif ($avgSingle[$yearBegin] > $avgSingle[$yearFinish])
{
    print "*There are less single mothers out there. From about ".$avgSingle[$yearBegin]."% to ".$avgSingle[$yearFinish]."% of pregnancies being single mothers.\n"
}
#
#   End of Script
#
