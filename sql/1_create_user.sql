-- user onwer of schema
conn sys/123456 as sysdba
create user elec 
    IDENTIFIED by elec
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO elec;
GRANT CREATE SESSION to elec;
grant create table to elec;
grant create view, create procedure, create TRIGGER,create sequence to elec;


