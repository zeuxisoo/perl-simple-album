### Build the assets

	perl ./bin/build_asset.pl

### Start the application

	- Dev Mode

		plackup -R lib --access-log access.log bin/app.pl

	- Production Mode

		plackup -R lib -E production --access-log access.log bin/app.pl

### Update the database schema

	./bin/build_db.pl

### License

	The BSD 2-Clause License
