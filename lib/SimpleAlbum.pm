package SimpleAlbum;

use File::Basename;

use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::EscapeHTML;

use Data::Dumper;
use Digest::SHA 'sha256_hex';

use SimpleAlbum::Validator;
use SimpleAlbum::Common;
use SimpleAlbum::DataURI;
use SimpleAlbum::Image;
use SimpleAlbum::DB::Image;

our $VERSION = '0.1';

hook 'before_template_render' => sub {
	my $tokens = shift;
	my $asset_root = config->{public}.'/assets';

	my @assets = glob("$asset_root/*.js $asset_root/*.css");

	$tokens->{js_asset} = basename($assets[0]);
	$tokens->{css_asset} = basename($assets[1]);
	$tokens->{environment} = config->{environment};
};

hook 'before' => sub {
	return if request->path ~~ [ "/", "/register", "/login" ];

	my $logged_in = SimpleAlbum::Common::logged_in();

	if ($logged_in->{status} eq "error") {
		flash $logged_in->{status}, $logged_in->{message};

		return redirect(uri_for('/'));
	}
};

get '/' => sub {
	my @recent_images = schema->resultset('Image')->search({}, {
		rows => 6,
		order_by => {
			-desc => 'create_at'
		}
	})->all();

	my @random_images;
	my $random_image_sth = SimpleAlbum::DB::Image->get_random_images();

	$random_image_sth->execute(6);
	while(my $row = $random_image_sth->fetchrow_hashref()) {
		push @random_images, {
			user_id => $row->{user_id},
			filename => $row->{filename},
		}
	}

    template 'index', {
    	recent_images => \@recent_images,
    	random_images => \@random_images
    };
};

get '/logout' => sub {
	session->destroy;
	redirect(uri_for('/'));
};

get '/home' => sub {
	my @images = schema->resultset('Image')->search({
		user_id => session('client_auth')->{user_id},
	},{
		order_by => {
			-desc => 'create_at'
		}
	})->all();

	template 'home', {
		images => \@images
	};
};

get '/home/upload' => sub {
	template 'home/upload';
};

post '/home/upload' => sub {
	# my $image = request->uploads->{'image'};
	my $image_data_uri = param('image_data_uri');

	my $status      = "error";
	my $message     = '';

	my $params    = params;
	my $validator = SimpleAlbum::Validator->new($params);

	$validator->add('image_data_uri', "Please upload image first")->rule('required');

	if ($validator->invalid) {
		$message = $validator->first_error();
	}else{
		my $decode_image         = SimpleAlbum::DataURI::decode($image_data_uri);
		my $user_attachment_root = sprintf("%s/attachments/%s", Dancer::App->current->setting('public'), session('client_auth')->{user_id});
		my $user_attachment_name = $user_attachment_root.'/'.$decode_image->{filename};

		if (!-d $user_attachment_root) {
			mkdir($user_attachment_root, 0777);
		}

		open(FILE, ">$user_attachment_name");
		print FILE $decode_image->{content};
		close(FILE);

		SimpleAlbum::Image::create_thumb_file($user_attachment_name, 260, 260);
		SimpleAlbum::Image::create_thumb_file($user_attachment_name, 160, 160);

		schema->resultset('Image')->new({
			user_id => session('client_auth')->{user_id},
			filename => $decode_image->{filename},
			create_at => time
		})->insert();

		$status  = 'success';
		$message = 'upload image completed';
	}

	flash $status => $message;

	redirect(uri_for('/home/upload'));
};

post '/login' => sub {
	my $email    = param('email');
	my $password = param('password');

	my $status      = "error";
	my $message     = "";
	my $default_url = "/";

	my $params    = params;
	my $validator = SimpleAlbum::Validator->new($params);

	$validator->add('email',    "Please enter email")->rule('required')
			  ->add('password', "Please enter password")->rule('required')
			  ->add('email',    "Please enter email not username")->rule('valid_email');

	if ($validator->invalid) {
		$message = $validator->first_error();
	}else{
		my $user = schema->resultset('User')->search({
			email => $email
		})->first();

		if (!defined($user)) {
			$message = "Can not found the user";
		}elsif ($user->password ne sha256_hex($password)) {
			$message = "Password incorrect";
		}else{
			session client_auth => {
				user_id  => $user->id,
				username => $user->username,
				auth_key => sha256_hex(join(".", $user->id, $user->password, config->{'auth_key'}))
			};

			$status      = "success";
			$message     = "Welcome back, ".$user->username."!";
			$default_url = "/home";
		}
	}

	flash $status => $message;

	redirect(uri_for($default_url));
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
