#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');
use Text::CSV  1.32; 

my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $filename     = $EMPTY;
my $suffix = ".txt";
my $baseName = "MortUSA";
my $record_count = 0;
my $record2 = 0;

my @year;
my @date;
my @mod;
my @age;
my @gender;
my @race;
my @work;
my @marriage;
my @firstEducation;
my @secondEducation;

print "Script started at ".$startTime."\n";

   $fileStart = $ARGV[0];
   $fileEnd = $ARGV[1];
  
my $year = $fileStart;

#  stores all the file names into an array based on the name, year, and ending of the file
while ($year <= $fileEnd)
{
   $fileNames[$index] = "$year"."$baseName"."$suffix";
   # $index++;
   $year++;
}

#  opens the original text file, and stores the contents
open my $names_fh, '<', $namesCISFN
   or die "Unable to open names file \n"; 

@records = <$names_fh>;

close $names_fh or
   die "nope\n";


foreach my $name_record ( @records ) 
{
    if ( $csv->parse($name_record) ) 
    {
        my @master_fields = $csv->fields();
        $record2++;
        $year[$record2] = $master_fields[0]
        $date[$record2] = $master_fields[1];
        $mod[$record2] = $master_fields[2];
        $age[$record2] = $master_fields[3];
        $gender[$record2] = $master_fields[4];
        # $race[$record2] = $master_fields[];
        # $work[$record2] = $master_fields[];
        # $marriage[$record2] = $master_fields[];
        # $firstEducation[$record2] = $master_fields[];
        # $secondEducation[$record2] = $master_fields[];

    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
    $record_count++;
}

