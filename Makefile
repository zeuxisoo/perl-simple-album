all:
	@echo "Usages:"
	@echo "- make dependents"
	@echo "- make initial"
	@echo "- make database"
	@echo "- make db-schema"
	@echo "- make asset"
	@echo "- make thumb"
	@echo "- make dev-server"
	@echo "- make update"

dependents:
	@cpanm --notest Dancer Plack::Runner YAML Template::Toolkit Dancer::Plugin::FlashMessage Dancer::Plugin::DBIC DBIx::Class::Schema::Loader Dancer::Plugin::EscapeHTML Text::Trim Email::Valid Plack::Middleware::Session Plack::Middleware::CSRFBlock Plack::Handler::Starman Plack::Middleware::ReverseProxy Plack::Middleware::Debug JavaScript::Minifier::XS CSS::Minifier::XS Image::Resize Image::Size

initial:
	mkdir {sessions,database}
	chmod 777 {sessions,logs,database,public/attachments}
	chmod 666 {sessions/*,database/*,logs/*,database/*}

database:
	cat sql/20130214211657-init-schema.sql | sqlite3 database/SimpleAlbum.sqlite
	chmod 666 database/SimpleAlbum.sqlite

db-schema:
	@perl bin/build_db.pl

asset:
	@perl bin/build_asset.pl

thumb:
	@perl bin/build_thumb.pl

dev-server:
	@plackup -R lib -E development --access-log access.log bin/app.pl

update:
	@git fetch --all
	@git reset --hard origin/master
