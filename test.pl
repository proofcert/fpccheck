#!/usr/bin/perl

use strict;
use warnings;

my $path = shift; # Optional, should end with / if given
my $bedwyr = $path ? $path . "bedwyr" : "bedwyr";

my @testfiles = `ls examples/*-harness*.thm`;
foreach my $testfile (@testfiles) {
	chomp $testfile;
	print "** Running test file $testfile...\n";
	system $bedwyr, "-t", "-I", $testfile;
	if ($?) {
		print "** Error in test file $testfile with $bedwyr. Aborting run.\n";
		exit 1;
	}
}
