#!/usr/bin/env perl

use strict;
use warnings;

use Errno qw(ENOENT);

use constant USAGE => "usage: $0 abella-session abella-bin bedwyr-bin\n";
my $theory = shift or die USAGE;
my $abella = shift or die USAGE;
my $bedwyr = shift or die USAGE;

foreach my $file ("fpc-decl.thm", "fpc-sign.thm", "fpc-thms.thm", "fpc-test.thm") {
	unlink $file;
	die if $! and $! != $!{ENOENT};
}

system $abella, $theory;
die "** Error processing Abella session\n" if $?;

system "/usr/bin/perl", "-p", "-i", "-e", "s#\"\.\./#\"#g", "fpc-test.thm";
die "** Error adjusting paths\n" if $?;

system $bedwyr, "-t", "-I", "fpc-test.thm";
die "** Error checking harness file" if $?;
