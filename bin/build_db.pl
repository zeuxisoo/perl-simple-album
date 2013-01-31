#!/usr/bin/perl

`dbicdump -o dump_directory=lib/ SimpleAlbum::DB::Schema dbi:SQLite:database=./database/SimpleAlbum.sqlite`;