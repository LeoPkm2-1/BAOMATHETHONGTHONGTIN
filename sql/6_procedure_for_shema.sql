-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec_admin_full/elec_admin_full;

-- thêm cử tri
create or REPLACE PROCEDURE pro_them_cutri(
    in_cccd_cu_tri IN NUMBER,
    in_ma_nguoi_lap_cu_tri IN NUMBER
)is
    comp_write varchar2(100);
    level_write varchar2(100);
begin
    SELECT sa_session.comp_write('access_election')
    into comp_write
    FROM dual;
    -- dbms_output.put_line(comp_write);
    SELECT sa_session.max_level('access_election')
    into level_write
    FROM dual;
    -- dbms_output.put_line(level_write);
    insert into elec.cutri VALUES(in_cccd_cu_tri,in_ma_nguoi_lap_cu_tri,CURRENT_TIMESTAMP(9),char_to_label('access_election',level_write||':' || comp_write));
    commit;
end;
/
GRANT execute ON pro_them_cutri TO elec_role_lapcutri;





-- thêm phiếu bầu
create or replace PROCEDURE pro_them_phieubau(
    in_cccd_cu_tri IN NUMBER,
    in_maungvien IN NUMBER
)is
    row_label varchar2(100);
begin
    SELECT sa_session.row_label('access_election')
    into row_label
    FROM dual;
    insert into elec.phieubau values(in_cccd_cu_tri,in_maungvien,CURRENT_TIMESTAMP(9),char_to_label('access_election',row_label));
    commit;
end;
/

GRANT execute ON pro_them_phieubau TO elec_dan_q1;
GRANT execute ON pro_them_phieubau TO elec_dan_q2;
GRANT execute ON pro_them_phieubau TO elec_dan_q3;
GRANT execute ON pro_them_phieubau TO elec_dan_q4;
GRANT execute ON pro_them_phieubau TO elec_dan_q5;




create or replace procedure pro_xoa_phieubau(
    in_cccd_cu_tri IN NUMBER

)is
begin
    delete elec.phieubau where cccd_cutri = in_cccd_cu_tri;
    commit;
end;
/

GRANT execute ON pro_xoa_phieubau TO elec_dan_q1;
GRANT execute ON pro_xoa_phieubau TO elec_dan_q2;
GRANT execute ON pro_xoa_phieubau TO elec_dan_q3;
GRANT execute ON pro_xoa_phieubau TO elec_dan_q4;
GRANT execute ON pro_xoa_phieubau TO elec_dan_q5;



