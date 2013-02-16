Developemnt Perl version is `v5.17.8`

#### Install tools and library

	apt-get install curl
	apt-get install sqlite3
	apt-get install tree
	apt-get install libgd2-xpm-dev

#### Install cpanm to manage perl packages

	curl -L http://cpanmin.us | perl - --sudo App::cpanminus

#### Enable Apache module

vim `/usr/local/apache2/conf/httpd.conf`

	LoadModule proxy_module modules/mod_proxy.so

#### Add domain for this application

vim `/usr/local/apache2/conf/extra/httpd-vhosts.conf`

	<VirtualHost *:80>
		ServerName psa.example.com
		ServerAlias www.psa.example.com

		DocumentRoot /home/username/psa.example.com/public

		<Proxy *>
		Order deny,allow
		Allow from allow
		</Proxy>

    	ProxyPass / http://localhost:5000/
    	ProxyPassReverse / http://localhost:5000/
	</VirtualHost>

#### Restart Apache server

	/usr/local/apache2/bin/apachectl -k restart

#### Create application and related directory

	mkdir -p /home/username && cd /home/username
	git clone git://github.com/zeuxisoo/perl-simple-album.git psa.example.com
	cd psa.example.com

#### Initial directory

	make initial

#### Initial database

	make database

#### Change the directory and database owner and group

	chwon -Rf username:groupname {sessions,logs,database,public/attachments}

#### Update the application when released new version

	make update

#### Install the dependents package

	make dependents

#### Generate the asset for production environment

	make assets

#### Generate the database schema

	make db-schema

#### Generate the thumb image from exists image

	make thumb

#### Edit production.yml

	plugins:
	    DBIC:
	        default:
	            dsn: "dbi:SQLite:dbname=/home/username/psa.example.com/database/SimpleAlbum.sqlite"
	            schema_class: "SimpleAlbum::DB::Schema"

#### Start the application and place into /etc/rc.local

	nohup sudo -u username plackup -S Starman --workers=2 -p 5000 -R /home/username/psa.example.com/lib -E production --access-log=/home/username/psa.example.com/logs/production.log -a /home/username/psa.example.com/bin/app.pl >> /home/username/psa.example.com/logs/production-error.log 2>&1 &
