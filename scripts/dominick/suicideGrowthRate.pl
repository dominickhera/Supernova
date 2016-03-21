#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
                       # to parse each line

#
#      Functional Summary
#         readStats.pl takes in a CSV (comma separated version) file
#         containing death stats for the USA for a particular year
#
#      Commandline Parameters: 1
#         $ARGV[0] = name of the input file
#
#      References
#

#
#   Variables to be used
#
my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $filename     = $EMPTY;
my $fileStart = $EMPTY;
my $fileEnd = $EMPTY;
my $fileInc = $EMPTY;
my $testShit = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my @records;
my $record_count = 0;
my $record2 = 0;
my @secondRecords;
my $secondRecordCount = 0;
my $secondRecordCount2 = 0;
#my $yearDifference = 0;
my $count;
my @date;
my @gender;
my @mod;
my @Ftotal;
my @month;
my @month1;
my @Mtotal;
my @hold;
my $firstYearCount;
my $secondYearCount;
#my $firstYearNum;
#my $secondYearNum;


#
#   Check that you have the right number of parameters
#
# if ($#ARGV != 0 ) {
#    print "Usage: suicideGrowthRate.pl <input csv file>\n" or
#       die "Print failure\n";
#    exit;
# } else {
   $filename = $ARGV[0];
   $fileEnd = $ARGV[1];
   $fileInc = $ARGV[2];
   $testShit = $ARGV[3];
#}

my $firstYearNum = $fileInc;
my $secondYearNum = $testShit;

#
#   Open the input file and load the contents into records array
#
open my $names_fh, '<', $filename
   or die "Unable to open names file: $filename\n";

@records = <$names_fh>;

close $names_fh or
   die "Unable to close: $ARGV[0]\n";   # Close the input file

open my $names2_fh, '<', $fileEnd
   or die "Unable to open names file: $filename\n";

@secondRecords = <$names2_fh>;

close $names2_fh or
   die "Unable to close: $ARGV[0]\n";   # Close the input file

#print qq["Sex","Month","Suicide"\n];

#
#   Parse each line and print out the information
#
foreach my $name_record ( @records ) {
   if ( $csv->parse($name_record) ) {
      my @master_fields = $csv->fields();
       $record2++;
       $gender[$record2] = $master_fields[4];
       $date[$record2] = $master_fields[1];
       $mod[$record2] = $master_fields[12];
   } else {
      warn "Line/record could not be parsed: $records[$record_count]\n";
   }
   $record_count++;
}

foreach my $name_record ( @secondRecords ) {
   if ( $csv->parse($name_record) ) {
      my @master_fields = $csv->fields();
       $secondRecordCount2++;
       $gender[$secondRecordCount2] = $master_fields[4];
       $date[$secondRecordCount2] = $master_fields[1];
       $mod[$secondRecordCount2] = $master_fields[12];
   } else {
      warn "Line/record could not be parsed: $records[$record_count]\n";
   }
   $secondRecordCount++;
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
    for (my $i = 1; $i < $record2; $i++)
    {
        if ($mod[$i] eq '2' && $date[$i] eq $month[$b])
        {
            $count++;
            $firstYearCount++;
        }
    }
}

print "Total Suicides: ".$firstYearCount."\n";

my $yearDifference = $fileInc - $fileEnd;

#$yearDifference = $ARGV[2];

print "Year Difference is ".$yearDifference."\n";



# for (my $b = 1; $b <= 12; $b++)
# {
#     $count = 0;
#     for (my $i = 1; $i < $record2; $i++)
#     {
#         if ($mod[$i] eq '2' && $gender[$i] eq 'F' && $date[$i] eq $month[$b])
#         {
#             $count++;
#         }
#     }
#     $hold[$b] = $count;
#     print "Female,".$month[$b]."/".$month1[$b].",".$hold[$b]."\n";
# }


# for (my $b = 1; $b <= 12; $b++)
# {
#     $count = 0;
#     for (my $i = 1; $i < $record2; $i++)
#     {
#         if ($mod[$i] eq '2' && $gender[$i] eq 'M' && $date[$i] eq $month[$b])
#         {
#             $count++;
#         }
#     }
#     $hold[$b] = $count;
#     print "Male,".$month[$b]."/".$month1[$b].",".$hold[$b]."\n";
# }


#
#   End of Script
#
