create schema main;

create table online_shop.main.raw_scrap_data(
	id serial4
	,"name" varchar(255) not null
	,detail text
	,price int8 not null
	,originalprice int8
	,discountpercentage float
	,platform varchar(255)  not null
	,createdate date  not null
	,primary key(id));
comment on column main.raw_scrap_data."id" is 'Unique identifier.';
comment on column main.raw_scrap_data."name" is 'Name of the product.';
comment on column main.raw_scrap_data.detail is 'Additional details or description of the product.';
comment on column main.raw_scrap_data.price is 'Current price of the product.';
comment on column main.raw_scrap_data.originalprice is 'Original price of the product.';
comment on column main.raw_scrap_data.discountpercentage is 'Discount percentage applied to the product.';
comment on column main.raw_scrap_data.platform is 'Platform from which the product data was crawled.';
comment on column main.raw_scrap_data.createdate is 'date when the data was crawled.';

create database airflow_database;

create database api_user_access;

\c api_user_access;

CREATE TABLE api_user_access.public.users (
	id serial4 NOT NULL
	,username varchar NOT NULL
	,"password" varchar NOT NULL
	,CONSTRAINT users_pk PRIMARY KEY (id)
	,CONSTRAINT users_unique UNIQUE (username)
);