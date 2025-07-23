create schema main;

create table online_shop.main.tr_raw_scrap_data(
	id serial4
	,"name" varchar(255) not null
	,detail text
	,price int8 not null
	,originalprice int8
	,discountpercentage float
	,platform varchar(255)  not null
	,createdate date  not null
	,primary key(id));
comment on column main.tr_raw_scrap_data."id" is 'Unique identifier.';
comment on column main.tr_raw_scrap_data."name" is 'Name of the product.';
comment on column main.tr_raw_scrap_data.detail is 'Additional details or description of the product.';
comment on column main.tr_raw_scrap_data.price is 'Current price of the product.';
comment on column main.tr_raw_scrap_data.originalprice is 'Original price of the product.';
comment on column main.tr_raw_scrap_data.discountpercentage is 'Discount percentage applied to the product.';
comment on column main.tr_raw_scrap_data.platform is 'Platform from which the product data was crawled.';
comment on column main.tr_raw_scrap_data.createdate is 'date when the data was crawled.';

create database airflow_database;

\c airflow_database;

CREATE USER airflow_admin WITH PASSWORD 'airflow_admin';
GRANT ALL PRIVILEGES ON DATABASE airflow_database TO airflow_admin;
GRANT ALL ON SCHEMA public TO airflow_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO airflow_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO airflow_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO airflow_admin;

create database api_user_access;

\c api_user_access;

create schema main;

CREATE OR REPLACE FUNCTION main.func_update_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		NEW.update_timestamp = CURRENT_TIMESTAMP;
		RETURN NEW;
	END;
$function$
;

CREATE TABLE main.request_type (
	id serial4 NOT NULL,
	request_type varchar(10) NOT NULL,
	is_active int2 DEFAULT 1 NOT NULL,
	create_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT check_request_type__is_active CHECK ((is_active = ANY (ARRAY[0, 1]))),
	CONSTRAINT request_type_pk PRIMARY KEY (id)
);

create trigger main.trigger_request_type_update_timestamp before
update
    on
    main.request_type for each row execute function main.func_update_timestamp();

CREATE TABLE main.roles (
	id serial4 NOT NULL,
	roles varchar(50) NOT NULL,
	is_active int2 DEFAULT 1 NOT NULL,
	create_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT check_users__is_active CHECK ((is_active = ANY (ARRAY[0, 1]))),
	CONSTRAINT roles_pk PRIMARY KEY (id)
);

create trigger main.trigger_roles_update_timestamp before
update
    on
    main.roles for each row execute function main.func_update_timestamp();

CREATE TABLE main.roles_permissions (
	id serial4 NOT NULL,
	roles_id int4 NOT NULL,
	request_type_id int4 NOT NULL,
	is_active int2 DEFAULT 1 NOT NULL,
	create_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT check_roles_permissions__is_active CHECK ((is_active = ANY (ARRAY[0, 1]))),
	CONSTRAINT roles_permissions_pk PRIMARY KEY (id),
	CONSTRAINT unique_roles_permissions__roles_id__request_type_id UNIQUE (roles_id, request_type_id),
	CONSTRAINT fk_roles_permissions__request_type_id___request_type__id FOREIGN KEY (request_type_id) REFERENCES public.request_type(id),
	CONSTRAINT fk_roles_permissions__roles_id___roles__id FOREIGN KEY (roles_id) REFERENCES public.roles(id)
);

create trigger main.trigger_roles_permissions_update_timestamp before
update
    on
    main.roles_permissions for each row execute function main.func_update_timestamp();

CREATE TABLE main.users (
	id serial4 NOT NULL,
	username varchar(100) NOT NULL,
	password_hash text NOT NULL,
	password_salt text NOT NULL,
	roles_id int4 NOT NULL,
	is_active int2 DEFAULT 1 NOT NULL,
	create_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	update_timestamp timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT check_roles__is_active CHECK ((is_active = ANY (ARRAY[0, 1]))),
	CONSTRAINT unique_users__username UNIQUE (username),
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT fk_users__roles_id___roles__id FOREIGN KEY (roles_id) REFERENCES public.roles(id)
);

create trigger main.trigger_users_update_timestamp before
update
    on
    main.users for each row execute function main.func_update_timestamp();

INSERT INTO main.roles (roles) VALUES
	('root'),
	('admin'),
	('moderator'),
	('user');

INSERT INTO main.request_type (request_type) VALUES
	('POST'),
	('GET'),
	('PUT'),
	('DELETE');

INSERT INTO main.roles_permissions (roles_id,request_type_id) VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(2,1),
	(2,2),
	(2,3),
	(3,2),
	(3,3),
	(4,2);
