#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)


my $EMPTY = q{};
my $COMMA = q{,};
my $LIMIT = 5;

my $startTime = localtime;
my $filename     = $EMPTY;
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my @records;
my $record_count = 0;
my $record2 = 0;
my $count;
my @date;
my @gender;
my @mod;
my @Ftotal;
my @month;
my @month1;
my @Mtotal;
my @hold;

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

print "Script started at ".$startTime."\n";

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
        $mod[$record2] = $master_fields[1];
        $age[$record2] = $master_fields[2];
        $gender[$record2] = $master_fields[3];
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
    for (my $i = 1; $i < $record2; $i++)
    {
        if ($mod[$i] eq '2' && $gender[$i] eq 'F' && $date[$i] eq $month[$b])
        {
            $count++;
        }
    }
    $hold[$b] = $count;
    print "Female,".$month[$b]."/".$month1[$b].",".$hold[$b]."\n";
}







