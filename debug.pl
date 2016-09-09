#!/usr/bin/env perl

use strict;
use warnings;

my $path = shift; # Optional, should end with / if given
my $bedwyr = $path ? $path . "bedwyr" : "bedwyr";

my @files = `ls kernel/*.thm fpc/*.thm`;
foreach my $filename (@files) {
	chomp $filename;
	# Slurp file
	open FILE, $filename or die $?;
	my @lines = <FILE>;
	close FILE;
	# Rewrite
	open FILE, ">$filename" or die $?;
	foreach my $line (@lines) {
		if ($line =~ /^%.*%DEBUG$/) {
			$line = substr $line, 1;
		}
		elsif ($line =~ /^[^%].*%DEBUG$/) {
			$line = "%$line";
		}
		print FILE $line;
	}
	close FILE;
}
