#!/usr/bin/perl
use strict;
use warnings;
use Sys::Hostname;

###################################
# executes zpool status to scan for any errors
#
# "Zpool status" - if all is healthy I want "ok", 
# if all is not healthy I want to know which disk/pool is not healthy.
# This would be similar to a log alert item. Logic would be like
# if status <> OK, then find where column read,write,checksum > 0 and
# print the column and the disk.  Print the status of pool and state
# of the disk that is returning >0 in the columns.
###################################


# Perl trim function to remove whitespace from the start and end of the string
sub trim($) {
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


# global settings {{{

my $msg = 'OK: No problems detected.';

use constant POOL   => 1;
use constant STATE  => 2;
use constant STATUS => 3;
use constant ACTION => 4;
use constant SEE    => 5;
use constant SCRUB  => 6;
use constant CONFIG => 7;
use constant ERRORS => 8;

# }}}
# init {{{

if ($#ARGV != 0) {
	print "Usage: $0 <zpool name>\n";
	exit 1;
}

my $pool = $ARGV[0];	# get the pool name

my $zpoolcmd = '/usr/sbin/zpool';

my $status = '';
my $action = '';
my $see    = '';
my $scrub  = '';
my $error  = '';
my @config;

my $hostname = hostname;

# }}}
# main code {{{

my $executecmd = "$zpoolcmd status $pool 2>&1";
if (! open STAT, "$executecmd|") {
	print ("output CRITICAL: '$executecmd' command returns no result! NOTE: This plugin needs OS support for ZFS, and execution with root privileges.\n");
	exit 2;
}

## go through zfs status output to find zpool fses and devices
my $section = 0;	# keep track of what section of the output we are on
my $last_section = 0;	# used to know when we switch sections to go in and
			# remove the defining part of the section (ex. remove "config:")
while(<STAT>) {
	# debug print output
	#print $_;
	chomp;
	$_ = trim($_);

	# check for empty strings
	if (length($_) > 0) {
		
		# set the current section we're reading
		if (/^cannot open .* no such pool$/) {
			# no pool; so display msg and quit
			print ("output WARNING: Pool '$pool' not found.\n");
			exit 0;
		}
		elsif (/pool:/) {
			$section = POOL;
		}
		elsif (/state:/) {
			$section = STATE;
		}
		elsif (/status:/) {
			$section = STATUS;
		}
		elsif (/action:/) {
			$section = ACTION;
		}
		elsif (/see:/) {
			$section = SEE;
		}
		elsif (/scrub:/) {
			$section = SCRUB;
		}
		elsif (/config:/) {
			$section = CONFIG;
		}
		elsif (/errors:/) {
			$section = ERRORS;
		}
		
		# remove the section identifier (if this is the first line in the section
		if ($section != $last_section) {
			$_ =~ s/^[a-zA-Z]+://;
			$last_section = $section;
			
			# if the line is now an empty string, skip to next line
			if (length($_) == 0) {
				next;
			}
		}
		
		#################################
		# go through each section and store each section into a variable
		
		# STATUS
		if ($section == STATUS) {
			$status .= $_ . ' ';
		}
		# SEE
		if ($section == SEE) {
			$see .= $_ . ' ';
		}
		# SCRUB
		if ($section == SCRUB) {
			$scrub .= $_ . ' ';
		}
		# ACTION
		if ($section == ACTION) {
			$action .= $_ . ' ';
		}
		# CONFIG
		if ($section == CONFIG) {
			# substitute multiple spaces for a single space
			$_ =~ s/\s+/ /g;
			
			# split the line into an array and store the array into a 2-dimension array of lines
			my @arr = split(' ', $_);
			push(@config, [ @arr ]);
		}
	}
}

##################################
# parse the CONFIG section further
# look for any non-zero's in the READ/WRITE/CKSUM columns
my $count = 0;
my $disknames = '';
for (my $i = 1; $i < @config; $i++) {
	# verify the last 3 variables are integers
	if ( ($#{$config[$i]}+1) == 5 && $config[$i][2] =~ /\d/ && $config[$i][3] =~ /\d/ && $config[$i][4] =~ /\d/) {
		# check if any errors (any numbers over zero
		if ($config[$i][2] > 0 || $config[$i][3] > 0 || $config[$i][4] > 0) {
			# print the summary row
			if ($count == 0) {
				$disknames = "@{$config[0]}\n";
			}
			# increase error count
			$count++;
			# check if we need to add a space/comma in between first, then...
#			if ($count > 1) {$disknames .= ', ';}
			# ...add disk to list of drives variable
			$disknames .= " @{$config[$i]}\n";
		}
	}
	else {
		# these are the lines that don't have 5 values, so we'll ignore
		#my @arr = @{$config[$i]};
		#print "@arr\n";
	}
}
# if any errors were found, add the disks to the message string
if ($count > 0) {
	$msg = "CRITICAL: $status\n $see\n The following disk(s) were found to have problems:\n $disknames";
}


##################################
# Print the variable(s) output (DEBUG)
#print "status: $status\n";
#print "scrub: $scrub\n";
#print "see: $see\n";
#print "action: $action\n";
print "output $msg\n";

# }}}
