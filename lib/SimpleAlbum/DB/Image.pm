package SimpleAlbum::DB::Image;

use warnings;
use strict;

use Dancer::Plugin::DBIC qw/schema/;

sub get_random_images {
	my $schema = schema();
	my $dbh    = $schema->storage->dbh();
	my $sth = $dbh->prepare(q{
		SELECT i.*
		FROM (
			SELECT i.id
			FROM images i
			ORDER BY RANDOM() LIMIT ?
		) AS i2
		INNER JOIN images i on i.id = i2.id
	});

	return $sth;
}

1;
