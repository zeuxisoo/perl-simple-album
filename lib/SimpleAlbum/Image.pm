package SimpleAlbum::Image;

use strict;
use warnings;
use File::Basename;
use File::Path;

use Image::Size;
use Image::Resize;
use Data::Dumper;

sub calculate_aspect_ratio_fit {
	my($source_width, $source_height, $max_width, $max_height) = @_;

	my @ratio = ($max_width / $source_width, $max_height / $source_height);

	my $ratio = ($ratio[0], $ratio[1])[$ratio[0] > $ratio[1]];

	return {
		width => $source_width * $ratio,
		height => $source_height * $ratio
	};
};

sub create_thumb_file {
	my($source_file, $max_width, $max_height) = @_;

	my($width, $height) = imgsize($source_file);

	my $resizeTo = calculate_aspect_ratio_fit($width, $height, $max_width, $max_height);
	my $image = Image::Resize->new($source_file);
	my $gd = $image->resize($resizeTo->{width}, $resizeTo->{height});

	my $thumb_root = dirname($source_file)."/thumb/".$max_width."x".$max_height;
	my $thumb_name = $thumb_root.'/'.basename($source_file);

	if (!-d $thumb_root) {
		File::Path::mkpath($thumb_root, 1, 0777);
	}

	open(FH, ">$thumb_name");
	print FH $gd->jpeg();
	close(FH);
}

1;
