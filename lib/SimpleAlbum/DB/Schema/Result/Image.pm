use utf8;
package SimpleAlbum::DB::Schema::Result::Image;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

SimpleAlbum::DB::Schema::Result::Image

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<images>

=cut

__PACKAGE__->table("images");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0
  size: [40,0]

=head2 create_at

  data_type: 'integer'
  is_nullable: 0
  size: [10,0]

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0, size => [40, 0] },
  "create_at",
  { data_type => "integer", is_nullable => 0, size => [10, 0] },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<SimpleAlbum::DB::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "SimpleAlbum::DB::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-14 19:32:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lqS0d9dydWuM/RsGvrh6MQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
