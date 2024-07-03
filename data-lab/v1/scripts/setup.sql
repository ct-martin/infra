-- Commands needed to set up various tools and a couple places use for working with data
-- Note: don't run this via a command like `psql` - this is intended to be run by hand and requires reconnecting

-- Create Superset user and main database
-- as admin 
create user superset with password 'superset';
create database superset with owner superset encoding UTF8;
create database examples with owner superset encoding UTF8;

-- Create Examples database for Superset
--\c examples
create schema main authorization superset;

-- Create Airbyte Database
-- as admin
create user airbyte with password 'airbyte';
create database airbyte with owner airbyte encoding UTF8;

-- Workaround for Airbyte's Helm Chart not respecting permissions / allowing configuration on non-managed PG instances
-- https://discuss.airbyte.io/t/unable-to-create-sql-database-when-trying-to-connect-to-an-external-database/1544/3
create database temporal with owner airbyte encoding UTF8;
grant all privileges on database temporal to airbyte;
create database temporal_visibility with owner airbyte encoding UTF8;
grant all privileges on database temporal_visibility to airbyte;

--\c examples -- Examples Database (owned by Superset)
-- Airbyte Permissions to Read Examples
grant select on all tables in schema main to airbyte;
alter default privileges in schema main grant select on tables to airbyte;

--\c myproject -- Project/Lab Database (owned by me/user)
-- Airbyte Permissions
GRANT CREATE, TEMPORARY ON DATABASE myproject TO airbyte;

-- Superset Permissions
grant select on all tables in schema public to superset;
alter default privileges in schema public grant select on tables to superset;
