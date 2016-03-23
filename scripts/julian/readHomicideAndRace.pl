#!/usr/bin/perl
use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Text::CSV   1.32;

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
my @manners = ('Not Specified', 'Accident', 'Suicide', 'Homicide', 'Pending Investigation', 'Could not determine', 'Self-Inflicted', 'Natural');
my @races   = ('Other', 'White', 'Black', 'American-Indian', 'Chinese', 'Japanese', 'Hawaiian', 'Filipino', 'Asian-Indian', 'Korean', 'Samoan', 'Vietnamese', 'Guamanian', 'Other Asian/Pacific Islander'); 
my $homicides = 0;


my $file_suffix = "Test.txt"; #= "MortUSA.txt";

my $start_year;
my $end_year;
my $current_year;


#
#START OF SCRIPT
#
#

if($#ARGV < 1)
{
    print "Incorrect arguments.  Please use as ./readHomicideAndRace <start year> <end year>\n";
    die "Argument Error\n";
    exit;
}
else
{
    $start_year = $ARGV[0];
    $end_year   = $ARGV[1];
}

#FOR 2003+
#manner is masterfields[13]
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


for $current_year ($start_year..$end_year)
{
    my $fname = $current_year.$file_suffix;
    my @records;

    open my $year_file, '<', $fname
        or die "Cannot open file $fname\n";

    @records = <$year_file>;
    close $year_file;
    
    foreach my $year_record (@records)
    {
        if($csv->parse($year_record)) # the line was parsed correctly.
        {
            my @csv_fields = $csv->fields();
            
            my $record_race;
            my $record_manner;

            $record_count ++;
            
            $record_race = $csv_fields[5];
            if($current_year > 2002)
            {
                $record_manner = $csv_fields[13];
            }
            else
            {
                $record_manner = $csv_fields[11];
            }

            if(int($record_manner) == 12) # if the current person died of a homicide.
            {
                $race_manner[$record_race] ++;
                $homicides ++;
            }

        }
        else # there is an unparseable line.
        {
            warn "Could not parse line $year_record\n";
        }
    }

}


print "Here are the homicides over the last ".($end_year - $start_year)." years.\n";

for my $i (0..(scalar(@race_manner) - 1))
{
    print $races[$i].": ".$race_manner[$i]." homicides.\n";
}
print "In total, there were ".$homicides." homicides.\n"



