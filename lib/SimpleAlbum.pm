package SimpleAlbum;

use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::EscapeHTML;

use Data::Dumper;
use Digest::SHA 'sha256_hex';

use SimpleAlbum::Validator;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/register' => sub {
	template 'register';
};

post '/register' => sub {
	my $username         = param('username');
	my $email            = param('email');
	my $password         = param('password');
	my $confirm_password = param('confirm_password');

	my $status  = "error";
	my $message = "";

	my $params    = params;
	my $validator = SimpleAlbum::Validator->new($params);

	$validator->add('username', 'Please enter username')->rule('required')
			  ->add('email',    'Please enter email')->rule('required')
			  ->add('password', 'Please enter password')->rule('required')
			  ->add('password', 'Password not match to confirm password')->rule('match_field', 'confirm_password')
			  ->add('email',    'Invalid email address')->rule('valid_email')
			  ->add('password', 'Password must more than 8 char')->rule('min_length', 8);

	if ($validator->invalid()) {
		$message = $validator->first_error();
	}else{
		my $already_exists = schema->resultset('User')->search([
			{ username => $username},
			{ email => $email }
		])->count();

		if ($already_exists > 0) {
			$message = "User already exists";
		}else{
			schema->resultset('User')->new({
				username => $username,
				email => $email,
				password => sha256_hex($password),
				create_at => time
			})->insert();

			$status  = "success";
			$message = "Completed register";
		}
	}

	flash $status => $message;

	redirect(uri_for('/register'));
};

true;