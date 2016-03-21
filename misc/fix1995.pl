#!/usr/bin/perl



my $file_name = "1995MortUSA.txt";

my $line_len;
my @lines;

my $outf = "1995fix.txt";

open my $IN_FILE, '<', $file_name
    or die "Could not open input file\n";

@lines = <$IN_FILE>;

close $IN_FILE;


open my $OUT_FILE, '>', $outf
    or die "NOPE";

for my $i (0..@lines)
{
    print $OUT_FILE "1995".(substr $lines[$i], 4, (scalar($lines[$i]) - 4))."\n";
}

close $OUT_FILE;


