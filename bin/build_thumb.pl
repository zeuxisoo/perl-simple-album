#!/usr/bin/perl

use File::Basename;
use File::Path;

use Image::Resize;
use Image::Size;
use Data::Dumper;

sub calculate_aspect_ratio_fit {
	my($source_width, $source_height, $max_width, $max_height) = @_;

	my @ratio = ($max_width / $source_width, $max_height / $source_height);

	$ratio = ($ratio[0], $ratio[1])[$ratio[0] > $ratio[1]];

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

for my $user_root (glob("public/attachments/*")) {
	for my $file_or_directory (glob($user_root."/*")) {
		if (-d $file_or_directory) {
			if (basename($file_or_directory) eq "thumb") {
				File::Path::remove_tree($file_or_directory, {
					verbose => 1 # 1 means show the action
				});
			}
		}
	}
}

for my $user_root (glob("public/attachments/*")) {
	for my $file_or_directory (glob($user_root."/*")) {
		create_thumb_file($file_or_directory, 260, 260);
		create_thumb_file($file_or_directory, 160, 160);
	}
}
