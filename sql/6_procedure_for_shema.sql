-- kết nối với hệ quản trị cơ sở dữ liệu
conn elec_admin_full/elec_admin_full;

-- thêm cử tri
create or REPLACE PROCEDURE pro_them_cutri(
    in_cccd_cu_tri IN NUMBER,
    in_ma_nguoi_lap_cu_tri IN NUMBER
)is
    row_label varchar2(100);
begin
    SELECT sa_session.row_label('access_election')
    into row_label
    FROM dual;
    insert into elec.cutri VALUES(in_cccd_cu_tri,in_ma_nguoi_lap_cu_tri,CURRENT_TIMESTAMP(9),char_to_label('access_election',row_label));
end;
/
GRANT execute ON pro_them_cutri TO elec_role_lapcutri;



