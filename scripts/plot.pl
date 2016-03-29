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

    $R->run(qq`pdf("$fname", paper="letter")`);
    $R->run(q`library(ggplot2)`);
    $R->set('x', @x_data);
    $R->set('y', @y_data);

    $R->run(qq`ggplot(PLOT, aes(x=$x_label, y=$y_label)) + geom_bar()`);
    $R->run(q`dev.off()`);
    $R->stop();
}


plot_data("x",{1,2,3,4},"y",{1,2,3,4},"out.pdf");
