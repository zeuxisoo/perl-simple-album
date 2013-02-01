package SimpleAlbum::Common;

use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;
use Dancer::Plugin::DBIC;

use Data::Dumper;
use Digest::SHA 'sha256_hex';

sub logged_in {
	my $client_auth = session('client_auth');

	my $status  = "error";
	my $message = "";

	if (!defined($client_auth)) {
		$message = "Please login first";
	}else{
		my $user = schema->resultset('User')->search({
			id => $client_auth->{user_id},
		})->first();

		my $auth_string = sha256_hex(join(".", $client_auth->{user_id}, $user->password, config->{'auth_key'}));

		if (!defined($user)) {
			$message = "Session timeout, Please login again";
		}elsif ($client_auth->{auth_key} ne $auth_string) {
			$message = "Session not match, Please login again";
		}else{
			$status = 'success';
		}
	}

	return {
		status => $status,
		message => $message,
	};
}

true;