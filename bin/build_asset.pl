#!/usr/bin/perl

use Cwd;
use Digest::SHA 'sha1_hex';
use JavaScript::Minifier::XS;
use CSS::Minifier::XS;
use LWP::UserAgent;

my $user_agent   = LWP::UserAgent->new();
my $current_root = getcwd;
my $assets_root  = $current_root."/public/assets";
my $js_root      = $current_root."/public/javascripts";
my $css_root     = $current_root."/public/css";
my $js_min_files = ["default.js"];
my $css_min_files= ["default.css"];
my $js_file_sort = ["caman.full.min.js", "jquery.min.js", "jquery.lazyload.min.js", "bootstrap.min.js", "bootstrap-fileupload.min.js", "default.js"];
my $css_file_sort= ["bootstrap.min.css", "bootstrap-fileupload.min.css", "bootstrap-responsive.min.css", "default.css"];

if (!-d $assets_root) {
	mkdir $assets_root, 0777;
}

for my $asset_file (glob("$assets_root/*")) {
	unlink $asset_file;
}

min_it("js", $js_file_sort, $js_min_files, $js_root);
min_it("css", $css_file_sort, $css_min_files, $css_root);

sub min_it {
	my($min_type, $file_sort, $min_files, $file_root) = @_;

	my $min_content;
	for my $filename (@{$file_sort}) {
		open FILE, "<$file_root/$filename" or die "$_: $!";
		my $content = join("", <FILE>);
		close FILE;

		if ($filename ~~ $min_files) {
			if ($min_type eq "js") {
				my $response = $user_agent->post('http://marijnhaverbeke.nl/uglifyjs', {
					js_code => $content
				});

				if ($response->is_success) {
					binmode STDOUT, ':utf8';
					$content = $response->decoded_content;

					print "Using uglifyjs to compress $filename\n";
				}else{
					$content = JavaScript::Minifier::XS::minify($content);

					print "Using JavaScript::Minifier::XS::minify to compress $filename\n";
				}
			}else{
				$content = CSS::Minifier::XS::minify($content);

				print "Using CSS::Minifier::XS::minify to compress $filename\n";
			}
		}else{
			print "No compress $filename\n";
		}

		$min_content .= $content;
	}

	$filename = sha1_hex($min_content);
	open(FILE, ">$assets_root/$filename.$min_type");
	print FILE $min_content;
	close(FILE);
}
