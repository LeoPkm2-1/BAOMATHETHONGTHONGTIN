-- user onwer of schema
create user elec 
    IDENTIFIED by elec
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO elec;
GRANT CREATE SESSION to elec;
grant create table to elec;
grant create view, create procedure, create TRIGGER,create sequence to elec;


-- -- người dùng quản lý việc cấp nhẫn cho user khác
-- GRANT connect, create user, drop user,
-- create role, drop any role
-- TO elec_manage_user IDENTIFIED BY elec_manage_user;


-- -- người dùng quản lý chính sách bảo mật dành cho dữ liệu
-- GRANT connect TO elec_manage_label IDENTIFIED BY elec_manage_label;

-- create role elec_roles;
-- grant CONNECT to elec_roles;

-- -- các người dùng
-- -- nguoi dan
-- CREATE user elec_ngdan IDENTIFIED by elec_ngdan;
-- grant elec_roles to elec_ngdan;
-- -- cu tri
-- create user elec_cutri IDENTIFIED by elec_cutri;
-- grant elec_roles to elec_cutri;
-- -- lap cu tri
-- create user elec_lapcutri IDENTIFIED by elec_lapcutri;
-- grant elec_roles to elec_lapcutri;
-- -- nguoi theo doi
-- create user elec_theodoi IDENTIFIED by elec_theodoi;
-- grant elec_roles to elec_theodoi;
-- -- nguoi dam sat
-- create user elec_ngdamsat IDENTIFIED by elec_ngdamsat;
-- grant elec_roles to elec_ngdamsat;
-- -- chinh phu
-- CREATE user elec_chinhphu IDENTIFIED by elec_chinhphu;
-- grant elec_roles to elec_chinhphu;