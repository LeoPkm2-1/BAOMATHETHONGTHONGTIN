conn sys/123456 as sysdba
-- -- -- nguoi dung trong ols
-- quan ly nguoi dung trong chinh sach cua ols
GRANT connect, create user, drop user,
create role, drop any role
TO elec_user_manage IDENTIFIED BY elec_user_manage;

-- người quản lý toàn bộ bảng (để testing)
GRANT connect TO elec_admin_full IDENTIFIED BY elec_admin_full;

-- quan ly chinh sách của ols
GRANT connect TO elec_sec_admin IDENTIFIED BY elec_sec_admin;

-- -- các người dung trong he thống của oracle
create role elec_roles;
grant connect to elec_roles;


-- dan quan 1
create user elec_dan_q1 IDENTIFIED BY elec_dan_q1;
grant elec_roles to elec_dan_q1;
-- dan quan 2
create user elec_dan_q2 IDENTIFIED BY elec_dan_q2;
grant elec_roles to elec_dan_q2;
-- dan quan 3
create user elec_dan_q3 IDENTIFIED BY elec_dan_q3;
grant elec_roles to elec_dan_q3;
-- dan quan 4
create user elec_dan_q4 IDENTIFIED BY elec_dan_q4;
grant elec_roles to elec_dan_q4;
-- dan quan 5
create user elec_dan_q5 IDENTIFIED BY elec_dan_q5;
grant elec_roles to elec_dan_q5;



-- lap cu tri quan 1
create user elec_lapctr_q1 IDENTIFIED BY elec_lapctr_q1;
grant elec_roles to elec_lapctr_q1;
-- lap cu tri quan 2
create user elec_lapctr_q2 IDENTIFIED BY elec_lapctr_q2;
grant elec_roles to elec_lapctr_q2;
-- lap cu tri quan 3
create user elec_lapctr_q3 IDENTIFIED BY elec_lapctr_q3;
grant elec_roles to elec_lapctr_q3;
-- lap cu tri quan 4
create user elec_lapctr_q4 IDENTIFIED BY elec_lapctr_q4;
grant elec_roles to elec_lapctr_q4;
-- lap cu tri quan 5
create user elec_lapctr_q5 IDENTIFIED BY elec_lapctr_q5;
grant elec_roles to elec_lapctr_q5;




-- theo doi quan 1
create user elec_theodoi_q1 IDENTIFIED BY elec_theodoi_q1;
grant elec_roles to elec_theodoi_q1;
-- theo doi quan 2
create user elec_theodoi_q2 IDENTIFIED BY elec_theodoi_q2;
grant elec_roles to elec_theodoi_q2;
-- theo doi quan 3
create user elec_theodoi_q3 IDENTIFIED BY elec_theodoi_q3;
grant elec_roles to elec_theodoi_q3;
-- theo doi quan 4
create user elec_theodoi_q4 IDENTIFIED BY elec_theodoi_q4;
grant elec_roles to elec_theodoi_q4;
-- theo doi quan 5
create user elec_theodoi_q5 IDENTIFIED BY elec_theodoi_q5;
grant elec_roles to elec_theodoi_q5;




-- dam sat quan 1
create user elec_giamsat_q1 IDENTIFIED BY elec_giamsat_q1;
grant elec_roles to elec_giamsat_q1;
-- dam sat quan 2
create user elec_giamsat_q2 IDENTIFIED BY elec_giamsat_q2;
grant elec_roles to elec_giamsat_q2;
-- dam sat quan 3
create user elec_giamsat_q3 IDENTIFIED BY elec_giamsat_q3;
grant elec_roles to elec_giamsat_q3;
-- dam sat quan 4
create user elec_giamsat_q4 IDENTIFIED BY elec_giamsat_q4;
grant elec_roles to elec_giamsat_q4;
-- dam sat quan 5
create user elec_giamsat_q5 IDENTIFIED BY elec_giamsat_q5;
grant elec_roles to elec_giamsat_q5;


conn lbacsys/123456;
begin 
    SA_SYSDBA.create_policy(
        policy_name => 'access_election',
        column_name => 'OLS_acc_column'
    );
end;
/




conn lbacsys/123456;
GRANT access_election_dba to elec_sec_admin;

-- Package dùng để tạo ra các thành phần của nhãn
GRANT execute ON sa_components TO elec_sec_admin;

-- Package dùng để tạo các nhãn
GRANT execute on sa_label_admin to elec_sec_admin;

-- Package dùng để gán chính sách cho các table/schema
GRANT execute ON sa_policy_admin TO elec_sec_admin;



CONN lbacsys/123456;
GRANT access_election_dba to elec_user_manage;

-- Package dùng để gán các label cho user
GRANT execute ON sa_user_admin to elec_user_manage;


-- -- tạo các thành phần của nhãn
-- level
conn elec_sec_admin/elec_sec_admin;

EXECUTE sa_components.create_level('access_election',1000,'PUB','PUBLIC');
EXECUTE sa_components.create_level('access_election',2000,'CONS','CONFIDENTIAL');
EXECUTE sa_components.create_level('access_election',3000,'SENS','SENSITIVE');
EXECUTE sa_components.create_level('access_election',4000,'TOP_SENS','TOP_SENSITIVE');


-- compartment
conn elec_sec_admin/elec_sec_admin;

EXECUTE sa_components.create_compartment('access_election',100,'Q1','QUAN_1');
EXECUTE sa_components.create_compartment('access_election',200,'Q2','QUAN_2');
EXECUTE sa_components.create_compartment('access_election',300,'Q3','QUAN_3');
EXECUTE sa_components.create_compartment('access_election',400,'Q4','QUAN_4');
EXECUTE sa_components.create_compartment('access_election',500,'Q5','QUAN_5');
EXECUTE sa_components.create_compartment('access_election',600,'BC','BAU_CU');


-- Group
conn elec_sec_admin/elec_sec_admin;

EXECUTE sa_components.create_group('access_election',10,'GS','GIAM_SAT',NULL);
EXECUTE sa_components.create_group('access_election',20,'LCT','LAP_CU_TRI','GS');
EXECUTE sa_components.create_group('access_election',30,'TD','THEO_DOI','GS');



-- -- tạo nhãn
conn elec_sec_admin/elec_sec_admin;

-- nhãn cho bảng khu vực;
EXECUTE sa_label_admin.create_label('access_election', 100,'PUB');
-- nhãn cho bảng khu vực quan 1;
EXECUTE sa_label_admin.create_label('access_election', 110,'PUB:Q1');
-- nhãn cho bảng khu vực quan 2;
EXECUTE sa_label_admin.create_label('access_election', 120,'PUB:Q2');
-- nhãn cho bảng khu vực quan 3;
EXECUTE sa_label_admin.create_label('access_election', 130,'PUB:Q3');
-- nhãn cho bảng khu vực quan 4;
EXECUTE sa_label_admin.create_label('access_election', 140,'PUB:Q4');
-- nhãn cho bảng khu vực quan 5;
EXECUTE sa_label_admin.create_label('access_election', 150,'PUB:Q5');



-- nhãn người giám sát quận 1 + log chọn cử trị quận 1 + lịch sử bầu cử quận 1 + phiếu bầu quận 1;
EXECUTE sa_label_admin.create_label('access_election',4110,'TOP_SENS:Q1,BC:GS');
-- nhãn người giám sát quận 2 + log chọn cử trị quận 2 + lịch sử bầu cử quận 2 + phiếu bầu quận 2;
EXECUTE sa_label_admin.create_label('access_election',4210,'TOP_SENS:Q2,BC:GS');
-- nhãn người giám sát quận 3 + log chọn cử trị quận 3 + lịch sử bầu cử quận 3 + phiếu bầu quận 3;
EXECUTE sa_label_admin.create_label('access_election',4310,'TOP_SENS:Q3,BC:GS');
-- nhãn người giám sát quận 4 + log chọn cử trị quận 4 + lịch sử bầu cử quận 4 + phiếu bầu quận 4;
EXECUTE sa_label_admin.create_label('access_election',4410,'TOP_SENS:Q4,BC:GS');
-- nhãn người giám sát quận 5 + log chọn cử trị quận 5 + lịch sử bầu cử quận 5 + phiếu bầu quận 5;
EXECUTE sa_label_admin.create_label('access_election',4510,'TOP_SENS:Q5,BC:GS');


-- nhãn người theo dõi quận 1 + trang thái cử tri quận 1 + số phiếu quận 1;
EXECUTE sa_label_admin.create_label('access_election',3130,'SENS:Q1:TD');
-- nhãn người theo dõi quận 2 + trang thái cử tri quận 2 + số phiếu quận 2;
EXECUTE sa_label_admin.create_label('access_election',3230,'SENS:Q2:TD');
-- nhãn người theo dõi quận 3 + trang thái cử tri quận 3 + số phiếu quận 3;
EXECUTE sa_label_admin.create_label('access_election',3330,'SENS:Q3:TD');
-- nhãn người theo dõi quận 4 + trang thái cử tri quận 4 + số phiếu quận 4;
EXECUTE sa_label_admin.create_label('access_election',3430,'SENS:Q4:TD');
-- nhãn người theo dõi quận 5 + trang thái cử tri quận 5 + số phiếu quận 5;
EXECUTE sa_label_admin.create_label('access_election',3530,'SENS:Q5:TD');

-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3120,'SENS:Q1:LCT');
-- nhãn người lap cử tri quận 2;
EXECUTE sa_label_admin.create_label('access_election',3220,'SENS:Q2:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3320,'SENS:Q3:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3420,'SENS:Q4:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3520,'SENS:Q5:LCT');



-- nhãn người dân quận 1 + ứng viên 1;
EXECUTE sa_label_admin.create_label('access_election',210,'CONS:Q1');
-- nhãn người dân quận 2 + ứng viên 2;
EXECUTE sa_label_admin.create_label('access_election',220,'CONS:Q2');
-- nhãn người dân quận 3 + ứng viên 3;
EXECUTE sa_label_admin.create_label('access_election',230,'CONS:Q3');
-- nhãn người dân quận 4 + ứng viên 4;
EXECUTE sa_label_admin.create_label('access_election',240,'CONS:Q4');
-- nhãn người dân quận 5 + ứng viên 5;
EXECUTE sa_label_admin.create_label('access_election',250,'CONS:Q5');



-- nhãn người cử tri 1;
EXECUTE sa_label_admin.create_label('access_election',310,'SENS:Q1,BC');
-- nhãn người cử tri 2;
EXECUTE sa_label_admin.create_label('access_election',320,'SENS:Q2,BC');
-- nhãn người cử tri 3;
EXECUTE sa_label_admin.create_label('access_election',330,'SENS:Q3,BC');
-- nhãn người cử tri 4;
EXECUTE sa_label_admin.create_label('access_election',340,'SENS:Q4,BC');
-- nhãn người cử tri 5;
EXECUTE sa_label_admin.create_label('access_election',350,'SENS:Q5,BC');





-- -- gán nhãn cho người dùng
conn elec_user_manage/elec_user_manage;

-- người dung có toàn quền trên hệ thống.
BEGIN
    sa_user_admin.set_user_privs (
        policy_name => 'access_election',
        user_name => 'elec_admin_full',
        PRIVILEGES => 'FULL'
    );
END;
/

-- -- gán nhãn cho người dùng giám sát
conn elec_user_manage/elec_user_manage;
BEGIN
    -- giám sát quận 1
        sa_user_admin.set_user_labels (
            policy_name => 'access_election',
            user_name => 'elec_giamsat_q1',
            max_read_label => 'TOP_SENS:Q1,BC:GS',
            max_write_label => 'TOP_SENS',
            min_write_label => 'TOP_SENS',
            def_label=>'TOP_SENS:Q1,BC:GS',
            row_label => 'TOP_SENS'
        );
end;
/

conn elec_user_manage/elec_user_manage;
BEGIN
    -- giám sát quận 2
        sa_user_admin.set_user_labels (
            policy_name => 'access_election',
            user_name => 'elec_giamsat_q2',
            max_read_label => 'TOP_SENS:Q2,BC:GS',
            max_write_label => '',
            min_write_label => '',
            def_label=>'',
            row_label => ''
        );

end;
/

conn elec_user_manage/elec_user_manage;
BEGIN
    -- giám sát quận 3
        sa_user_admin.set_user_labels (
            policy_name => 'access_election',
            user_name => 'elec_giamsat_q3',
            max_read_label => 'TOP_SENS:Q3,BC:GS',
            max_write_label => NULL,
            min_write_label => NULL,
            def_label=>'',
            row_label => ''
        );
end;
/

conn elec_user_manage/elec_user_manage;
BEGIN
    -- giám sát quận 4
        sa_user_admin.set_user_labels (
            policy_name => 'access_election',
            user_name => 'elec_giamsat_q4',
            max_read_label => 'TOP_SENS:Q4,BC:GS',
            max_write_label => 'TOP_SENS',
            min_write_label => 'TOP_SENS',
            def_label=>'TOP_SENS',
            row_label => 'TOP_SENS'
        );
end;
/

conn elec_user_manage/elec_user_manage;
BEGIN
    -- giám sát quận 5
        sa_user_admin.set_user_labels (
            policy_name => 'access_election',
            user_name => 'elec_giamsat_q5',
            max_read_label => 'TOP_SENS:Q5,BC:GS',
            max_write_label => 'TOP_SENS',
            min_write_label => 'TOP_SENS',
            def_label=>'TOP_SENS',
            row_label => 'TOP_SENS:Q5,BC:GS'
        );        
end; 
/


commit;


conn elec/elec;
grant select on khuvuc to elec_sec_admin;
grant insert , update, delete on khuvuc to elec_sec_admin;

conn elec/elec;
grant select on khuvuc to elec_admin_full;
grant insert , update, delete on khuvuc to elec_admin_full;


conn elec/elec;
grant select on khuvuc to elec_giamsat_q1;
grant select on khuvuc to elec_giamsat_q2;
grant select on khuvuc to elec_giamsat_q3;
grant select on khuvuc to elec_giamsat_q4;

conn elec_sec_admin/elec_sec_admin;
BEGIN
    sa_policy_admin.apply_table_policy (
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'khuvuc',
        table_options => 'NO_CONTROL'
    );
END;
/


conn elec/elec;
update elec.khuvuc set OLS_ACC_COLUMN = char_to_label('access_election','PUB:Q1') where ma_khu_vuc = 100;
update elec.khuvuc set OLS_ACC_COLUMN = char_to_label('access_election','PUB:Q2') where ma_khu_vuc = 101;
update elec.khuvuc set OLS_ACC_COLUMN = char_to_label('access_election','PUB:Q3') where ma_khu_vuc = 102;
update elec.khuvuc set OLS_ACC_COLUMN = char_to_label('access_election','PUB:Q4') where ma_khu_vuc = 103;
update elec.khuvuc set OLS_ACC_COLUMN = char_to_label('access_election','PUB:Q5') where ma_khu_vuc = 104;


conn elec_sec_admin/elec_sec_admin;
BEGIN
    sa_policy_admin.remove_table_policy (
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'khuvuc'
    );
    sa_policy_admin.apply_table_policy(
        policy_name => 'access_election',
        schema_name => 'elec',
        table_name => 'khuvuc',
        table_options => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL'
    );
END;
/


insert into elec.khuvuc values(111,'ahih',110);


conn elec/elec;
grant insert on elec.khuvuc to elec_giamsat_q1;
grant insert on elec.khuvuc to elec_giamsat_q2;
grant insert on elec.khuvuc to elec_giamsat_q3;
grant insert on elec.khuvuc to elec_giamsat_q4;

commit;


-- khong6 dc vi khong co nhan ton tai
            conn  elec_giamsat_q1/elec_giamsat_q1;
            insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','CONS:Q1:GS'));
            insert into elec.khuvuc values(112,'ahih2',char_to_label('access_election','CONS'));
            insert into elec.khuvuc values(113,'ahih3',char_to_label('access_election','SENS'));
            insert into elec.khuvuc values(114,'ahih4',char_to_label('access_election','TOP_SENS'));

            conn  elec_giamsat_q2/elec_giamsat_q2;
            insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','CONS:Q1:GS'));
            insert into elec.khuvuc values(112,'ahih2',char_to_label('access_election','CONS'));
            insert into elec.khuvuc values(113,'ahih3',char_to_label('access_election','SENS'));
            insert into elec.khuvuc values(114,'ahih4',char_to_label('access_election','TOP_SENS'));


            conn  elec_giamsat_q3/elec_giamsat_q3;
            insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','CONS:Q1:GS'));
            insert into elec.khuvuc values(112,'ahih2',char_to_label('access_election','CONS'));
            insert into elec.khuvuc values(113,'ahih3',char_to_label('access_election','SENS'));
            insert into elec.khuvuc values(114,'ahih4',char_to_label('access_election','TOP_SENS'));



            conn  elec_giamsat_q4/elec_giamsat_q4;
            insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','CONS:Q1:GS'));
            insert into elec.khuvuc values(112,'ahih2',char_to_label('access_election','CONS'));
            insert into elec.khuvuc values(113,'ahih3',char_to_label('access_election','SENS'));
            insert into elec.khuvuc values(114,'ahih4',char_to_label('access_election','TOP_SENS'));


conn  elec_giamsat_q1/elec_giamsat_q1;
insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','PUB') );

-- duoc vi co quyen full, và những thành phần dc thêm vào với nhãn khogn6 tồn tại thì chỉ có người có quyền full mới thấy.
        conn elec_admin_full/elec_admin_full;
        insert into elec.khuvuc values(110,'ahih0',char_to_label('access_election','PUB') );
        insert into elec.khuvuc values(112,'ahih2',char_to_label('access_election','CONS'));
        insert into elec.khuvuc values(1120,'ahih20',char_to_label('access_election','CONS'));
        insert into elec.khuvuc values(113,'ahih3',char_to_label('access_election','SENS'));


-- tao user de test voi71 full quyen
        conn sys/123456 as sysdba
        create user testhihi 
            IDENTIFIED by testhihi
            DEFAULT TABLESPACE Users
            QUOTA  UNLIMITED ON Users;

        GRANT CONNECT TO testhihi;
        GRANT CREATE SESSION to testhihi;
        grant create table to testhihi;
        grant create view, create procedure, create TRIGGER,create sequence to testhihi;


        conn elec_user_manage/elec_user_manage;
        BEGIN
            -- giám sát quận 5
                sa_user_admin.set_user_labels (
                    policy_name => 'access_election',
                    user_name => 'testhihi',
                    max_read_label => 'TOP_SENS:Q1,Q2,Q3,Q4,Q5,BC:GS',
                    max_write_label => 'TOP_SENS:Q1,Q2,Q3,Q4,Q5,BC:GS',
                    min_write_label => 'PUB',
                    def_label=>'TOP_SENS:Q1,Q2,Q3,Q4,Q5,BC:GS',
                    row_label => 'TOP_SENS:Q1,Q2,Q3,Q4,Q5,BC:GS'
                );        
        end; 
        /
     

conn elec/elec;
grant select,insert on elec.khuvuc to testhihi;

-- có một số thêm không dc vì không tồn tại nhãn
        conn testhihi/testhihi;
        insert into elec.khuvuc values(1193,'ahi9h3',char_to_label('access_election','PUB'));
        insert into elec.khuvuc values(1173,'hehe',char_to_label('access_election','SENS'));
        insert into elec.khuvuc values(11873,'he-he',char_to_label('access_election','PUB:Q1'));
        insert into elec.khuvuc values(1,'hee',char_to_label('access_election','SENS:Q1:TD'));


-- nhãn khogn6 tồn tại nên không thêm dc.
        conn  elec_giamsat_q1/elec_giamsat_q1;
        insert into elec.khuvuc values(5,'xin chao',char_to_label('access_election','TOP_SENS'));
        conn  elec_giamsat_q2/elec_giamsat_q2;
        insert into elec.khuvuc values(5,'xin chao',char_to_label('access_election','TOP_SENS'));
        conn  elec_giamsat_q3/elec_giamsat_q3;
        insert into elec.khuvuc values(5,'xin chao',char_to_label('access_election','TOP_SENS'));
        conn  elec_giamsat_q4/elec_giamsat_q4;
        insert into elec.khuvuc values(5,'xin chao',char_to_label('access_election','TOP_SENS'));

-- thêm thử data
-- không thêm dc do không dủ quyền
    conn  elec_giamsat_q1/elec_giamsat_q1;
    insert into elec.khuvuc values(6,' helo', char_to_label('access_election','PUB'));  
    insert into elec.khuvuc values(6,' helo', char_to_label('access_election','TOP_SENS:Q1,BC:GS'));  


conn  elec_giamsat_q2/elec_giamsat_q2;
-- thêm dc
    insert into elec.khuvuc values(6,' helo', char_to_label('access_election','TOP_SENS:Q2,BC:GS'));
    insert into elec.khuvuc values(7,' helo7', char_to_label('access_election','SENS:Q2:LCT'));
    insert into elec.khuvuc values(8,' helo8', char_to_label('access_election','PUB'));
    insert into elec.khuvuc values(9,' helo9', char_to_label('access_election','PUB:Q2'));
    insert into elec.khuvuc values(10,' helo10', char_to_label('access_election','CONS:Q2'));
    insert into elec.khuvuc values(11,' helo11', char_to_label('access_election','SENS:Q2,BC'));
    insert into elec.khuvuc values(12,' helo12', 320);
    insert into elec.khuvuc values(13,' helo13', char_to_label('access_election','SENS:Q2:TD'));
    insert into elec.khuvuc values(14,' helo14', 3230);
    insert into elec.khuvuc values(15,' helo15', 120);
    insert into elec.khuvuc values(16,' helo16', 4210);
    insert into elec.khuvuc values(17,' helo17', 3220);
    insert into elec.khuvuc values(18,' helo18', 220);

-- thêm không được
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','PUB:Q3'));
    insert into elec.khuvuc values(19,'ido19',130);
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','TOP_SENS:Q4,BC:GS'));
    insert into elec.khuvuc values(19,'ido19',4410);
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','SENS:Q5:TD'));
    insert into elec.khuvuc values(19,'ido19',3530);    
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','SENS:Q3:LCT'));
    insert into elec.khuvuc values(19,'ido19',3320);
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','CONS:Q5'));
    insert into elec.khuvuc values(19,'ido19',250);
    insert into elec.khuvuc values(19,'ido19',char_to_label('access_election','SENS:Q5,BC'));
    insert into elec.khuvuc values(19,'ido19',350);




conn  elec_giamsat_q3/elec_giamsat_q3;
-- thêm được
    insert into elec.khuvuc values(20,'ido20',char_to_label('access_election','PUB'));
    insert into elec.khuvuc values(21,'ido21',100);
    insert into elec.khuvuc values(22,'ido22',char_to_label('access_election','PUB:Q3'));
    insert into elec.khuvuc values(23,'ido23',130);
    insert into elec.khuvuc values(24,'ido24',char_to_label('access_election','TOP_SENS:Q3,BC:GS'));
    insert into elec.khuvuc values(25,'ido25',4310);
    insert into elec.khuvuc values(26,'ido26',char_to_label('access_election','SENS:Q3:TD'));
    insert into elec.khuvuc values(27,'ido27',3330);    
    insert into elec.khuvuc values(28,'ido28',char_to_label('access_election','SENS:Q3:LCT'));
    insert into elec.khuvuc values(29,'ido29',3320);
    insert into elec.khuvuc values(30,'ido30',char_to_label('access_election','CONS:Q3'));
    insert into elec.khuvuc values(31,'ido31',230);
    insert into elec.khuvuc values(32,'ido32',char_to_label('access_election','SENS:Q3,BC'));
    insert into elec.khuvuc values(33,'ido33',330);


-- không thêm được
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','PUB:Q2'));
    insert into elec.khuvuc values(34,'ido34',120);
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','TOP_SENS:Q2,BC:GS'));
    insert into elec.khuvuc values(34,'ido34',4210);  
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','SENS:Q5:TD'));
    insert into elec.khuvuc values(34,'ido34',3530);
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','SENS:Q1:LCT'));
    insert into elec.khuvuc values(34,'ido34',3120);  
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','CONS:Q4'));
    insert into elec.khuvuc values(34,'ido34',240);
    insert into elec.khuvuc values(34,'ido34',char_to_label('access_election','SENS:Q1,BC'));
    insert into elec.khuvuc values(34,'ido34',310);  



conn  elec_giamsat_q4/elec_giamsat_q4;
-- không thê thêm dc vì không có tổ hợp nhãn tạo ra từ authentication set.
    insert into elec.khuvuc values(35,'ido35',char_to_label('access_election','PUB'));
    insert into elec.khuvuc values(36,'ido36',100);






-- tao user de test voi71 các thuộc tính từ write trở đi làm NULL
        conn sys/123456 as sysdba
        create user test_null 
            IDENTIFIED by test_null
            DEFAULT TABLESPACE Users
            QUOTA  UNLIMITED ON Users;

        GRANT CONNECT TO test_null;
        GRANT CREATE SESSION to test_null;
        grant create table to test_null;
        grant create view, create procedure, create TRIGGER,create sequence to test_null;


        conn elec_user_manage/elec_user_manage;
        BEGIN
                sa_user_admin.set_user_labels (
                    policy_name => 'access_election',
                    user_name => 'test_null',
                    max_read_label => 'TOP_SENS:Q5,BC:GS',
                    max_write_label =>  NULL,
                    min_write_label => NULL,
                    def_label=> NULL,
                    row_label =>  NULL
                );        
        end; 
        /


conn elec/elec;
grant select,insert on elec.khuvuc to test_null;

conn test_null/test_null;
-- thêm dược
    insert into elec.khuvuc values(37,'ido37',char_to_label('access_election','PUB'));
    insert into elec.khuvuc values(38,'ido38',100);
    insert into elec.khuvuc values(39,'ido39',char_to_label('access_election','PUB:Q5'));
    insert into elec.khuvuc values(40,'ido40',150);
    insert into elec.khuvuc values(41,'ido41',char_to_label('access_election','TOP_SENS:Q5,BC:GS'));
    insert into elec.khuvuc values(42,'ido42',4510);
    insert into elec.khuvuc values(43,'ido43',char_to_label('access_election','SENS:Q5:TD'));
    insert into elec.khuvuc values(44,'ido44',3530);    
    insert into elec.khuvuc values(45,'ido45',char_to_label('access_election','SENS:Q5:LCT'));
    insert into elec.khuvuc values(46,'ido46',3520);
    insert into elec.khuvuc values(47,'ido47',char_to_label('access_election','CONS:Q5'));
    insert into elec.khuvuc values(48,'ido48',250);
    insert into elec.khuvuc values(49,'ido49',char_to_label('access_election','SENS:Q5,BC'));
    insert into elec.khuvuc values(50,'ido50',350);

-- không thêm được

    insert into elec.khuvuc values(51,'ido51',char_to_label('access_election','PUB:Q3'));
    insert into elec.khuvuc values(51,'ido51',char_to_label('access_election','TOP_SENS'));
    insert into elec.khuvuc values(51,'ido51',char_to_label('access_election','SENS'));
    insert into elec.khuvuc values(51,'ido51',char_to_label('access_election','CONS'));
    insert into elec.khuvuc values(51,'ido51',120);
    insert into elec.khuvuc values(51,'ido51',8776220);


conn elec_giamsat_q4/elec_giamsat_q4;
execute SA_SESSION.SET_LABEL('access_election','TOP_SENS:Q4');
conn elec_giamsat_q4/elec_giamsat_q4;
execute SA_SESSION.RESTORE_DEFAULT_LABELS('access_election');





-- test trigger.======================================================================

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


conn elec_giamsat_q2/elec_giamsat_q2;
execute SA_SESSION.SET_ROW_LABEL('access_election','CONS:Q2');
insert into elec.a_u values(0,'-',USER,char_to_label('access_election','PUB'));



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
insert into elec.a_u values(5,'f',USER,char_to_label('access_election','SENS:Q5,BC'));
insert into elec.a_u values(8,'u',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));

conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_u values(5,'f',USER,char_to_label('access_election','SENS:Q2,BC'));


conn test_null/test_null;
insert into elec.a_u values(6,'g',USER,char_to_label('access_election','CONS:Q1'));
insert into elec.a_u values(8,'u',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));

conn test_null/test_null;
insert into elec.a_u values(6,'g',USER,char_to_label('access_election','CONS:Q5'));

conn testhihi/testhihi;
insert into elec.a_u values(7,'h',USER,char_to_label('access_election','SENS'));


conn testhihi/testhihi;
insert into elec.a_u values(7,'h',USER,char_to_label('access_election','SENS:Q1:TD'));
insert into elec.a_u values(8,'u',USER,char_to_label('access_election','TOP_SENS:Q1,BC:GS'));

conn elec/elec;
insert into a_i values(8,'i');


conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values(9,'k');
conn test_null/test_null;
insert into elec.a_i values(9,'k');

conn testhihi/testhihi;
insert into elec.a_i values(9,'k');



-- do chưa cấp quyền insert vào a_u cho testhihi
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER,100);
end;
/

conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values(10,'J');



-- do chưa cấp quyền insert vào a_u cho testhihi
conn testhihi/testhihi;
create  OR REPLACE TRIGGER a_i_log_a_u
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER,char_to_label('access_election','SENS:Q1,BC'));
end;
/

conn testhihi/testhihi;
insert into elec.a_i values(11,'K');


-- lỗi
conn elec_giamsat_q2/elec_giamsat_q2;
insert into elec.a_i values(12,'L');

-- lỗi
conn test_null/test_null;
insert into elec.a_i values(12,'L');


conn testhihi/testhihi;
insert into elec.a_i values(14,'M');


conn sys/123456 as sysdba;
grant create any trigger to test_null;



conn test_null/test_null;
create  OR REPLACE TRIGGER a_i_log_a_u_testNULL
    before INSERT 
    on elec.a_i
    for EACH ROW
BEGIN
    insert into elec.a_u values (:new.num,:new.cha,USER,char_to_label('access_election','PUB:Q5'));
end;
/

conn test_null/test_null;
insert into elec.a_i values(12,'L');
