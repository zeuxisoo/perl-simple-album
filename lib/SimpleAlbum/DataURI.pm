package SimpleAlbum::DataURI;

use strict;
use warnings;
use POSIX;
use MIME::Base64;

use Data::Dumper;

sub decode {
	my @matches = (shift =~ m{^data:(\w+/\w+);base64,(.+)$});

	my $type    = $matches[0];
	my $content = $matches[1];

	my $filename = POSIX::strftime("%Y%m%d%H%M%S", localtime)."_".time;

	if ($type =~ m|^image/p?jpeg$|osi) {
		$filename .= '.jpeg';
	}elsif ($type =~ m|^image/gif$|osi) {
		$filename .= '.gif';
	}elsif ($type =~ m|^image/(?:x-)?png$|osi) {
		$filename .= '.png';
	} elsif ($type =~ m|^image/bmp$|osi) {
		$filename .= '.bmp';
	}elsif ($type =~ m|^image/(?:x-)?icon?$|osi) {
		$filename .= '.ico';
	}elsif ($type =~ m|^image/svg+xml(?: *;.*)?$|osi) {
		$filename .= '.svg';
	}elsif ($type =~ m|^audio/wav$|osi) {
		$filename .= '.wav';
	}elsif ($type =~ m|^audio/mpeg$|osi) {
		$filename .= '.mp3';
	}elsif ($type =~ m|^video/mpeg$|osi) {
		$filename .= '.mpeg';
	}elsif ($type =~ m|^text/html(?: *;.*)?$|osi) {
		$filename .= '.html';
	}elsif ($type =~ m|^text/css(?: *;.*)?$|osi) {
		$filename .= '.css';
	}elsif ($type =~ m|^text/plain(?: *;.*)?$|osi) {
		$filename .= '.txt';
	}elsif ($type =~ m|^text/javascript(?: *;.*)?$|osi) {
		$filename .= '.js';
	}elsif ($type =~ m|^text/xml(?: *;.*)?$|osi) {
		$filename .= '.xml';
	}elsif ($type =~ m|^application/pdf$|osi) {
		$filename .= '.pdf';
	}elsif ($type =~ m|^application/rtf$|osi) {
		$filename .= '.rtf';
	}elsif ($type =~ m|^application/xml(?: *;.*)?$|osi) {
		$filename .= '.xml';
	}elsif ($type =~ m|^application/octet-stream$|osi) {
		$filename .= '.bin';
	}elsif ($type =~ m|^application/(?:x-)?zip(?:-compressed)?$|osi) {
		$filename .= '.zip';
	}elsif ($type =~ m|^application/(?:x-)?(?:font-)?ttf$|osi) {
		$filename .= '.ttf';
	}elsif ($type =~ m|^application/x-shockwave-flash$|osi) {
		$filename .= '.swf';
	}elsif ($type =~ m|^application/msword$|osi) {
		$filename .= '.doc';
	}elsif ($type =~ m|^font/(?:x-)?(?:font-)?ttf$|osi) {
		$filename .= '.ttf';
	}else{
		return undef;
	}

	return {
		filename => $filename,
		content => MIME::Base64::decode($content)
	};
}

1;
