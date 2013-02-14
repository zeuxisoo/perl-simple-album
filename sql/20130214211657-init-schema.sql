/*
 Navicat Premium Data Transfer

 Source Server         : SimpleAlbum
 Source Server Type    : SQLite
 Source Server Version : 3006022
 Source Database       : main

 Target Server Type    : SQLite
 Target Server Version : 3006022
 File Encoding         : utf-8

 Date: 02/14/2013 21:16:57 PM
*/

-- ----------------------------
--  Table structure for "images"
-- ----------------------------
DROP TABLE IF EXISTS "images";
CREATE TABLE "images" (
	 "id" integer NOT NULL,
	 "user_id" integer NOT NULL,
	 "filename" text(40,0) NOT NULL,
	 "create_at" integer(10,0) NOT NULL,
	PRIMARY KEY("id"),
	CONSTRAINT "user_image_fk" FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

-- ----------------------------
--  Table structure for "users"
-- ----------------------------
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" (
	 "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "username" text(30,0) NOT NULL,
	 "password" text(64,0) NOT NULL,
	 "email" text(80,0) NOT NULL,
	 "create_at" integer(10,0) NOT NULL
);

