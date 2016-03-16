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
#   readStats.pl
#      Author(s): Giuliano Sovernigo (0948924) and Navkiran Gill (0949468)
#      Project: Lab Assignment 4 Task 2 Script 
#      Date of Last Update: Monday, February 8 2016.
#
#      Functional Summary
#         readStats.pl takes in a CSV (comma separated version) file 
#         containing death stats for the USA for a particular year
#         and then prints the summary by month of the specified manner
#         of death for the each month of the year.  They are also 
#         separated by gender, with female records being printed before.
#
#      Commandline Parameters: 1
#         $ARGV[0] = name of the input file
#         $ARGV[1+] = non-concatenated strings of the manner of death
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
my $csv          = Text::CSV->new({ sep_char => $COMMA });
my @records;
my $record_count = 0;

#
my @months = ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
my @manners = ('Not specified', 'Accident', 'Suicide', 'Homicide', 'Pending Investigation', 'Could not determine', 'Self-Inflicted', 'Natural');
my $manner;

my $arg = '';

my @f_death_totals;
my @m_death_totals;

my $exists_flag = 0;
#

#
#   Check that you have the right number of parameters
#
if ($#ARGV < 1 ) {
    print "Usage: readStats.pl <input csv file> <manner>\n" or
    die "Print failure\n";
    exit;
} else {
    $filename = $ARGV[0];
    for my $i (1..$#ARGV) # concatenate the arguments.
    {
        if($i != $#ARGV)
        {
            $arg = $arg.$ARGV[$i].' ';
        }
        else
        {
            $arg = $arg.$ARGV[$i]
        }
    }
    if($arg eq 'Not specified')
    {
        $exists_flag = 1;
        $manner = '';
    }
    for my $i (1..7)
    {
        if($arg eq $manners[$i])
        {
            $manner = $i;
            $exists_flag = 1;
        }
    }
}

if($exists_flag == 0)
{
    print "The manner of death specified does not exist.\n";
    exit;
}

#
#   Open the input file and load the contents into records array
#
open my $names_fh, '<', $filename
    or die "Unable to open names file: $filename\n";

@records = <$names_fh>;

close $names_fh or
die "Unable to close: $ARGV[0]\n";   # Close the input file

print "\"Sex\",\"Month\",\"$arg\"\n";

for my $i (0..11)
{
    $f_death_totals[$i] = 0;
    $m_death_totals[$i] = 0;
}

#
#   Parse each line and print out the information
#
foreach my $name_record ( @records ) {
    if ( $csv->parse($name_record) ) {
        my @master_fields = $csv->fields();
        if($master_fields[12] eq "$manner") # if the manner was what was specified...
        {
            #
            #   We are not proud of this code.
            #   They are just elsif statements for each month.
            #
            if($master_fields[1] eq "01")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[0] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[0] ++;
                }   
            }
            elsif($master_fields[1] eq "02")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[1] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[1] ++;
                }   

            }
            elsif($master_fields[1] eq "03")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[2] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[2] ++;
                }   

            }
            elsif($master_fields[1] eq "04")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[3] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[3] ++;
                }   

            }
            elsif($master_fields[1] eq "05")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[4] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[4] ++;
                }   

            }
            elsif($master_fields[1] eq "06")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[5] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[5] ++;
                }   

            }
            elsif($master_fields[1] eq "07")
            {

                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[6] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[6] ++;
                }   
            }
            elsif($master_fields[1] eq "08")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[7] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[7] ++;
                }   

            }
            elsif($master_fields[1] eq "09")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[8] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[8] ++;
                }   

            }
            elsif($master_fields[1] eq "10")
            {

                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[9] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[9] ++;
                }   
            }
            elsif($master_fields[1] eq "11")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[10] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[10] ++;
                }   

            }
            elsif($master_fields[1] eq "12")
            {
                if($master_fields[4] eq 'F')
                {
                    $f_death_totals[11] ++;
                }
                elsif($master_fields[4] eq 'M')
                {
                    $m_death_totals[11] ++;
                }   

            }
        }
    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
    $record_count++;
}

for my $i (0..11) # loop through females
{
    if($i < 10) # if we need to add a zero before i, essentially
    {
        print "Female,0".($i + 1).'/'.$months[$i].$COMMA.$f_death_totals[$i]."\n";
    }
    else # just print i
    {
        print "Female,".($i + 1).'/'.$months[$i].$COMMA.$f_death_totals[$i]."\n";
    }
}


#
#   Same as above, but for males
#
for my $i (0..11)
{
    if($i < 10)
    {
        print "Male,0".($i + 1).'/'.$months[$i].$COMMA.$m_death_totals[$i]."\n";
    }
    else
    {
        print "Male,".($i + 1).'/'.$months[$i].$COMMA.$m_death_totals[$i]."\n";
    }
}



#
#   End of Script
#
