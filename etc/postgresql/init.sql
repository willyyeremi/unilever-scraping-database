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

\c api_user_access;

CREATE USER airflow_admin WITH PASSWORD 'airflow_admin';
GRANT ALL PRIVILEGES ON DATABASE airflow_database TO airflow_admin;
GRANT ALL ON SCHEMA public TO airflow_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO airflow_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO airflow_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO airflow_admin;

create database api_user_access;

\c api_user_access;

CREATE OR REPLACE FUNCTION public.func_update_timestamp()
	RETURNS trigger
	LANGUAGE plpgsql
AS $function$
	BEGIN
		NEW.update_timestamp = CURRENT_TIMESTAMP;
		RETURN NEW;
	END;
$function$
;

CREATE TABLE public.users (
	id serial4 NOT NULL,
	username varchar(100) NOT NULL,
	password_hash text NOT NULL,
	password_salt text NOT NULL,
	"role" varchar(50) NOT NULL,
	create_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT users_username_key UNIQUE (username)
);

create trigger trigger_users_update_timestamp before
update
    on
    public.users for each row execute function func_update_timestamp()
;
