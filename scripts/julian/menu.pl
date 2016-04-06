#!/usr/bin/perl


use warnings;
use strict;
use version;

my $f_path = "assets/";

my $choice;
$choice = '0';

#
#getYear
#this function gets a year from the user.
#IN:    A message to be printed.
#OUT:   A year as inputted by the user.
#POST:  N/A
#ERROR: msg is invalid.
#
sub getYear
{
    my $msg = shift;
    my $year;

    print $msg."\n";

    $year = <>;
    chomp $year;

    while(not($year =~ /^[0-9]+$/))
    {
        $year = <>;
        chomp $year;
    }

    return int($year);
}

sub choose
{
    my $msg = shift;
    print $msg."\n";
    my $resp = <>;
    chomp $resp;
    return $resp;
}

print "Welcome to the Supernova Trend Engine, Aplha v1.0\nPlease note that data aggregated in these statistics may not be entirely accurate,\nas some deaths may not have been reported, recorded, or calculated properly in this software.\nDo not assume any data is entirely accurate as it is presented here.\n\n";

while($choice ne 'q' and $choice ne "quit" and $choice ne '3')
{
    $choice = choose("Please enter your choice:\n1) Birth Stats\n2) Death Stats\n3) Exit");
    if($choice eq '1')# or index("birth", $choice) != -1) # we chose the birth menu
    {
        $choice = '0';
        while(not($choice ne '2' and index("back", $choice) != -1)) # while we havent chosen back
        {
            $choice = choose("Please select an option:\n1) Birth Weight by Month stats\n2) back");
            if($choice eq "1" or index("birth weight", $choice) != -1)
            {
                my $year = 1996;
                system("./src/birthWeight.pl $year"); # call birth weight script 
            }
            else
            {
                last;
            }
        }

    }
    elsif($choice eq '2') # if we selected the death menu
    {
        $choice = 0;
        while(not($choice ne '5' and index("back", $choice) != -1)) # while we havent chosen back
        {
            $choice = choose("Please select an option:\n1) Education and Death Rate stats\n2) Homicide Rates by Race stats\n3) Marriage and Manner of Death stats\n4) Teen Suicide Rates by Year stats\n5) back");
            if($choice eq '1' or index("education and death rate stats", $choice) != -1) # Education + DR
            {
                print "Not Working Yet :P\n";
                <>;
            }
            elsif($choice eq '2' or index("homicide rates by race stats", $choice) != -1) # Homicide by race
            {
                my $syear = 1996;
                my $eyear = 2014;
                $syear = getYear("Please enter a starting year (1996-2013)");
                while($syear < 1996 or $syear > 2013) # invalid start year.
                {
                    $syear = getYear("Please enter a starting year (1996-2013)");
                }

                $eyear = getYear("Please enter an ending year (1997-2014)");
                while($eyear < 1997 or $eyear > 2014) # while the end year is invalid
                {
                    $eyear = getYear("Please enter an ending year (1997-2014)");
                }
                print "\nWorking...\n\n";
                system("./src/homicideAndRace.pl $syear $eyear $f_path");
            }
            elsif($choice eq '3' or index("marriage and manner of death stats", $choice) != -1) # marriage and manner of death
            {
                my $syear = 1996;
                my $eyear = 2014;
                $syear = getYear("Please enter a starting year (1996-2013)");
                while($syear < 1996 or $syear > 2013) # invalid start year.
                {
                    $syear = getYear("Please enter a starting year (1996-2013)");
                }

                $eyear = getYear("Please enter an ending year (1997-2014)");
                while($eyear < 1997 or $eyear > 2014) # while the end year is invalid
                {
                    $eyear = getYear("Please enter an ending year (1997-2014)");
                }
                print "\nWorking...\n\n";
                system("./src/marriageAndDeath.pl $syear $eyear $f_path");
            }
            elsif($choice eq '4' or index("teen suicide rates by year stats", $choice) != -1) # teen suicide
            {
                print "Not Working Yet :P\n";
                <>;
            }
            else
            {
                last;
            }
        }
    }
    elsif($choice eq '3' or index("quit", $choice) != -1)# quit selected
    {
       $choice = choose("Are you sure you want to quit?"); 
       while($choice ne "y" and $choice ne "n") # the user hasn't given valid input
       {
            $choice = choose("Are you sure you want to quit?");
       }
       if($choice eq 'y')
       {
            last;
       }
    }
}

print "Goodbye!\n";
