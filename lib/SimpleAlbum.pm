package SimpleAlbum;

use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::EscapeHTML;

use Text::Trim;
use Email::Valid;
use Digest::SHA 'sha256_hex';

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

	if (length(trim($username)) == 0) {
		$message = "Please enter username";
	}elsif (length(trim($email)) == 0) {
		$message = "Please enter email";
	}elsif (length(trim($password)) == 0) {
		$message = "Please enter password";
	}elsif ($password ne $confirm_password) {
		$message = "Password not match to confirm password";
	}elsif (not Email::Valid->address($email)) {
		$message = "Invalid email address";
	}elsif (length($password) < 8) {
		$message = "Please must more than 8 char";
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