conn sys/123456 as sysdba;
grant create any trigger to elec_admin_full;

conn elec_admin_full/elec_admin_full;

create  OR REPLACE TRIGGER tri_lschoncutri
    after INSERT 
    on elec.cutri
    for EACH ROW
DECLARE
    row_label varchar2(100);
BEGIN
    SELECT sa_session.row_label('access_election')
    into row_label
    FROM dual;
    insert into elec.lichsuchoncutri values (:new.cccd,:new.ma_nguoi_lap_cu_tri,:new.thoi_gian,'Insert',char_to_label('access_election',row_label));
end;
/


insert into elec.cutri VALUES(100000003,100000000,CURRENT_TIMESTAMP(9),char_to_label('access_election','SENS:Q1:LCT'));