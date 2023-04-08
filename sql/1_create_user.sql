create user elec 
    IDENTIFIED by elec
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO elec;
GRANT CREATE SESSION to elec;
grant create table to elec;
grant create view, create procedure, create sequence to elec;
