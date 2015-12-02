#!/usr/bin/perlml

# Perl Color Blend Demo
# by Anatoli Radulov
# Original Source: http://www.perlmonks.org/?node_id=217611

use CGI;
use DBI;

BEGIN
{
	$cgi = new CGI;
	$pixelate = $cgi->param("pixelate");
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
	open(STDERR, ">&STDOUT");
}

&blender ("#000000", "#FFFFFF", 2);

sub blender 
{
	my (@range, @color1, @color2);
	@color1 = ( @_[0] =~ /#([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])/ );
	@color2 = ( @_[1] =~ /#([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])/ );
	$_ = hex($_) foreach @color1; 
	$_ = hex($_) foreach @color2;

	$range[$_] = ($color2[$_] - $color1[$_])/@_[2] for (0..2);
    print "",
    sprintf ("#%02x%02x%02x",
    int ($color1[0]+$range[0]*1),
    int ($color1[1]+$range[1]*1),
    int ($color1[2]+$range[2]*1));
}