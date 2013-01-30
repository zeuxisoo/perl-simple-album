package SimpleAlbum;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/register' => sub {
	template 'register';
};

true;
