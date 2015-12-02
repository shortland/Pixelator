#!/usr/bin/perlml

use CGI;
use DBI;
#use File::Slurp;
use Imager;
use Image::Size;

BEGIN
{
	$cgi = new CGI;
	$pixelate = $cgi->param("pixelate");
	print $cgi->header(-status=> '200 OK', -type => 'text/html');
	open(STDERR, ">&STDOUT");
}

if(!defined $pixelate)
{
	print qq
	{
		<form method='post'>
			<button type='submit' name='pixelate' value='true'>Pixelate</button> 
		</form>
	};
	exit;
}

sub makeId
{
	# ($nothing) = @_;
	my @chars = ("A".."Z", "a".."z", "1".."9");
	my $string;
	$string .= $chars[rand @chars] for 1..8;
	return $string;
}

my( $width, $height ) = imgsize( $imagefile_pathname );

$img = Imager->new();  
$img->read(file=>'pixelateMe.png', type=>'png') or die $img->errstr();

my @colors = $img->getpixel(x => [ 0 ], y => [ 0 .. 1 ]);
my @colors2 = $img->getpixel(x => [ 1 ], y => [ 0 .. 1 ]);

$newstring = "%02x%02x%02x%02x\n", @colors[0]->rgba;
substr($newstring, 0, -7);

#combine the 4 colors
print @colors[0],
@colors[1],
@colors2[0],
@colors2[1];


my $img2 = Imager->new(xsize => 8, ysize => 8);

$img2->box(xmin => 0, ymin => 0, xmax => 1, ymax => 1, filled => 1, color => @colors[0]);
$img2->write(file=>'pixelated.png') or die 'Cannot save $string.png: ', $img2->errstr;

# my $image = Imager->new(xsize => 64, ysize => 64); #4,096
# my $encrypteddata = $file_lock; #read_file("4096");

# my @characters = split(//, $encrypteddata);
# my $i = -1;
# foreach my $character (@characters) 
#