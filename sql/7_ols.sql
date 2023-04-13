conn sys/123456 as sysdba
-- -- -- nguoi dung trong ols
-- quan ly nguoi dung trong chinh sach cua ols
GRANT connect, create user, drop user,
create role, drop any role
TO elec_user_manage IDENTIFIED BY elec_user_manage;

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


-- compartment
conn elec_sec_admin/elec_sec_admin;

EXECUTE sa_components.create_group('access_election',10,'GS','GIAM_SAT',NULL);
EXECUTE sa_components.create_group('access_election',20,'LCT','LAP_CU_TRI','GS');
EXECUTE sa_components.create_group('access_election',30,'TD','THEO_DOI','GS');


-- -- tạo nhãn
conn elec_sec_admin/elec_sec_admin;

-- nhãn cho bảng khu vực;
EXECUTE sa_label_admin.create_label('access_election', 100,'PUB');

-- nhãn người giám sát quận 1 + log chọn cử trị quận 1 + lịch sử bầu cử quận 1 + phiếu bầu quận 1;
EXECUTE sa_label_admin.create_label('access_election',4110,'TOP_SENS:QUAN_1:GS');
-- nhãn người giám sát quận 2 + log chọn cử trị quận 2 + lịch sử bầu cử quận 2 + phiếu bầu quận 2;
EXECUTE sa_label_admin.create_label('access_election',4210,'TOP_SENS:QUAN_2:GS');
-- nhãn người giám sát quận 3 + log chọn cử trị quận 3 + lịch sử bầu cử quận 3 + phiếu bầu quận 3;
EXECUTE sa_label_admin.create_label('access_election',4310,'TOP_SENS:QUAN_3:GS');
-- nhãn người giám sát quận 4 + log chọn cử trị quận 4 + lịch sử bầu cử quận 4 + phiếu bầu quận 4;
EXECUTE sa_label_admin.create_label('access_election',4410,'TOP_SENS:QUAN_4:GS');
-- nhãn người giám sát quận 5 + log chọn cử trị quận 5 + lịch sử bầu cử quận 5 + phiếu bầu quận 5;
EXECUTE sa_label_admin.create_label('access_election',4510,'TOP_SENS:QUAN_5:GS');


-- nhãn người theo dõi quận 1 + trang thái cử tri quận 1 + số phiếu quận 1;
EXECUTE sa_label_admin.create_label('access_election',3130,'SENS:QUAN_1:TD');
-- nhãn người theo dõi quận 2 + trang thái cử tri quận 2 + số phiếu quận 2;
EXECUTE sa_label_admin.create_label('access_election',3230,'SENS:QUAN_2:TD');
-- nhãn người theo dõi quận 3 + trang thái cử tri quận 3 + số phiếu quận 3;
EXECUTE sa_label_admin.create_label('access_election',3330,'SENS:QUAN_3:TD');
-- nhãn người theo dõi quận 4 + trang thái cử tri quận 4 + số phiếu quận 4;
EXECUTE sa_label_admin.create_label('access_election',3430,'SENS:QUAN_4:TD');
-- nhãn người theo dõi quận 5 + trang thái cử tri quận 5 + số phiếu quận 5;
EXECUTE sa_label_admin.create_label('access_election',3530,'SENS:QUAN_5:TD');

-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3120,'SENS:QUAN_1:LCT');
-- nhãn người lap cử tri quận 2;
EXECUTE sa_label_admin.create_label('access_election',3220,'SENS:QUAN_2:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3320,'SENS:QUAN_3:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3420,'SENS:QUAN_4:LCT');
-- nhãn người lap cử tri quận 1;
EXECUTE sa_label_admin.create_label('access_election',3520,'SENS:QUAN_5:LCT');



-- nhãn người dân quận 1 + ứng viên 1;
EXECUTE sa_label_admin.create_label('access_election',210,'CONS:QUAN_1');
-- nhãn người dân quận 2 + ứng viên 2;
EXECUTE sa_label_admin.create_label('access_election',220,'CONS:QUAN_2');
-- nhãn người dân quận 3 + ứng viên 3;
EXECUTE sa_label_admin.create_label('access_election',230,'CONS:QUAN_3');
-- nhãn người dân quận 4 + ứng viên 4;
EXECUTE sa_label_admin.create_label('access_election',240,'CONS:QUAN_4');
-- nhãn người dân quận 5 + ứng viên 5;
EXECUTE sa_label_admin.create_label('access_election',250,'CONS:QUAN_5');



-- nhãn người cử tri 1;
EXECUTE sa_label_admin.create_label('access_election',310,'SENS:QUAN_1');
-- nhãn người cử tri 2;
EXECUTE sa_label_admin.create_label('access_election',320,'SENS:QUAN_2');
-- nhãn người cử tri 3;
EXECUTE sa_label_admin.create_label('access_election',330,'SENS:QUAN_3');
-- nhãn người cử tri 4;
EXECUTE sa_label_admin.create_label('access_election',340,'SENS:QUAN_4');
-- nhãn người cử tri 5;
EXECUTE sa_label_admin.create_label('access_election',350,'SENS:QUAN_5');





