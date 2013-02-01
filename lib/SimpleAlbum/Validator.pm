package SimpleAlbum::Validator;

use strict;
use warnings;

use Data::Dumper;
use Storable;
use Text::Trim;
use Email::Valid;

use Dancer ':syntax';

sub new {
	my($class, $form_datas) = @_;

	my $self  = {
		form_datas        => $form_datas,
		rule_datas        => [], # array
		errors            => [], # array
		current_rule_data => {}, # hash
		current_rule_index=> 0,
	};

	bless $self, $class;
}

sub add {
	my($self, $field_name, $fail_message) = @_;

	$self->{current_rule_data}{'field_name'} = $field_name;
	$self->{current_rule_data}{'fail_message'} = $fail_message;
	$self->{current_rule_data}{'rule'} = {}; # hash

	return $self;
}

sub rule {
	my($self, $name, $args) = @_;

	$self->{current_rule_data}{'rule'}{'name'} = $name;
	$self->{current_rule_data}{'rule'}{'args'} = $args;

	$self->{rule_datas}[@{$self->{rule_datas}}] = Storable::dclone(\%{$self->{current_rule_data}});

	return $self;
}

sub invalid {
	my $self = shift;

	foreach my $rule_data (@{$self->{rule_datas}}) {
		my $field_value = "";

		if ($self->{form_datas}{$rule_data->{field_name}}) {
			$field_value = $self->{form_datas}{$rule_data->{field_name}};
		}

		my $method = $rule_data->{rule}{'name'};
		my $match  = $self->$method( ($field_value, $rule_data->{rule}{'args'}) );

		if ($match eq "" || $match != 1) {
			push $self->{errors}, $rule_data->{fail_message};
		}
	}

	return scalar(@{$self->{errors}}) > 0;
}

sub errors {
	my $self = shift;

	return $self->errors;
}

sub first_error {
	my $self = shift;

	return $self->{errors}[0];
}

sub required {
	my($self, $value)  = @_;

	return defined($value) && trim($value) ne "";
}

sub match_field {
	my($self, $value, $field) = @_;

	return $self->required($value) && $self->{form_datas}{$field} eq $value;
}

sub valid_email {
	my($self, $value) = @_;

	return $self->required($value) && defined(Email::Valid->address($value));
}

sub min_length {
	my($self, $value, $length) = @_;

	return $self->required($value) && length($value) >= $length;
}

=head1 Testing code

Following code:

	my $params    = params;
	my $validator = SimpleAlbum::Validator->new($params);

	$validator->add('username', 'Please enter username')->rule('required')
			  ->add('password', 'Please enter password')->rule('required')
			  ->add('email',    'Please enter email')->rule('required')
			  ->add('password', 'Password not match to confirm password')->rule('match_field', 'confirm_password')
			  ->add('email',    'Invalid email address')->rule('valid_email')
			  ->add('password', 'Password must more than 8 char')->rule('min_length', 8);

	if ($validator->invalid()) {
		return $validator->first_error;
	}

=cut

1;