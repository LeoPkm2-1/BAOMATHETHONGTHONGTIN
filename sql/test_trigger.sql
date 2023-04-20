conn elec/elec;
create table a_i (
    num NUMBER DEFAULT 0,
    cha CHAR DEFAULT 'A'
);

create table a_u (
    num NUMBER DEFAULT 0,
    cha CHAR DEFAULT 'A',
    usr VARCHAR2(50)
);


conn elec/elec;
insert into a_i values(1,'b');
insert into a_u values(1,'b',USER);


conn elec/elec;
select * from elec.a_i;
select * from elec.a_u;


conn testhihi/testhihi;
select * from elec.a_i;
select * from elec.a_u;

conn elec/elec;
grant select,insert,update,delete on a_i to test_null;
grant select,insert,update,delete on a_u to test_null;


conn test_null/test_null;
select * from elec.a_i;
select * from elec.a_u;


conn test_null/test_null;
insert into elec.a_i values(2,'c');
insert into elec.a_u values(2,'c',USER);
select * from elec.a_i;
select * from elec.a_u;



conn elec_giamsat_q2/elec_giamsat_q2;
select * from elec.a_i;
select * from elec.a_u;



-- không tạo được vì không có quyền đọc trên a_i
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    NULL;
end;
/




-- gán quyền truy tạo trigger cho mọi bảng trong mọi schema
conn sys/123456 as sysdba;
grant create any trigger to testhihi;

conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    NULL;
end;
/


-- do chưa cấp quyền insert vào a_u cho testhihi
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER);
end;
/





conn elec/elec;
grant select,insert,update,delete on a_u to testhihi;


conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER);
end;
/

conn elec/elec;
insert into a_i values(3,'d');
select * from a_i;
select * from a_u;


conn test_null/test_null;
insert into elec.a_i values(4,'e');
select * from elec.a_i;
select * from elec.a_u;


conn elec/elec;
grant select,insert,update,delete on a_i to elec_giamsat_q2;
grant select,insert,update,delete on a_u to elec_giamsat_q2;
grant select,insert,update,delete on a_i to testhihi;


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values(5,'f');
select * from elec.a_i;
select * from elec.a_u;


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_u values (5,'-',USER);
select * from elec.a_u;


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values (6,'G');
select * from elec.a_i;
select * from elec.a_u;


conn elec/elec;
revoke insert on elec.a_u from elec_giamsat_q2;


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_u values (7,'-',USER);


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values (7,'h');
commit;


conn elec_giamsat_q2/elec_giamsat_q2;
select * from elec.a_i;
select * from elec.a_u;


conn elec/elec;
revoke insert on elec.a_u from testhihi;


conn elec/elec;
insert into a_i values(8,'-');


conn test_null/test_null;
insert into elec.a_i values(8,'-');



conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    after INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER);
end;
/

conn test_null/test_null;
insert into elec.a_i values(8,'-');
select * from elec.a_i;

conn elec/elec;
grant insert on elec.a_u to testhihi;


conn test_null/test_null;
insert into elec.a_i values(8,'-');
select * from elec.a_i;



conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER);
end;
/

conn elec_sec_admin/elec_sec_admin;
BEGIN
    sa_policy_admin.apply_table_policy (
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'a_u',
        table_options => 'NO_CONTROL'
    );
END;
/



-- get session hiện tại.
SELECT sa_session.label('access_election')
FROM dual;


-- test default label.
conn elec_giamsat_q2/elec_giamsat_q2;
execute SA_SESSION.SET_ROW_LABEL('access_election','CONS:Q2');
insert into elec.a_u values(0,'-',USER,char_to_label('access_election','PUB'));


conn elec_giamsat_q2/elec_giamsat_q2;
update elec.a_u set OLS_ACC_COLUMN = char_to_label('access_election','PUB');



conn elec_sec_admin/elec_sec_admin;
BEGIN
    sa_policy_admin.remove_table_policy (
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'a_u'
    );
    sa_policy_admin.apply_table_policy(
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'a_u',
        table_options => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL'
    );
END;
/


conn elec_giamsat_q2/elec_giamsat_q2;
select * from elec.a_i;
select * from elec.a_u;



conn test_null/test_null;
select * from elec.a_i;
select * from elec.a_u;


conn testhihi/testhihi;
select * from elec.a_i;
select * from elec.a_u;

conn elec/elec;
grant insert on elec.a_u to elec_giamsat_q2;

conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_u values(5,'f',USER,char_to_label('access_election','SENS:Q5,BC'));
insert into elec.a_u values(8,'u',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_u values(9,'i',USER,char_to_label('access_election','SENS:Q2,BC'));


conn test_null/test_null;
insert into elec.a_u values(10,'j',USER,char_to_label('access_election','CONS:Q1'));
insert into elec.a_u values(10,'j',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));



conn test_null/test_null;
insert into elec.a_u values(11,'k',USER,char_to_label('access_election','CONS:Q5'));


conn testhihi/testhihi;
insert into elec.a_u values(7,'h',USER,char_to_label('access_election','SENS'));


conn testhihi/testhihi;
insert into elec.a_u values(11,'-',USER,char_to_label('access_election','SENS:Q1:TD'));
insert into elec.a_u values(12,'-',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));


conn testhihi/testhihi;
insert into elec.a_u values(12,'l',USER,char_to_label('access_election','SENS:Q3:TD'));
insert into elec.a_u values(13,'M',USER,char_to_label('access_election','TOP_SENS:Q4,BC:GS'));



conn elec/elec;
insert into a_i values(14,'-');


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values(14,'-');


conn test_null/test_null;
insert into elec.a_i values(14,'-');


conn testhihi/testhihi;
insert into elec.a_i values(14,'-');


-- test trigger
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    DBMS_OUTPUT.put_line ('Hello World!');
end;
/

conn test_null/test_null;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'-');


conn elec_giamsat_q2/elec_giamsat_q2;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'*');



conn testhihi/testhihi;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'+');


-- test trigger with label
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line ('Hello World!');
end;
/

conn testhihi/testhihi;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'+');


conn elec_giamsat_q2/elec_giamsat_q2;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'*');


conn test_null/test_null;
SET SERVEROUTPUT on;
insert into elec.a_i values(15,'-');


-- test trigger with label
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line (v_label);
end;
/

conn testhihi/testhihi;
SET SERVEROUTPUT on;
insert into elec.a_i values(16,'#');


conn elec_giamsat_q2/elec_giamsat_q2;
SET SERVEROUTPUT on;
insert into elec.a_i values(16,'+');

conn test_null/test_null;
SET SERVEROUTPUT on;
insert into elec.a_i values(16,'@');


-- test trigger with label 2
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line (' _ ');
    DBMS_OUTPUT.put_line (USER);
    DBMS_OUTPUT.put_line (v_label);
end;
/

conn test_null/test_null;
SET SERVEROUTPUT ON;
insert into elec.a_i values(17,'^');


conn elec_giamsat_q2/elec_giamsat_q2;
set SERVEROUTPUT ON;
insert into elec.a_i values(17,'$');

conn testhihi/testhihi;
set SERVEROUTPUT ON;
insert into elec.a_i values (17,'*');


-- xóa trigger của testhihi đi để test với các người dùng khác, do label của testhihi.
conn testhihi/testhihi;
drop trigger a_i_log_a_u;


conn elec_user_manage/elec_user_manage;
BEGIN
    -- dân quận 1
    sa_user_admin.set_user_labels (
        policy_name => 'access_election',
        user_name => 'elec_dan_q1',
        max_read_label => 'CONS:Q1',
        max_write_label => '',
        min_write_label => '',
        def_label=>'',
        row_label => ''
    );
end;
/

conn sys/123456 as sysdba;
grant create any trigger to elec_dan_q1;

conn elec/elec;
grant select, insert, update, delete on a_i to elec_dan_q1;
grant select, insert, update, delete on a_u to elec_dan_q1;


conn elec_dan_q1/elec_dan_q1;
select * from elec.a_i;
select * from elec.a_u;



-- test trigger with label 3
conn elec_dan_q1/elec_dan_q1;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line (' _ ');
    DBMS_OUTPUT.put_line (USER);
    DBMS_OUTPUT.put_line (v_label);
end;
/


conn elec_dan_q1/elec_dan_q1;
set SERVEROUTPUT ON;
insert into elec.a_i values (18,'=');


conn elec_giamsat_q2/elec_giamsat_q2;
set SERVEROUTPUT ON;
insert into elec.a_i values (18,'&');


conn test_null/test_null;
set SERVEROUTPUT ON;
insert into elec.a_i values (18,'~');


conn testhihi/testhihi;
set SERVEROUTPUT ON;
insert into elec.a_i values (18,'!');

conn elec_dan_q1/elec_dan_q1;
drop trigger a_i_log_a_u;


-- test trigger with label 3
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.row_label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line (' _ ');
    DBMS_OUTPUT.put_line (USER);
    DBMS_OUTPUT.put_line (v_label);
end;
/

conn elec_dan_q1/elec_dan_q1;
set SERVEROUTPUT ON;
insert into elec.a_i values (19,'=');


conn elec_giamsat_q2/elec_giamsat_q2;
set SERVEROUTPUT ON;
insert into elec.a_i values (19,'&');


conn test_null/test_null;
set SERVEROUTPUT ON;
insert into elec.a_i values (19,'~');


conn testhihi/testhihi;
set SERVEROUTPUT ON;
insert into elec.a_i values (19,'!');

conn elec/elec;
grant insert on elec.a_u to testhihi;

-- test trigger with label 4
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
DECLARE
    v_label varchar2(100);
BEGIN
    -- insert into elec.a_u values (:new.num,:new.cha,USER,100);
    SELECT sa_session.row_label('access_election')
    into v_label
    FROM dual;
    DBMS_OUTPUT.put_line(v_label);
    insert into elec.a_u values(:new.num, :new.cha, USER, char_to_label('access_election',v_label));
end;
/

conn elec_dan_q1/elec_dan_q1;
set SERVEROUTPUT ON;
insert into elec.a_i values (19,'O');


conn elec_giamsat_q2/elec_giamsat_q2;
set SERVEROUTPUT ON;
insert into elec.a_i values (20,'P');

conn test_null/test_null;
set SERVEROUTPUT ON;
insert into elec.a_i values (20,'~');


conn testhihi/testhihi;
set SERVEROUTPUT ON;
insert into elec.a_i values (21,'Q');