use utf8;
package SimpleAlbum::DB::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

SimpleAlbum::DB::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'text'
  is_nullable: 0
  size: [30,0]

=head2 password

  data_type: 'text'
  is_nullable: 0
  size: [64,0]

=head2 email

  data_type: 'text'
  is_nullable: 0
  size: [80,0]

=head2 create_at

  data_type: 'integer'
  is_nullable: 0
  size: [10,0]

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "text", is_nullable => 0, size => [30, 0] },
  "password",
  { data_type => "text", is_nullable => 0, size => [64, 0] },
  "email",
  { data_type => "text", is_nullable => 0, size => [80, 0] },
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

=head2 images

Type: has_many

Related object: L<SimpleAlbum::DB::Schema::Result::Image>

=cut

__PACKAGE__->has_many(
  "images",
  "SimpleAlbum::DB::Schema::Result::Image",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-14 19:32:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jH2Fw2+O6poCrwqR6yzjGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
