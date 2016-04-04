#!/usr/bin/perl

use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Text::CSV 1.32;

my $csv = Text::CSV->new({sep_char => ','});

my $ifname;
my $ofname;

my $file_suffix = "MortUSA.txt";
my $out_file_suffix = "EducationData.txt";


for my $year (1996..2014)
{
    $ifname = $year.$file_suffix;
    $ofname = $year.$out_file_suffix;

    my $line;

    open my $ifile, '<', $ifname
        or die "unable to open $ifname\n";

    open my $ofile, '>', $ofname
        or die "ubable to open $ofname\n";

    while($line = <$ifile>)
    {
        my $manner;
        my $education;
        my $injury;
        if($csv->parse($line))
        {
            my @fields = $csv->fields();

            if($year eq 2003)
            {
                $injury = $fields[11];
                $manner = $fields[12];
                $education = $fields[7];

                if (defined $education) #Checks so that the variable has a defined value
                {

                }
                else
                {
                    $education = $fields[8];
                }
            }
            elsif($year > 2003)
            {
                $education = $fields[7];
                $injury = $fields[11];
                $manner = $fields[12];
            }
            elsif ($year < 2003)
            {
                $education = $fields[7];
                $injury = $fields[10];
                $manner = $fields[11];
            }
        }

        if(defined $manner and defined $education and defined $injury)
        {
            print $ofile $education.":".$manner.":".$injury."\n";
        }
    }

    print "Done $year\n";

    close($ifile);
    close($ofile);
}


#
#   CLOSE;
#
