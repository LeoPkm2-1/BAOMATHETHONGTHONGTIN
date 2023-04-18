-- https://docs.oracle.com/cd/E18283_01/appdev.112/e17126/create_trigger.htm#LNPLS01374
-- https://docs.oracle.com/cd/E18283_01/server.112/e17118/statements_7004.htm#:~:text=To%20create%20a%20trigger%20in,CREATE%20ANY%20TRIGGER%20system%20privilege.
-- https://docs.oracle.com/cd/E18283_01/network.112/e10745/worklabel.htm#i1013397
-- https://docs.oracle.com/cd/E18283_01/network.112/e10745/accpriv.htm#i1007408

-- user onwer of schema
conn sys/123456 as sysdba
create user user_a 
    IDENTIFIED by user_a
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO user_a;
GRANT CREATE SESSION to user_a;
grant create table to user_a;
grant create view, create procedure, create TRIGGER,create sequence to user_a;



-- user onwer of schema
conn sys/123456 as sysdba
create user user_b 
    IDENTIFIED by user_b
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO user_b;
GRANT CREATE SESSION to user_b;
grant create table to user_b;
grant create view, create procedure, create TRIGGER,create sequence to user_b;

-- user onwer of schema
conn sys/123456 as sysdba
create user user_c 
    IDENTIFIED by user_c
    DEFAULT TABLESPACE Users
    QUOTA  UNLIMITED ON Users;

GRANT CONNECT TO user_c;
GRANT CREATE SESSION to user_c;
grant create table to user_c;
grant create view, create procedure, create TRIGGER,create sequence to user_c;

commit;




-- tạo bảng cho user_a
conn user_a/user_a;
create table a_t (
    num NUMBER DEFAULT 0,
    cha char DEFAULT 'A'
);

create table a_t_u (
    num NUMBER ,
    cha char,
    usr VARCHAR2(50)
);

-- thêm 1 vài hàng vào bảng
conn user_a/user_a;
insert into a_t values (0,'a');
insert into a_t values (1,'b');
commit;


conn user_a/user_a;
select * from a_t;
select * from a_t_u;

-- chưa gán quyền cho b và c
conn user_b/user_b;
select * from user_a.a_t;
select * from user_a.a_t_u;

conn user_c/user_c;
select * from user_a.a_t;
select * from user_a.a_t_u;


-- gán quyền selct và insert của bảng a_t và a_t_o cho c
conn user_a/user_a;
grant select on user_a.a_t to user_c;
grant insert on user_a.a_t to user_c;
grant select on user_a.a_t_u to user_c;
grant insert on user_a.a_t_u to user_c;
commit;


conn sys/123456 as sysdba
grant create any trigger to user_b;

conn user_b/user_b;
create  OR REPLACE TRIGGER capnhat_a_t_u
    before INSERT 
    on user_a.a_t
    for EACH ROW
BEGIN
    insert into user_a.a_t_u values(:new.num,:new.cha,user);
end;
/

-- báo lỗi
-- không gán quyền select mà gán quyền insert into a_t_u cho user_b;
conn user_a/user_a;
grant insert on a_t_u to user_b;

conn user_b/user_b;
create  OR REPLACE TRIGGER capnhat_a_t_u
    before INSERT 
    on user_a.a_t
    for EACH ROW
BEGIN
    insert into user_a.a_t_u values(:new.num,:new.cha,user);
end;
/

-- test 
conn user_a/user_a;
insert into a_t values(3,'c');

conn user_c/user_c;
insert into user_a.a_t values(4,'d');

conn user_a/user_a;
revoke insert on a_t_u from user_c;

conn user_c/user_c;
insert into user_a.a_t values(5,'f');

-- bây giờ ta thử revoke cái quyền insert của user_b vào bảng a_t_u 
conn user_a/user_a;
revoke insert on user_a.a_t_u from user_b;

-- test 
conn user_a/user_a;
insert into a_t values(6,'g');