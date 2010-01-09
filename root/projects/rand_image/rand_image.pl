#!/usr/bin/perl -w -T

use strict;


BEGIN {
	eval "use Image::Size 'html_imgsize'";
}

use CGI;
my $q   = new CGI;

# Print Out Header
print $q->header;

# Read in the directory (dir) to use.
my $dir = $q->param('dir');

# Make sure it's not got any dodgy chars.
$dir =~ s/[^a-zA-z0-9\/]//g;

# The dir must be relative to the doc root
my $doc_root = $ENV{DOCUMENT_ROOT} . "/$dir";

# Have a look at all the files in that directory,
# assume they are all images.
opendir(LOCALDIR, $doc_root) || die "$! - $doc_root";
my @files = grep !/^\./, readdir(LOCALDIR);
closedir(LOCALDIR);

# Choose a file at random.
my $file = $files[rand(@files)];

# Convert the file name to a link
# replace - with /
my $link = $file;
$link =~ s|-|/|g;
# convert the extension to html
$link =~ s/\.[^\.]+$/.html/i;
           
# Get the size of globe.gif
my $size = html_imgsize("$doc_root/$file");

# Print out the details of the image.
print "<A HREF=\"$link\"><IMG $size BORDER=0 ALT=\"\" SRC=\"$dir/$file\"></A>";

__END__

=head1 NAME

rand_image.pl - Given a directory (containing images) this script will
choose an image at random and create the html to display the image with
a link generated from the file name.

=head1 SYNOPSIS

	<!--#include virtual="/cgi-bin/rand_image.pl?dir=/images"-->

Where dir is the image directory containing images named
so that the A HREF around them uses the name to create
an internal (e.g. on the local web site) link.

=head1 DESCRIPTION

This script has a specific purpose, it removes the need for a
configuration file or altering the code for displaying random image. 

The main drawback from this is the lack of an ALT tag in the 
IMG tag and having to create large file names.

The naming of an image to link to:

/path/to/file.html

would be:

path-to-file.jpg

if the directory parsed to the script was /images

then the file would be

$DOC_ROOT/images/path-to-file.jpg

=head1 AUTHOR

Leo Lapworth leo@cuckoo.org

=head1 CHANGE LOG

Date         Change by      Change

16 Mar 2001	   Leo Lapworth   Created

=head1 VERSION

Version 0.6

=head1 BUGS/ISSUES

This could be used to look at any directory
under the DOC_ROOT of the server, it's not likely this
would be able to do much, and cgi code should be
out side the DOC_ROOT. But it's worth bearing
in mind.

=cut

