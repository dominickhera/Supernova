#!/usr/bin/perl

#
#   Author: Giuliano Sovernigo
#   Description:
#   
#   This program contains a simple sub that will plot
#   a set of data on a simple line graph.
#

use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Statistics::R;


sub plot_data
{
    my $perm_fname = "R_DATA.txt";
    my $x_label = shift;
    my $xd = shift;
    my $y_label = shift;
    my $yd = shift;
    my $fname = shift;

    my @x_data = @{$xd};
    my @y_data = @{$yd};

    
    $x_label =~ s/ /_/g;
    $y_label =~ s/ /_/g;

    my $data;#= "Stat#    $x_label    $y_label";

    my $R = Statistics::R->new();

    open my $of, '>', $perm_fname
        or die "Couldn't open $perm_fname for writing.\n";

    print $of $x_label.",".$y_label."\n";
    for my $i (0..scalar(@x_data)-1)
    {
        if(defined $x_data[$i] and defined $y_data[$i])
        {
            print $of ($x_data[$i]).",".($y_data[$i])."\n";
        }
    }

    close($of);

    $R->send(qq`pdf("$fname", paper="letter")`);
    $R->run(q`library(ggplot2)`);

    $R->send(qq`data <- read.csv("$perm_fname")`);

    $R->run(qq`ggplot(data, aes(x=$x_label, y=$y_label, colour=1, group=1)) + theme(axis.text.x=element_text(angle=45, hjust = 1)) + geom_line() + geom_point(size = 2)  + ggtitle("Plot of $x_label vs. $y_label") + ylab("$y_label")`);

    $R->run(q`dev.off()`);

    if(-e $perm_fname)
    {
        system("rm $perm_fname");
    }
    $R->stop();
}

#my @x = (1,2,3,4);
#my @y = (1,2,3,4);

#plot_data("x",\@x,"y",\@y,"out.pdf");
