#!/usr/bin/perl
require "./plot.pl";
use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Text::CSV   1.32;
use Statistics::R;

my $EMPTY = q{};
my $COMMA = q{,};

#
#
#
my $RACE_POS = 5; # this is the index that race is stored at.
my $MANNER_POS = 12; # this is the index that manner of death is stored at.

my $filename;
my $csv = Text::CSV->new({sep_char => $COMMA});
my @records;
my $record_count = 0;

my @race_manner = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
my @rcs = (0,1,2,3,4,5,6,7,8,9,10,11,12,13);
my @races   = ('Other', 'White', 'Black', 'American-Indian', 'Chinese', 'Japanese', 'Hawaiian', 'Filipino', 'Asian-Indian', 'Korean', 'Samoan', 'Vietnamese', 'Guamanian', 'Other Asian/Pacific Islander'); 
my $homicides = 0;

my $file_path;
my $file_suffix = "dat.txt";

my $start_year;
my $end_year;
my $current_year;

my $test_flag = 0;
my $time_flag = 0;


my $start_stamp;
my $end_stamp;

#
#START OF SCRIPT
#
#

if($#ARGV < 2)
{
    print "Incorrect arguments.  Please use as ./readHomicideAndRace <start year> <end year> <file_path>\n";
    die "Argument Error\n";
    exit;
}
else
{
    $start_year = $ARGV[0];
    $end_year   = $ARGV[1];
    $file_path  = $ARGV[2];
    if($#ARGV == 3)
    {
        if($ARGV[3] eq 'time')
        {
            $time_flag = 1;
        }
    }

}

#FOR 2003+
#manner is masterfields[12]
#Homicide is encoded as 3.
#
#Race is masterfields[5]
#
#
#FOR 2002-
#manner of death is masterfields[11]
#Race is masterfields[5]
#
#


$start_stamp = localtime();
if($time_flag == 1)
{
    print "Started at $start_stamp\n";
}


for $current_year ($start_year..$end_year)
{
    my $fname = $file_path.$current_year.$file_suffix;
    my $record;

    open my $year_file, '<', $fname
        or die "Cannot open file $fname\n";


    while($record = <$year_file>)
    {
        if($record =~ /[0-9]+:[0-9]/) # the line was parsed correctly.
        {
            my $record_race;
            my $record_manner;
            $record_count ++;

            $record_race = substr($record,0,2,);
            $record_manner = substr($record,3,1);

            if(defined $record_manner)
            {
                if($record_manner eq '3') # if the current person died of a homicide.
                {
                    $race_manner[$record_race] ++;
                    $homicides ++;
                }
            }

        }
        else # there is an unparseable line.
        {
            if($test_flag == 1)
            {
                warn "Could not parse line $record\n";
            }
        }
    }

    close $year_file;
}


if($test_flag == 1)
{
    print "Here are the homicides over the last ".($end_year - $start_year)." years.\n";
}


for my $i (0..13)
{
    if($test_flag == 1)
    {
        print $races[$i].": ".$race_manner[$i]." homicides.\n";
    }
    else
    {
        print $i.":".$race_manner[$i]."\n";
    }
}
plot_data("Race",\@races,"Homicides",\@race_manner,"Race Homicide.pdf");

if($test_flag == 1)
{
    print "In total, there were ".$homicides." homicides.\n"
}

$end_stamp = localtime();
if($time_flag == 1)
{
    print "Finished at $end_stamp.\n";
}

#
#   End of Script.
#
