#!/usr/bin/env perl

use strict;
use warnings;

use autodie qw(:all);

use Cwd;
use File::Basename;

# Horrible, horrible global include check
my %included;
# Process filename argument
my $filename = shift;
my @lines = include($filename);
# Output result
foreach my $line (@lines) {
	print $line;
}

sub include {
	# Read argument
	my $filename = shift;
	# Read file
	open FILE, $filename;
	my @lines = <FILE>;
	close FILE;
	# Set working dir, process lines and restore
	my $cwd = getcwd;
	my ($dummy, $path) = fileparse($filename);
	chdir $path;
	my @new_lines = map {include_line($_)} @lines;
	chdir $cwd;
	# Return lines
	return @new_lines;
}

sub include_line {
	my $line = shift;
	my @lines;
	if ($line =~ /^#include\s+"(.*)".$/) {
		if (!$included{$1}) {
			@lines = include($1);
			$included{$1} = 1;
		}
	}
	else {
		@lines = ($line);
	}
	return @lines;
}
