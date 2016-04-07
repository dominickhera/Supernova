#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
# use Term::ProgressBar;
 use Statistics::R;
 require "./plot.pl";


my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $startTime = localtime;
my $filename     = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my @records;
my $record_count = 0;
my $record2 = 0;
my $highWeightCount = 0;
my $lowWeightCount = 0;
my $medianWeightCount = 0;
my $totalWeightCount = 0;
my $highBabyCount = 0;
my $lowBabyCount = 0;
my $finalHigh = 0;
my $finalLow = 0;
my $finalAverage = 0;
my $poundConversion = 0.00220462;
my $personCount = 0;
my $count;
my @date;
my @weight;
my @gender;
my @mod;
my @Ftotal;
my @month;
my @month1;
my @Mtotal;
my @hold;
# my $path = "./assets/";
my $suffix = ".txt";
my $baseName = "birthTest";
my $outputPDFpath = "testPDF";

$month1[1] = "January";
$month1[2] = "February";
$month1[3] = "March";
$month1[4] = "April";
$month1[5] = "May";
$month1[6] = "June";
$month1[7] = "July";
$month1[8] = "August";
$month1[9] = "September";
$month1[10] = "October";
$month1[11] = "November";
$month1[12] = "December";

print "\nScript started at ".$startTime."\n\n";

my $birthYear = $ARGV[0];

if ($#ARGV != 0 ) 
{
    print "Usage: readStats.pl <input csv file>\n" or
        die "Print failure\n";
    exit;
} 
else
{
    $filename = "$birthYear"."$baseName"."$suffix";
}

open my $names_fh, '<', $filename
or die "Unable to open names file: $filename\n";

@records = <$names_fh>;

close $names_fh or
die "Unable to close: $ARGV[0]\n"; 

foreach my $name_record ( @records ) 
{
    if ( $csv->parse($name_record) ) 
    {
        my @master_fields = $csv->fields();
        $record2++;
        $date[$record2] = $master_fields[0];
        $weight[$record2] = $master_fields[1];
    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
    $record_count++;
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

for (my $b = 1; $b <= 12; $b++)
{
    $count = 0;
# $lowWeightCount = $weight[1];
    print "starting low weight ".$lowWeightCount."\n";
    for (my $i = 1; $i < $record2; $i++)
    {
        if ($date[$i] eq $month[$b])
        {
            $personCount++;

            if ($weight[$i] > $highWeightCount)
            {
                if($lowWeightCount == 0)
                {
                    $lowWeightCount = $weight[$i];
                }
                $highBabyCount = 0;
                $highWeightCount = $weight[$i];
                # print "new highest weight ".$highWeightCount."\n";
                $totalWeightCount += $weight[$i];
            }
            elsif($weight[$i] < $lowWeightCount)
            {
                $lowBabyCount = 0;
                $lowWeightCount = $weight[$i];
                # print "new lowest weight ".$lowWeightCount."\n";
                $totalWeightCount += $weight[$i];
            }
            elsif($weight[$i] == $highWeightCount)
            {
                $highBabyCount++;
            }
            elsif($weight[$i] == $lowWeightCount)
            {
                $lowBabyCount++;
            }
            $totalWeightCount += $weight[$i];
            $count++;
        }
    }
    $medianWeightCount = ($totalWeightCount / $personCount);
    $finalHigh = ($highWeightCount * $poundConversion);
    $finalLow = ($lowWeightCount * $poundConversion);
    $finalAverage = ($medianWeightCount * $poundConversion);
    print $highBabyCount." babies were born with the max weight of ".$finalHigh." lbs. in ".$month1[$b]."\n";
    print $lowBabyCount." babies were born with the max weight of ".$finalLow." lbs. in ".$month1[$b]."\n";
    # print "Highest Weight for ".$month1[$b].": ".$finalHigh." lbs\n";
    # print "Lowest Weight for ".$month1[$b].": ".$finalLow." lbs\n";
    print "Average Weight for ".$month1[$b].": ".$finalAverage." lbs\n\n";

    plot_data("Month", \@month, "Amount of High Births", \$highBabyCount, "Birth Weight.pdf");
    $finalHigh = 0;
    $finalLow = 0;
    $finalAverage = 0;
    $highWeightCount = 0;
    $lowWeightCount = 0;
    $personCount = 0;
    $medianWeightCount = 0;
    $personCount = 0;
    $totalWeightCount = 0;
    $lowBabyCount = 0;
    $highBabyCount = 0;
    $hold[$b] = $count;
}

my $endTime = localtime;
print "Script finished at ".$endTime."\n\n";

