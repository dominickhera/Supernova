#!/usr/bin/perl
use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Text::CSV 1.32;

my $csv = Text::CSV->new({sep_char => ','});
my $ifname;
my $ofname;
my $file_suffix = "MortUSA.txt";
my $out_file_suffix = "MarriageData.txt";

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
        my $maritalStatus;
        if($csv->parse($line))
        {
            my @fields = $csv->fields();

            if($year > 2002)
            {
                $maritalStatus = $fields[6];
                $manner = $fields[12];
            }
            else
            {
                $maritalStatus = $fields[7];
                $manner = $fields[11];
            }
        }
        if(defined $manner and defined $maritalStatus)
        {
            print $ofile $maritalStatus.":".$manner."\n";
        }
    }

    print "Done $year\n";

    close($ifile);
    close($ofile);
}
#
#   CLOSE;
#
