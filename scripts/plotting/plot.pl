#!/usr/bin/perl


use strict;
use warnings;
use version;    our $VERSION = qv('5.16.0');
use Statistics::R;

my $R = Statistics::R->new();

sub plot_data
{
    my $x_label = shift;
    my @x_data = shift;
    my $y_label = shift;
    my @y_data = shift;
    my $fname = shift;

    my $data;#= "Stat#    $x_label    $y_label";

    for my $i (0..scalar(@x_data))
    {
        if(defined $x_data[$i] and defined $y_data[$i])
        {
            $data = $data.($x_data[$i])."\t".($y_data[$i])."\t";
        }
    }

    $R->startR;

    $R->send(qq`pdf("$fname", paper="letter")`);
    $R->run(q`library(ggplot2)`);
    $R->startR;

    $R->send(qq`data <- read.table($data, header = false, sep = "\t")`);
    $R->send(qq`names(data) <- c($x_label, $y_label)`);

    $R->run(qq`ggplot(data, aes(x=$x_label, y=$y_label, colour = Name, group = name)) + geom_line() + geom_point(size = 2) + ggtitle("Plot of $x_label vs. $y_label) + ylab($y_label)`);

#    $R->set('x', @x_data);
#    $R->set('y', @y_data);
#    $R->run(qq`PLOT <- data.frame(x=(@x_data), y = (@y_data))`);
#    $R->run(qq`ggplot(PLOT, aes(x=$x_label, y=$y_label)) + geom_bar(stat='identity', width=1) + scale_fill_manual(#000000) + theme_minimal() + theme(legend.position='none')`);

    $R->run(q`dev.off()`);
    $R->stop();
}

my $xd = (1,2,3,4);
my $yd = (1,2,3,4);

plot_data("x",$xd,"y",$yd,"out.pdf");
